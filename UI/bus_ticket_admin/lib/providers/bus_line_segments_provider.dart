import 'package:bus_ticket_admin/models/bus_line_segment.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class BusLineSegmentsProvider extends BaseProvider<BusLineSegment> {
  BusLineSegmentsProvider() : super('BusLineSegment');

  @override
  BusLineSegment fromJson(data) {
    return BusLineSegment.fromJson(data);
  }
}
