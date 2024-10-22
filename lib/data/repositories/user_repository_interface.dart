import 'package:dcc/models/firestore_configuration.dart';
import 'package:dcc/models/user.dart';
import 'package:tuple/tuple.dart';

abstract class IUserRepository {
  Future<User> signInWithEmailAndPassword(FirestoreConfiguration firestoreConfiguration, String email, String password);
  Future<Tuple2<FirestoreConfiguration, String>> verifyOtp(String otp, String verifyUrl);
}
