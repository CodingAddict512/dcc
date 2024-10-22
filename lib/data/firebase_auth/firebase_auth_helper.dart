import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  static FirebaseAuth instance;

  static Future<User> signInWithEmailAndPassword(String email, String password) async {
    assert (instance != null);
    await instance.signInWithEmailAndPassword(email: email, password: password);
    return instance.currentUser;
  }
}
