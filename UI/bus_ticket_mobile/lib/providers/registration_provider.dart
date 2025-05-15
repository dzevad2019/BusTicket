import 'dart:convert';
import '../helpers/constants.dart';
import 'package:http/http.dart' as http;
import '../models/registrationModel.dart';
import '../utils/authorization.dart';
import 'package:flutter/material.dart';

class RegistrationProvider with ChangeNotifier {
  RegistrationProvider();

  Future<bool> registration(RegistrationModel resource) async {
    var uri = Uri.parse('${Constants.apiUrl}/api/Access/Registration');
    Map<String, String> headers = Authorization.createHeaders();
    try {
      print(resource);
      var jsonRequest = jsonEncode(resource);
      print(jsonRequest);

      var response = await http.post(uri, headers: headers, body: jsonRequest);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return true;
      } else {
        print('Neuspješan odgovor: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Greška prilikom slanja zahtjeva: $error');
      return false;
    }
  }
}
