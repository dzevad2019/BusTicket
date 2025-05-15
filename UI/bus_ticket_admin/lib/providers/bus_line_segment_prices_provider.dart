import 'package:bus_ticket_admin/models/bus_line_segment_price.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class BusLineSegmentPricesProvider extends BaseProvider<BusLineSegmentPrice> {
  BusLineSegmentPricesProvider() : super('BusLineSegmentPrices');

  @override
  BusLineSegmentPrice fromJson(data) {
    return BusLineSegmentPrice.fromJson(data);
  }
}
