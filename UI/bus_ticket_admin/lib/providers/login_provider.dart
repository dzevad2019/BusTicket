import 'dart:convert';
import 'dart:io';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'package:http/http.dart' as http;
import '../utils/authorization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginProvider {
  static AuthResponse? authResponse = null;
  static late String apiUrl = "";

  static Future<bool> login(AuthRequest authRequest) async {
    apiUrl = dotenv.env['API_URL']!;
    var uri = Uri.parse('$apiUrl/api/Access/SignIn');
    Map<String, String> headers = Authorization.createHeaders();
    var jsonRequest = jsonEncode(authRequest);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      authResponse = AuthResponse.fromJson(data);
      Authorization.token = authResponse!.token;
      Authorization.firstName = authResponse!.firstName;
      Authorization.lastName = authResponse!.lastName;
      Authorization.email = authResponse!.email;
      return true;
    }
    if (response.statusCode == 400) {
      return false;
    } else {
      var data = json.decode(response.body);
      throw HttpException(
          "Request failed. Status code: ${response.statusCode} ${data}");
    }
  }

  // bool isLoggedIn() {
  //   return _authResponse!.result;
  // }
  //
  // // void verifySession() {
  // //   if (isExpiredToken()) {
  // //     login(AuthRequest(_username, _password));
  // //   }
  // // }
  //
  // bool isExpiredToken() {
  //   return JwtDecoder.isExpired(_authResponse!.token);
  // }
  //
  // String getToken() {
  //   return _authResponse!.token;
  // }
  //
  // String getUserName() {
  //   return _authResponse!.username;
  // }
  //
  // AuthResponse getAuthResponse() {
  //   return _authResponse!;
  // }
  //
  static void setResponseFalse() {
    authResponse!.result = false;
  }
}
