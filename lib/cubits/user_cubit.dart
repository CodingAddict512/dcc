import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/data/repositories/user_repository_interface.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:dcc/models/user.dart';
import 'package:dcc/models/user_error_type.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

abstract class IUserCubit extends Cubit<UserState> {
  IUserCubit(UserState state) : super(state);

  Future<void> login(FirestoreConfiguration firestoreConfiguration,
      String username, String password) async {
    emit(UserLoading());
    final result = await signInWithEmailAndPassword(
        firestoreConfiguration, username, password);
    emit(result);
  }

  Future<UserState> devLoginWithEmailAndPassword(
      FirestoreConfiguration firestoreConfiguration,
      String email,
      String password) async {
    UserState state = await signInWithEmailAndPassword(
        firestoreConfiguration, email, password);
    emit(state);
    return state;
  }

  Future<void> otpLogin(String email, String otp, String verifyUrl) async {
    emit(UserLoading());
    final result = await performOTPLogin(email, otp, verifyUrl);
    emit(result);
  }

  @protected
  Future<UserState> signInWithEmailAndPassword(
      FirestoreConfiguration firestoreConfiguration,
      String username,
      String password);

  @protected
  Future<UserState> performOTPLogin(String email, String otp, String verifyUrl);

  Future<void> clearLoginCacheAndReset();
}

class UserCubit extends IUserCubit {
  final IUserRepository userRepository;
  final ISecureStorageRepository secureStorageRepository;
  final ISharedPreferencesRepository sharedPreferencesRepository;

  UserCubit({
    required this.userRepository,
    required this.secureStorageRepository,
    required this.sharedPreferencesRepository,
  }) : super(UserInitial());

  factory UserCubit.fromContext(BuildContext context) => UserCubit(
        userRepository: context.read<IUserRepository>(),
        secureStorageRepository: context.read<ISecureStorageRepository>(),
        sharedPreferencesRepository:
            context.read<ISharedPreferencesRepository>(),
      );

  Future<UserState> devLoginWithEmailAndPassword(
      FirestoreConfiguration firestoreConfiguration,
      String email,
      String password) async {
    UserState state = await super
        .devLoginWithEmailAndPassword(firestoreConfiguration, email, password);
    if (!(state is UserError)) {
      await sharedPreferencesRepository
          .setFirestoreConfiguration(firestoreConfiguration);
      await secureStorageRepository.setUsername(email);
      await secureStorageRepository.setPassword(password);
    }
    return state;
  }

  Future<UserState> signInWithEmailAndPassword(
      FirestoreConfiguration firestoreConfiguration,
      String email,
      String password) async {
    try {
      User user = await userRepository.signInWithEmailAndPassword(
          firestoreConfiguration, email, password);
      if (user.transporterId == null) {
        return UserError(
          message: "", // Message is received from the UserErrorType.
          errorType: UserErrorType.LOGIN_VALID_BUT_NOT_ASSIGNED_TO_TRANSPORTER,
        );
      }
      return UserLoggedIn(
        transporterId: user.transporterId,
        // TODO: Update firebase to use email as driver id
        driverId: user.driverId,
      );
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      return UserError.fromException(e as Exception);
    }
  }

  Future<UserState> performOTPLogin(
      String email, String otp, String verifyUrl) async {
    try {
      Tuple2<FirestoreConfiguration, String> result =
          await userRepository.verifyOtp(otp, verifyUrl);
      FirestoreConfiguration configuration = result.item1;
      String password = result.item2;

      // Save email and password to secure storage
      await secureStorageRepository.setUsername(email);
      await secureStorageRepository.setPassword(password);

      // Login with email and new password
      return signInWithEmailAndPassword(configuration, email, password);
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      return UserError.fromException(e as Exception);
    }
  }

  Future<void> clearLoginCacheAndReset() async {
    emit(UserLoading());
    await secureStorageRepository.deleteAll();
    await sharedPreferencesRepository.clearAll();
    emit(UserInitial());
  }
}
