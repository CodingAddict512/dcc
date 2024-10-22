import 'dart:convert';

class OTPCodeParser {

  bool isValid = false;
  String email;
  String otp;
  String verifyUrl;
  String error;
  Exception parseError;

  bool parse(String qrCode) {
    Codec<String, String> base64Converter = utf8.fuse(base64);
    isValid = false;
    try {
      final jsonString = base64Converter.decode(qrCode);
      final jsonMap = jsonDecode(jsonString);

      if (!(jsonMap is Map)) {
        error = "Wrong type (decoded message should be a Map)";
        return false;
      }

      email = jsonMap['email'];
      otp = jsonMap['oneTimePassword'];
      verifyUrl = jsonMap['verifyURL'];

      if (email == null) {
        error = "email is missing";
        return false;
      }
      if (otp == null) {
        error = "otp is missing";
        return false;
      }
      if (verifyUrl == null) {
        error = "verifyUrl is missing";
        return false;
      }
    } catch (e) {
      parseError = e;
      return false;
    }

    isValid = true;
    return isValid;
  }

}
