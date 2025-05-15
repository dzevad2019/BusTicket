import 'dart:convert';
import 'dart:io';
import '../helpers/constants.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'package:http/http.dart' as http;
import '../utils/authorization.dart';

class LoginProvider {
  static AuthResponse? authResponse = null;

  static Future<bool> login(AuthRequest authRequest) async {
    var uri = Uri.parse('${Constants.apiUrl}/api/Access/SignIn');
    Map<String, String> headers = Authorization.createHeaders();
    var jsonRequest = jsonEncode(authRequest);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      authResponse = AuthResponse.fromJson(data);
      print(authResponse!.isClient);

      //if(authResponse != null && !authResponse!.isClient!)
      //  {
      //    return false;
      //  }
      Authorization.token = authResponse!.token;
      Authorization.id = authResponse!.userId;

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

  static void setResponseFalse() {
    authResponse!.result = false;
  }
}
