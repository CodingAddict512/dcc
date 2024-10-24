import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:dcc/data/firebase_auth/firebase_auth_helper.dart';
import 'package:dcc/data/firebase_helper.dart';
import 'package:dcc/data/http/web_request_helper.dart';
import 'package:dcc/data/repositories/exceptions/user_repository_exceptions.dart';
import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/data/repositories/user_repository_interface.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:dcc/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:tuple/tuple.dart';

class UserRepository implements IUserRepository {
  final ISharedPreferencesRepository sharedPreferencesRepository;

  UserRepository({
    required this.sharedPreferencesRepository,
  });

  @override
  Future<User> signInWithEmailAndPassword(
      FirestoreConfiguration firestoreConfiguration,
      String email,
      String password) async {
    developer.log("Initializing Firebase App ...", name: "user_repository");
    await FirebaseHelper.initializeFirebaseApp(firestoreConfiguration);
    developer.log("Performing sign-in via FirebaseAuthHelper ...",
        name: "user_repository");
    fb.User user =
        await FirebaseAuthHelper.signInWithEmailAndPassword(email, password);
    developer.log("Sign in complete - Fetching the user ID token ...",
        name: "user_repository");
    final idToken = await user.getIdTokenResult();
    final String transporterId = idToken.claims!['transporterUUID'];

    return User(
      transporterId: transporterId,
      driverId: user.uid,
    );
  }

  @override
  // Return only password for now FIXME: return rest of response
  Future<Tuple2<FirestoreConfiguration, String>> verifyOtp(
      String otp, String verifyUrl) async {
    String platform() {
      if (Platform.isAndroid) {
        return "ANDROID";
      } else if (Platform.isIOS) {
        return "IOS";
      } else {
        return "UNKNOWN";
      }
    }

    Map<String, String> bodyMap = {
      "otp": otp,
      "phoneType": platform(),
    };
    String body = json.encode(bodyMap);
    final resp = await WebRequestHelper.makePostRequest(verifyUrl, body);
    if (resp.statusCode >= 500) {
      throw DCCServerReportsIssuesException();
    }
    if (resp.statusCode == 400) {
      String message = "";
      try {
        final respMap = jsonDecode(resp.body);
        if (respMap is Map) {
          if (respMap.containsKey("errors")) {
            message = respMap["errors"][0]["message"];
          } else {
            message = respMap["message"];
          }
        } else {
          message = "";
        }
      } catch (e) {
        // Fallback to a generic error.
      }

      if (message.contains("OTP already used")) {
        throw OTPAlreadyUsedException();
      }
      if (message.contains("expired")) {
        throw OTPExpiredException();
      }
      if (message.contains("invalid") || message.contains("not valid")) {
        throw OTPIncorrectException();
      }

      throw OTPRejectedForUnknownReason();
    }
    if (resp.statusCode != 200) {
      throw Exception(
          "Unexpected status code in otp response: ${resp.statusCode}.");
    }

    final respMap = jsonDecode(resp.body);
    if (!(respMap is Map)) {
      throw Exception("Decoded JSON root object is not a map.");
    }

    final firestorePassword = respMap['firestorePassword'];
    if (firestorePassword == null) {
      throw Exception("JSON response does not contain firestore password.");
    }

    final apiKey = respMap['appApiKey'];
    final googleAppId = respMap['googleAppId'];
    final projectId = respMap['firestoreProjectId'];
    final messagingSenderId = respMap['messagingSenderId'];

    if (apiKey == null) {
      throw Exception("JSON response does not contain application api key.");
    }
    if (googleAppId == null) {
      throw Exception("JSON response does not contain Google app id.");
    }
    if (projectId == null) {
      throw Exception("JSON response does not contain Firebase project id.");
    }
    if (messagingSenderId == null) {
      throw Exception("JSON response does not contain messaging sender id.");
    }

    final FirestoreConfiguration configuration = FirestoreConfiguration(
      apiKey: apiKey,
      googleAppId: googleAppId,
      projectId: projectId,
      messagingSenderId: messagingSenderId,
    );

    await sharedPreferencesRepository.setFirestoreConfiguration(configuration);

    return Tuple2(configuration, firestorePassword as String);
  }
}
