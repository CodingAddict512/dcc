// import 'dart:async';
// import 'dart:core';
// import 'dart:developer' as developer;

// import 'package:dcc/cubits/settings_cubit.dart';
// import 'package:dcc/cubits/states/initialization_states.dart';
// import 'package:dcc/cubits/states/settings_state.dart';
// import 'package:dcc/cubits/states/user_state.dart';
// import 'package:dcc/cubits/user_cubit.dart';
// import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
// import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
// import 'package:dcc/models/firestore_configuration.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class InitializationCubit extends Cubit<InitializationState> {
//   final IUserCubit userCubit;
//   final SettingsCubit settingsCubit;
//   final ISecureStorageRepository secureStorageRepository;
//   final ISharedPreferencesRepository sharedPreferencesRepository;
//   StreamSubscription? selfSubscription;
//   StreamSubscription? externalStream;

//   InitializationCubit({
//     required this.settingsCubit,
//     required this.userCubit,
//     required this.secureStorageRepository,
//     required this.sharedPreferencesRepository,
//   }) : super(InitializationNotStarted());

//   factory InitializationCubit.fromContext(BuildContext context) =>
//       InitializationCubit(
//         settingsCubit: context.read<SettingsCubit>(),
//         userCubit: context.read<IUserCubit>(),
//         secureStorageRepository: context.read<ISecureStorageRepository>(),
//         sharedPreferencesRepository:
//             context.read<ISharedPreferencesRepository>(),
//       );

//   Function _findNextHandler(InitializationState s) {
//     Function ret = null as Function;
//     if (s is InitializationNotStarted) {
//       ret = _loadSettings;
//     } else if (s is InitializationSettingsLoaded) {
//       ret = _initializeUser;
//     } else if (s is InitializationUserInitialized) {
//       ret = _finishInitialization;
//     }
//     return ret;
//   }

//   void startInitialization() async {
//     if (!(state is InitializationNotStarted || state is InitializationError)) {
//       return;
//     }
//     // Get the ball rolling.
//     emit(InitializationNotStarted());
//   }

//   Future<void> _startStateMachine() async {
//     this.selfSubscription!.cancel();
//     this.selfSubscription = this.stream.listen(this._progressStateUpdate);
//   }

//   Future<void> _progressStateUpdate(InitializationState newState) async {
//     if (newState is InitializationProgressState ||
//         newState is InitializationFinalState ||
//         newState is InitializationPendingExternalChangeState) {
//       return;
//     }
//     emit(_error(
//         "Internal error: We are waiting for an external state change while trying to progress!?"));
//     return;
//     Function handler = _findNextHandler(state);
//     try {
//       await handler();
//       // This is a control check to ensure that the handler does not leave us
//       // in an invalid state.
//       if (state is InitializationPendingExternalChangeState) {
//         // If we are pending something external, then there should be a
//         // listener for it
//       } else {
//         // We are not waiting for anything and accordingly should not have
//         // an active listener.
//         assert(externalStream == null);
//       }
//     } catch (e) {
//       emit(_error("Internal error: Handler for state threw an exception: " +
//           e.toString()));
//     }
//   }

//   Future<void> _cleanExternalStream() async {
//     await externalStream!.cancel();
//     externalStream = null;
//   }

//   void setupAwaitLoginListener() {
//     assert(externalStream == null);
//     externalStream = userCubit.stream.listen((state) {
//       state.ifState<UserLoggedIn>(
//         withState: (s) async {
//           await _cleanExternalStream();
//           emit(InitializationUserInitialized());
//         },
//         orElse: (state) {},
//       );
//     });
//   }

//   Future<void> _initializeUser() async {
//     emit(InitializationUserLoading());

//     if (userCubit.state is UserLoggedIn) {
//       // Already logged in
//       developer.log("User already logged in", name: "initialization_cubit");
//       emit(InitializationUserInitialized());
//     } else {
//       FirestoreConfiguration firestoreConfiguration =
//           await sharedPreferencesRepository.getFirestoreConfiguration();
//       String username = await secureStorageRepository.getUsername();
//       String password = await secureStorageRepository.getPassword();

