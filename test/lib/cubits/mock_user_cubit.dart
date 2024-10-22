import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/models/firestore_configuration.dart';

class MockUserCubit extends IUserCubit {
  String transporterId = "0";
  String driverId = "1234";
  UserState Function(FirestoreConfiguration, String, String) loginMock;
  UserState Function(String, String, String) otpMock;

  MockUserCubit() : super(UserInitial());

  Future<UserState> signInWithEmailAndPassword(FirestoreConfiguration firestoreConfiguration, String username, String password) async {
    if (loginMock != null) {
      return loginMock(firestoreConfiguration, username, password);
    }
    return UserLoggedIn(
      transporterId: transporterId,
      driverId: driverId,
    );
  }

  Future<UserState> performOTPLogin(String email, String otp, String verifyUrl) async {
    if (otpMock != null) {
      return otpMock(email, otp, verifyUrl);
    }
    return UserLoggedIn(
      transporterId: transporterId,
      driverId: driverId,
    );
  }

  Future<void> clearLoginCacheAndReset() async {
    emit(UserLoading());
    emit(UserInitial());
  }
}
