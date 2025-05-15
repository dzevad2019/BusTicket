import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseModel {
  late int id;
  late String createdAt;
  late String apiUrl;

  BaseModel(){
    apiUrl = dotenv.env['API_URL']!;
  }
}