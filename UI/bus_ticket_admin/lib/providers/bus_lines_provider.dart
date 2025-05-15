import 'package:bus_ticket_admin/models/bus_line.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class BusLinesProvider extends BaseProvider<BusLine> {
  BusLinesProvider() : super('BusLines');

  @override
  BusLine fromJson(data) {
    return BusLine.fromJson(data);
  }
}
