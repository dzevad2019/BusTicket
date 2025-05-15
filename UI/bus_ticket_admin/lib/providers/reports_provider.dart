import 'dart:io';
import 'package:bus_ticket_admin/models/notification.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bus_ticket_admin/utils/authorization.dart';

class ReportsProvider extends BaseProvider<NotificationData> {
  ReportsProvider() : super('Reports');

  final Dio _dio = Dio();

  Future<String> ticketSales(int? selectedCompany, DateTime fromDate, DateTime toDate) async {
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/reports/ticket-sales')
        .replace(queryParameters: {
        if (selectedCompany != null) 'companyId': selectedCompany.toString(),
        'fromDate':   fromDate.toIso8601String(),
        'toDate':     toDate.toIso8601String(),
      });

    final response = await _dio.getUri<List<int>>(
      uri,
      options: Options(
        responseType: ResponseType.bytes,
        headers: Authorization.createHeaders(),
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/izvjestaj_prodaja_karata_'
        '${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File(filePath);
    await file.writeAsBytes(response.data!, flush: true);

    return filePath;
  }

  Future<String> busOccupancy(int? selectedCompany, DateTime fromDate, DateTime toDate) async {
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/reports/bus-occupancy')
        .replace(queryParameters: {
      if (selectedCompany != null) 'companyId': selectedCompany.toString(),
      'fromDate':   fromDate.toIso8601String(),
      'toDate':     toDate.toIso8601String(),
    });

    final response = await _dio.getUri<List<int>>(
      uri,
      options: Options(
        responseType: ResponseType.bytes,
        headers: Authorization.createHeaders(),
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/izvjestaj_popunjenost_autobusa_'
        '${DateTime.now().millisecondsSinceEpoch}.pdf';

    final file = File(filePath);
    await file.writeAsBytes(response.data!, flush: true);

    return filePath;
  }
}
