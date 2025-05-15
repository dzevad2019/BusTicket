import 'dart:convert';

class AuthRequest {
  String username;
  String password;

  AuthRequest(this.username, this.password);

  AuthRequest.register(this.username, this.password);

  @override
  Map<String, dynamic> toJson() {
    return {"userName": username, "password": password};
  }

  static String loginToJson(AuthRequest login) {
    final jsonData = login.toJson();
    return json.encode(jsonData);
  }
}
