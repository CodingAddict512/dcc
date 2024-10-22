import 'package:dcc/data/repositories/user_repository_interface.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:dcc/models/user.dart';
import 'package:tuple/tuple.dart';

class MockUserRepository extends IUserRepository {

  FirestoreConfiguration firestoreConfiguration = FirestoreConfiguration(
    apiKey: "apiKey-1234",
    googleAppId: "appId-1234",
    projectId: "projectId-1234",
    messagingSenderId: "messageSenderId-1234",
  );

  String transporterId = "0";
  String driverId = "1234";

  MockUserRepository({
    this.transporterId = "0",
    this.driverId = "1234",
  });

  Future<User> signInWithEmailAndPassword(FirestoreConfiguration firestoreConfiguration, String email, String password) async {
    return User(
      transporterId: transporterId,
      driverId: driverId,
    );
  }

  Future<Tuple2<FirestoreConfiguration, String>> verifyOtp(String otp, String verifyUrl) async {
    return Tuple2(firestoreConfiguration, "Test1234");
  }
}
