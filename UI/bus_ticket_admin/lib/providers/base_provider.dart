import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bus_ticket_admin/utils/authorization.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/apiResponse.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  String endpoint;
  static String apiUrl = "";

  BaseProvider(this.endpoint) {
    apiUrl = dotenv.env['API_URL']!;
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
    http.MultipartRequest('POST', uri);

    if (isValidResponseCode(response)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> update(int id, [dynamic request]) async {
    var url = "$apiUrl/$endpoint";
    var uri = Uri.parse(url);

    //print(jsonEncode(request));
    Map<String, String> headers = Authorization.createHeaders();
    var response =
        await http.put(uri, headers: headers, body: jsonEncode(request));

    if (isValidResponseCode(response)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteById(dynamic id) async {
    var uri = Uri.parse('$apiUrl/$endpoint/$id');
    var headers = Authorization.createHeaders();

    final response = await http.delete(uri, headers: headers);
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
}
