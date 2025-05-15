import 'dart:convert';

import 'package:bus_ticket_admin/models/ticket.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';
import 'package:bus_ticket_admin/utils/authorization.dart';
import 'package:http/http.dart' as http;

class TicketsProvider extends BaseProvider<Ticket> {
  TicketsProvider() : super('Tickets');

  @override
  Ticket fromJson(data) {
    return Ticket.fromJson(data);
  }
  
  Future<bool> changeStatus(int ticketId, int newStatus) async {
    var uri = Uri.parse('${BaseProvider.apiUrl}/$endpoint/$ticketId/$newStatus');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to change status');
    }
  }
}