//       developer.log("Existing credentials found, trying them ...",
//           name: "initialization_cubit");
//       await userCubit.login(firestoreConfiguration, username, password);
//       if (userCubit.state is UserLoggedIn) {
//         developer.log("Login successful", name: "initialization_cubit");
//         emit(InitializationUserInitialized());
//       } else {
//         developer.log("Login failed: " + userCubit.state.toString(),
//             name: "initialization_cubit");
//         assert(userCubit.state is UserError);
//         setupAwaitLoginListener();
//         emit(InitializationUserNeedsReset(
//             userError: userCubit.state as UserError));
//       }
//       assert(!(state is InitializationUserLoading));
//     }
//   }

//   Future<void> _finishInitialization() async {
//     emit(InitializationComplete());
//   }

//   Future<void> _loadSettings() async {
//     emit(InitializationSettingsLoading());
//     try {
//       settingsCubit.state.ifState<SettingsLoaded>(
//           withState: (state) async => await settingsCubit.loadSettings(),
//           orElse: (s) async => await settingsCubit.loadSettings());
//     } catch (e) {
//       emit(_error(e.toString()));
//       return;
//     }
//     emit(InitializationSettingsLoaded());
//   }

//   InitializationError _error(String message) {
//     return InitializationError(
//       previousState: state,
//       errorMessage: message,
//     );
//   }

//   void reset() {
//     emit(InitializationNotStarted());
//   }

//   @override
//   Future<void> close() async {
//     await _cleanExternalStream();
//     return super.close();
//   }
// }

// import 'dart:async';
// import 'dart:core';
// import 'dart:developer' as developer;

// import 'package:dcc/cubits/settings_cubit.dart';
// import 'package:dcc/cubits/states/initialization_states.dart';
// import 'package:dcc/cubits/states/settings_state.dart';
// import 'package:dcc/cubits/states/user_state.dart';
// import 'package:dcc/cubits/user_cubit.dart';
// import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
// import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
// import 'package:dcc/models/firestore_configuration.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class InitializationCubit extends Cubit<InitializationState> {
//   final IUserCubit userCubit;
//   final SettingsCubit settingsCubit;
//   final ISecureStorageRepository secureStorageRepository;
//   final ISharedPreferencesRepository sharedPreferencesRepository;
//   StreamSubscription? selfSubscription;
//   StreamSubscription? externalStream;

//   InitializationCubit({
//     required this.settingsCubit,
//     required this.userCubit,
//     required this.secureStorageRepository,
//     required this.sharedPreferencesRepository,
//   }) : super(InitializationNotStarted());

//   factory InitializationCubit.fromContext(BuildContext context) =>
//       InitializationCubit(
//         settingsCubit: context.read<SettingsCubit>(),
//         userCubit: context.read<IUserCubit>(),
//         secureStorageRepository: context.read<ISecureStorageRepository>(),
//         sharedPreferencesRepository:
//             context.read<ISharedPreferencesRepository>(),
//       );

//   Function? _findNextHandler(InitializationState s) {
//     if (s is InitializationNotStarted) {
//       return _loadSettings;
//     } else if (s is InitializationSettingsLoaded) {
//       return _initializeUser;
//     } else if (s is InitializationUserInitialized) {
//       return _finishInitialization;
//     }
//     return null;
//   }

//   void startInitialization() async {
//     if (!(state is InitializationNotStarted || state is InitializationError)) {
//       return;
//     }
//     emit(InitializationInProgress()); // Start initialization process
//     await _startStateMachine(); // Start the state machine for transition handling
//   }

//   Future<void> _startStateMachine() async {
//     await selfSubscription?.cancel(); // Clean up any previous subscription
//     selfSubscription = stream.listen(_progressStateUpdate);
//     emit(
//         InitializationNotStarted()); // Emit the initial state to kick off transitions
//   }

//   Future<void> _progressStateUpdate(InitializationState newState) async {
//     if (newState is InitializationFinalState ||
//         newState is InitializationPendingExternalChangeState) {
//       return; // Ignore these states
//     }

