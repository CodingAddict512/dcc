import 'package:dcc/cubits/states/base_state.dart';
import 'package:dcc/data/repositories/exceptions/user_repository_exceptions.dart';
import 'package:dcc/models/user_error_type.dart';
import 'package:dcc/extensions/user_error_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'user_state.freezed.dart';

@immutable
abstract class UserState extends BaseState {
  const UserState();

  bool isLoggedIn() {
    return false;
  }
}

@freezed
abstract class UserInitial extends UserState with _$UserInitial {
  UserInitial._();

  factory UserInitial() = _UserInitial;
}

@freezed
abstract class UserLoading extends UserState with _$UserLoading {
  UserLoading._();

  factory UserLoading() = _UserLoading;
}


@freezed
abstract class UserLoggedIn extends UserState with _$UserLoggedIn {
  UserLoggedIn._();

  factory UserLoggedIn({
    final String driverId,
    final String transporterId,
  }) = _UserLoggedIn;

  bool isLoggedIn() {
    return true;
  }
}


@freezed
abstract class UserError extends UserState with _$UserError {
  UserError._();

  factory UserError({
    final String message,
    final UserErrorType errorType,
  }) = _UserError;

  factory UserError.fromException(Exception e) {
    UserErrorType errorType = UserErrorType.UNKNOWN;
    if (e is FirebaseAuthException) {
      errorType = UserErrorTypeExtension.fromFirebaseAuthException(e);
    } else if (e is DCCServerReportsIssuesException) {
      errorType = UserErrorType.DCC_BACKEND_HAD_SERVER_ERROR;
    } else if (e is OTPInvalidException) {
      errorType = e.userErrorType;
    }
    return UserError(
      message: e.toString(),
      errorType: errorType,
    );
  }
}
