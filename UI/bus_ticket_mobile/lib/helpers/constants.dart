import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants{
  static String apiUrl = String.fromEnvironment('API_URL', defaultValue: dotenv.env['API_URL']!);
  static String appTitle = 'Exyutv';
}


