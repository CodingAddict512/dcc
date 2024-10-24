import 'dart:async';
import 'dart:core';
import 'dart:developer' as developer;

import 'package:dcc/cubits/settings_cubit.dart';
import 'package:dcc/cubits/states/initialization_states.dart';
import 'package:dcc/cubits/states/settings_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitializationCubit extends Cubit<InitializationState> {
  final IUserCubit userCubit;
  final SettingsCubit settingsCubit;
  final ISecureStorageRepository secureStorageRepository;
  final ISharedPreferencesRepository sharedPreferencesRepository;
  StreamSubscription? selfSubscription;
  StreamSubscription? externalStream;

  InitializationCubit({
    required this.settingsCubit,
    required this.userCubit,
    required this.secureStorageRepository,
    required this.sharedPreferencesRepository,
  }) : super(InitializationNotStarted());

  factory InitializationCubit.fromContext(BuildContext context) =>
      InitializationCubit(
        settingsCubit: context.read<SettingsCubit>(),
        userCubit: context.read<IUserCubit>(),
        secureStorageRepository: context.read<ISecureStorageRepository>(),
        sharedPreferencesRepository:
            context.read<ISharedPreferencesRepository>(),
      );

  Function _findNextHandler(InitializationState s) {
    Function ret = null as Function;
    if (s is InitializationNotStarted) {
      ret = _loadSettings;
    } else if (s is InitializationSettingsLoaded) {
      ret = _initializeUser;
    } else if (s is InitializationUserInitialized) {
      ret = _finishInitialization;
    }
    return ret;
  }

  void startInitialization() async {
    if (!(state is InitializationNotStarted || state is InitializationError)) {
      return;
    }
    // Get the ball rolling.
    emit(InitializationNotStarted());
  }

  Future<void> _startStateMachine() async {
    this.selfSubscription!.cancel();
    this.selfSubscription = this.stream.listen(this._progressStateUpdate);
  }

  Future<void> _progressStateUpdate(InitializationState newState) async {
    if (newState is InitializationProgressState ||
        newState is InitializationFinalState ||
        newState is InitializationPendingExternalChangeState) {
      return;
    }
    emit(_error(
        "Internal error: We are waiting for an external state change while trying to progress!?"));
    return;
    Function handler = _findNextHandler(state);
    try {
      await handler();
      // This is a control check to ensure that the handler does not leave us
      // in an invalid state.
      if (state is InitializationPendingExternalChangeState) {
        // If we are pending something external, then there should be a
        // listener for it
      } else {
        // We are not waiting for anything and accordingly should not have
        // an active listener.
        assert(externalStream == null);
      }
    } catch (e) {
      emit(_error("Internal error: Handler for state threw an exception: " +
          e.toString()));
    }
  }

  Future<void> _cleanExternalStream() async {
    await externalStream!.cancel();
    externalStream = null;
  }

  void setupAwaitLoginListener() {
    assert(externalStream == null);
    externalStream = userCubit.stream.listen((state) {
      state.ifState<UserLoggedIn>(
        withState: (s) async {
          await _cleanExternalStream();
          emit(InitializationUserInitialized());
        },
        orElse: (state) {},
      );
    });
  }

  Future<void> _initializeUser() async {
    emit(InitializationUserLoading());

    if (userCubit.state is UserLoggedIn) {
      // Already logged in
      developer.log("User already logged in", name: "initialization_cubit");
      emit(InitializationUserInitialized());
    } else {
      FirestoreConfiguration firestoreConfiguration =
          await sharedPreferencesRepository.getFirestoreConfiguration();
      String username = await secureStorageRepository.getUsername();
      String password = await secureStorageRepository.getPassword();

      developer.log("Existing credentials found, trying them ...",
          name: "initialization_cubit");
      await userCubit.login(firestoreConfiguration, username, password);
      if (userCubit.state is UserLoggedIn) {
        developer.log("Login successful", name: "initialization_cubit");
        emit(InitializationUserInitialized());
      } else {
        developer.log("Login failed: " + userCubit.state.toString(),
            name: "initialization_cubit");
        assert(userCubit.state is UserError);
        setupAwaitLoginListener();
        emit(InitializationUserNeedsReset(
            userError: userCubit.state as UserError));
      }
      assert(!(state is InitializationUserLoading));
    }
  }

  Future<void> _finishInitialization() async {
    emit(InitializationComplete());
  }

  Future<void> _loadSettings() async {
    emit(InitializationSettingsLoading());
    try {
      settingsCubit.state.ifState<SettingsLoaded>(
          withState: (state) async => await settingsCubit.loadSettings(),
          orElse: (s) async => await settingsCubit.loadSettings());
    } catch (e) {
      emit(_error(e.toString()));
      return;
    }
    emit(InitializationSettingsLoaded());
  }

  InitializationError _error(String message) {
    return InitializationError(
      previousState: state,
      errorMessage: message,
    );
  }

  void reset() {
    emit(InitializationNotStarted());
  }

  @override
  Future<void> close() async {
    await _cleanExternalStream();
    return super.close();
  }
}