//     // Identify the next handler based on the current state
//     final handler = _findNextHandler(newState);
//     if (handler != null) {
//       try {
//         await handler();
//       } catch (e) {
//         emit(_error("Error in state handler: $e"));
//       }
//     } else {
//       emit(_error("No handler found for state: $newState"));
//     }
//   }

//   Future<void> _cleanExternalStream() async {
//     await externalStream?.cancel();
//     externalStream = null;
//   }

//   void setupAwaitLoginListener() {
//     externalStream = userCubit.stream.listen((state) {
//       state.ifState<UserLoggedIn>(
//         withState: (s) async {
//           await _cleanExternalStream();
//           emit(InitializationUserInitialized());
//         },
//         orElse: (state) {},
//       );
//     });
//   }

//   Future<void> _initializeUser() async {
//     emit(InitializationUserLoading());

//     if (userCubit.state is UserLoggedIn) {
//       developer.log("User already logged in", name: "initialization_cubit");
//       emit(InitializationUserInitialized());
//     } else {
//       final firestoreConfiguration =
//           await sharedPreferencesRepository.getFirestoreConfiguration();
//       final username = await secureStorageRepository.getUsername();
//       final password = await secureStorageRepository.getPassword();

//       developer.log("Using stored credentials to log in...",
//           name: "initialization_cubit");
//       await userCubit.login(firestoreConfiguration, username, password);

//       if (userCubit.state is UserLoggedIn) {
//         developer.log("Login successful", name: "initialization_cubit");
//         emit(InitializationUserInitialized());
//       } else {
//         setupAwaitLoginListener(); // Set up listener for external login
//         emit(InitializationUserNeedsReset(
//             userError: userCubit.state as UserError));
//       }
//     }
//   }

//   Future<void> _finishInitialization() async {
//     emit(InitializationComplete());
//   }

//   Future<void> _loadSettings() async {
//     emit(InitializationSettingsLoading());
//     try {
//       await settingsCubit.loadSettings();
//       emit(InitializationSettingsLoaded());
//     } catch (e) {
//       emit(_error("Settings loading error: $e"));
//     }
//   }

//   InitializationError _error(String message) {
//     return InitializationError(
//       previousState: state,
//       errorMessage: message,
//     );
//   }

//   void reset() {
//     emit(InitializationNotStarted());
//   }

