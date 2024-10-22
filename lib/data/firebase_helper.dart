import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcc/data/firebase_auth/firebase_auth_helper.dart';
import 'package:dcc/data/firebase_storage/firebase_storage_helper.dart';
import 'package:dcc/data/firestore/firestore_helper.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static Future<void> initializeFirebaseApp(
    FirestoreConfiguration firestoreConfiguration,
  ) async {
    FirebaseApp appInstance;

    /* Initialize FirebaseApp */
    String projectId = firestoreConfiguration.projectId;
    String firebaseDatabaseUrl = "https://" + projectId + ".firebaseio.com";
    String storageBucket = "$projectId.appspot.com";
    FirebaseOptions options = FirebaseOptions(
      apiKey: firestoreConfiguration.apiKey,
      databaseURL: firebaseDatabaseUrl,
      projectId: projectId,
      appId: firestoreConfiguration.googleAppId,
      messagingSenderId: firestoreConfiguration.messagingSenderId,
      storageBucket: storageBucket,
    );
    String firestoreAppName = FirestoreHelper.FIRESTORE_INSTANCE_NAME + "-" + firestoreConfiguration.projectId;

    /* The Firebase libraries *insists* on the default app being initialized
       * before anything else - even if we do not need it directly.
       */
    await Firebase.initializeApp();
    try {
      /* Support hot reloading by checking if the app exists */
      appInstance = Firebase.app(firestoreAppName);
    } on FirebaseException {
      appInstance = await Firebase.initializeApp(name: firestoreAppName, options: options);
    }
    // Use the app with the default Firestore instance by updating
    // the default FirestorePlatform instance.

    FirestoreHelper.instance = FirebaseFirestore.instanceFor(app: appInstance);
    FirebaseAuthHelper.instance = FirebaseAuth.instanceFor(app: appInstance);
    FirebaseStorageHelper.instance = FirebaseStorage.instanceFor(app: appInstance);
  }
}
