class Authorization {
  static String? token;
  static int id = 0;

  static Map<String, String> createHeaders({bool formData = false}) {
    String token = Authorization.token ?? '';

    var headers=null;
    if (formData) {
      headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": 'Bearer $token'
      };
    } else {
      headers = {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token'
      };
    }
    return headers;
  }
}
