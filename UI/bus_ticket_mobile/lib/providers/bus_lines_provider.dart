import 'dart:convert';
import 'package:bus_ticket_mobile/models/bus_line.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:http/http.dart' as http;

class BusLinesProvider extends BaseProvider<BusLine> {
  BusLinesProvider() : super('BusLines');

  Future<List<BusLine>> getAvailableLines(
      int busStopFromId,
      int busStopToId,
      DateTime dateFrom,
      DateTime? dateTo
      ) async {
    var uri = Uri.parse('${BaseProvider.apiUrl}/$endpoint/available-lines');

    var params = {
      "busStopFromId": busStopFromId.toString(),
      "busStopToId": busStopToId.toString(),
      "dateFrom": dateFrom.toIso8601String(),
    };

    if (dateTo != null){
      params["dateTo"] = dateTo.toIso8601String();
    }


    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data.map((d) => fromJson(d)).cast<BusLine>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  BusLine fromJson(data) {
    return BusLine.fromJson(data);
  }
}
