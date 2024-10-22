import 'package:dcc/models/user_error_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

extension UserErrorTypeExtension on UserErrorType {
  static const Map<String, UserErrorType> errorMap = {
    "user-disabled": UserErrorType.USER_DISABLED,
  };

  String name() {
    return describeEnum(this);
  }

  String messageTranslationKey() {
    return "userErrorType/" + this.name();
  }

  static UserErrorType fromFirebaseAuthException(FirebaseAuthException ex) {
    return errorMap[ex.code] ?? UserErrorType.UNKNOWN;
  }
}
