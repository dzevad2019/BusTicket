import 'dart:convert';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/apiResponse.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  String endpoint;
  static String apiUrl = "";

  BaseProvider(this.endpoint){
    apiUrl = String.fromEnvironment('API_URL', defaultValue: dotenv.env['API_URL']!);
  }

  Future<List<T>> get(Map<String, String>? params) async {
    var uri = Uri.parse('$apiUrl/$endpoint');

    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data.map((d) => fromJson(d)).cast<T>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ApiResponse<T>> getForPagination(Map<String, String>? params) async {
    print(params);
    var uri = Uri.parse('$apiUrl/$endpoint/GetPaged');
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<T> items = data['items'].map<T>((d) => fromJson(d)).toList();
      int totalCount = data['totalCount'];
      return ApiResponse<T>(items: items, totalCount: totalCount);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<T> getById(int id, Map<String, String>? params) async {
    var uri = Uri.parse('$apiUrl/$endpoint/$id');

    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/$endpoint');
    Map<String, String> headers = Authorization.createHeaders();
    var jsonRequest = jsonEncode(resource);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
     return true;
    } else {
      return false;
    }
  }

  Future<bool> insertFormData(Map<String, dynamic> formData) async {
    final Uri uri = Uri.parse('$apiUrl/$endpoint');

    try {
      var request = await http.MultipartRequest(
          'POST',
          uri);

      request.headers.addAll(Authorization.createHeaders(formData:true));

      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (formData.containsKey('file')) {
        request.files.add(formData['file']);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Uspješan odgovor: ${await response.stream.bytesToString()}');
        return true;
      } else {
        print('Neuspješan odgovor: ${response.statusCode}');
        return false;
      }
    } catch (error, stackTrace) {
      print('Greška prilikom slanja zahtjeva: $error');
      return false;
    }
  }

  Future<bool> update([dynamic request]) async {
    var url = "$apiUrl/$endpoint";
    var uri = Uri.parse(url);

    Map<String, String> headers = Authorization.createHeaders();
    var response = await http.put(uri, headers: headers, body: jsonEncode(request));

    if (isValidResponseCode(response)) {
     return true;
    } else {
      return false;
    }
  }

  Future<bool> updateFormData(Map<String, dynamic> formData) async {
    final Uri uri = Uri.parse('$apiUrl/$endpoint');

    try {
      var request = await http.MultipartRequest(
          'PUT',
          uri);
      request.headers.addAll(Authorization.createHeaders(formData:true));

      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (formData.containsKey('file')) {
        request.files.add(formData['file']);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Uspješan odgovor: ${await response.stream.bytesToString()}');
        return true;
      } else {
        print('Neuspješan odgovor: ${await response.stream.bytesToString()}');
        print(response.request);
        return false;
      }
    } catch (error, stackTrace) {
      print('Greška prilikom slanja zahtjeva: $error');
      return false;
    }
  }

  Future<void> deleteById(dynamic id) async {
    var uri = Uri.parse('$apiUrl/$endpoint/$id');
    var headers = Authorization.createHeaders();
    await http.delete(uri, headers: headers);

  }

  bool isValidResponseCode(Response response) {
    if (response.statusCode == 200) {
      if (response.body != "") {
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Bad request");
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 403) {
      throw Exception("Forbidden");
    } else if (response.statusCode == 404) {
      throw Exception("Not found");
    } else if (response.statusCode == 500) {
      throw Exception("Internal server error");
    } else {
      throw Exception("Exception... handle this gracefully");
    }
  }

  T fromJson(data) {
    throw Exception("Override method");
  }

  String getQueryString(Map params, {String prefix='&', bool inRecursion= false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
