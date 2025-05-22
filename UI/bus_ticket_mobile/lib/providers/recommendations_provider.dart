import 'dart:convert';
import 'package:bus_ticket_mobile/models/recommendation.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:http/http.dart' as http;

class RecommendationsProvider extends BaseProvider<Recommendation> {

  RecommendationsProvider() : super('Recommendations');

  Future<List<Recommendation>> getRecommendations(int userId, {int top = 3}) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseProvider.apiUrl}/api/Recommendations/$userId?top=$top'),
        headers: Authorization.createHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Recommendation.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}