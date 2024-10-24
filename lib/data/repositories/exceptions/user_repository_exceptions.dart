import 'package:dcc/models/user_error_type.dart';

class DCCServerReportsIssuesException implements Exception {

}

abstract class OTPInvalidException implements Exception {
  UserErrorType get userErrorType;
}

class OTPIncorrectException extends OTPInvalidException {
  final userErrorType = UserErrorType.DCC_BACKEND_OTP_TOKEN_WAS_WRONG;
}

class OTPAlreadyUsedException extends OTPInvalidException {
  final userErrorType = UserErrorType.DCC_BACKEND_OTP_TOKEN_ALREADY_USED;
}

class OTPExpiredException extends OTPInvalidException {
  final userErrorType = UserErrorType.DCC_BACKEND_OTP_TOKEN_EXPIRED;
}

class OTPRejectedForUnknownReason extends OTPInvalidException {
  final userErrorType = UserErrorType.DCC_BACKEND_OTP_TOKEN_REJECTED_FOR_UNKNOWN_REASON;
}