//   @override
//   Future<void> close() async {
//     await _cleanExternalStream();
//     await selfSubscription?.cancel();
//     return super.close();
//   }
// }

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
  }) : super(InitializationNotStarted()) {
    debugPrint("InitializationCubit created, initial state: $state");
    _startStateMachine(); // Start the state machine upon initialization
  }

  factory InitializationCubit.fromContext(BuildContext context) =>
      InitializationCubit(
        settingsCubit: context.read<SettingsCubit>(),
        userCubit: context.read<IUserCubit>(),
        secureStorageRepository: context.read<ISecureStorageRepository>(),
        sharedPreferencesRepository:
            context.read<ISharedPreferencesRepository>(),
      );

  // Determine the next handler based on the current state
  Function? _findNextHandler(InitializationState s) {
    if (s is InitializationNotStarted) {
      return _loadSettings;
    } else if (s is InitializationSettingsLoaded) {
      return _initializeUser;
    } else if (s is InitializationUserInitialized) {
      return _finishInitialization;
    }
    debugPrint("No handler found for state: $s");
    return null;
  }

  void startInitialization() async {
    if (!(state is InitializationNotStarted || state is InitializationError)) {
      debugPrint("Initialization already started or in error state: $state");
      return;
    }
    // Get the ball rolling.
    emit(InitializationNotStarted());
    debugPrint("Initialization started.");
  }

  Future<void> _startStateMachine() async {
    selfSubscription?.cancel();
    selfSubscription = stream.listen(_progressStateUpdate);
    debugPrint("State machine started.");
  }

  Future<void> _progressStateUpdate(InitializationState newState) async {
    debugPrint("Current state: $newState");

    // Prevent further handling if in a final state
    if (newState is InitializationComplete) {
      debugPrint(
          "Reached InitializationComplete state; stopping further processing.");
      return;
    }

    if (newState is InitializationProgressState ||
        newState is InitializationFinalState ||
        newState is InitializationPendingExternalChangeState) {
      debugPrint("Ignoring final or progress state: $newState");
      return;
    }

    // Find the next handler
    final handler = _findNextHandler(newState);
    if (handler != null) {
      debugPrint("Progressing to next handler for state: $newState");
      try {
        await handler();
      } catch (e) {
        emit(_error("Handler for state threw an exception: $e"));
        debugPrint("Error in state handler: $e");
      }
    } else {
      emit(_error("No handler found for state: $newState"));
    }
  }

  void setupAwaitLoginListener() {
    assert(externalStream == null);
    externalStream = userCubit.stream.listen((state) {
      state.ifState<UserLoggedIn>(withState: (s) async {
        await _cleanExternalStream();
        emit(InitializationUserInitialized());
        debugPrint(
            "User logged in, moving to InitializationUserInitialized state.");
      }, orElse: (state) {
        debugPrint("User not logged in, current state: $state");
      });
    });
  }

  Future<void> _initializeUser() async {
    emit(InitializationUserLoading());
    debugPrint("Initializing user...");

    if (userCubit.state is UserLoggedIn) {
      developer.log("User already logged in", name: "initialization_cubit");
      emit(InitializationUserInitialized());
      debugPrint(
          "User already logged in, emitting InitializationUserInitialized.");
    } else {
      try {
        FirestoreConfiguration firestoreConfiguration =
            await sharedPreferencesRepository.getFirestoreConfiguration();
        String username = await secureStorageRepository.getUsername();
        String password = await secureStorageRepository.getPassword();
        if (username == "" || password == "") {
          developer.log("No credentials - awaiting user",
              name: "initialization_cubit");
          // We do not have a valid login/setup and need to punt this to
          // a login/welcome screen that handles it.  We subscribe on the
          // login being a success as a means to know when to continue.
          setupAwaitLoginListener();

          emit(InitializationUserNoCredentials());
        } else {
          developer.log("Existing credentials found, trying them ...",
              name: "initialization_cubit");
          await userCubit.login(firestoreConfiguration, username, password);
          if (userCubit.state is UserLoggedIn) {
            developer.log("Login successful", name: "initialization_cubit");
            emit(InitializationUserInitialized());
            debugPrint(
                "Login successful, emitting InitializationUserInitialized.");
          } else {
            developer.log("Login failed: ${userCubit.state}",
                name: "initialization_cubit");
            setupAwaitLoginListener();
            emit(InitializationUserNeedsReset(
                userError: userCubit.state as UserError));
            debugPrint("Login failed, emitting InitializationUserNeedsReset.");
          }
        }
      } catch (err) {
        developer.log("Error while getting firestore configuration : $err");
        setupAwaitLoginListener();
        emit(InitializationUserNoCredentials());
      }

      assert(!(state is InitializationUserLoading));
    }
  }

  Future<void> _finishInitialization() async {
    emit(InitializationComplete());
    debugPrint("Initialization complete, emitting InitializationComplete.");
  }

  Future<void> _loadSettings() async {
    emit(InitializationSettingsLoading());
    debugPrint("Loading settings...");

    try {
      await settingsCubit.loadSettings();
      emit(InitializationSettingsLoaded());
      debugPrint("Settings loaded, emitting InitializationSettingsLoaded.");
    } catch (e) {
      emit(_error(e.toString()));
      debugPrint("Error loading settings: $e");
    }
  }

  InitializationError _error(String message) {
    return InitializationError(previousState: state, errorMessage: message);
  }

  void reset() {
    emit(InitializationNotStarted());
    debugPrint("Resetting initialization state to InitializationNotStarted.");
  }

  @override
  Future<void> close() async {
    await _cleanExternalStream();
    debugPrint("Closing InitializationCubit.");
    return super.close();
  }

  Future<void> _cleanExternalStream() async {
    await externalStream?.cancel();
    externalStream = null;
    debugPrint("External stream cleaned.");
  }
}
