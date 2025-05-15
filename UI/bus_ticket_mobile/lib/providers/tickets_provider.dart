import 'dart:convert';
import 'package:bus_ticket_mobile/models/apiResponse.dart';
import 'package:bus_ticket_mobile/models/ticket.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:bus_ticket_mobile/utils/authorization.dart';


class TicketsProvider extends BaseProvider<Ticket> {
  TicketsProvider() : super('Tickets');

  @override
  Ticket fromJson(data) {
    return Ticket.fromJson(data);
  }

  Future<ApiResponse<Ticket>> getMyTickets(Map<String, String>? params) async {
    print(params);
    var uri = Uri.parse('${BaseProvider.apiUrl}/$endpoint/GetUserTickets');
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Ticket> items = data['items'].map<Ticket>((d) => fromJson(d)).toList();
      int totalCount = data['totalCount'];
      return ApiResponse<Ticket>(items: items, totalCount: totalCount);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
