import 'dart:async';

import 'package:http/http.dart' as http;

class WebRequestHelper {
  static Future<http.Response> makePostRequest(String url, String body) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    return response;
  }
}
