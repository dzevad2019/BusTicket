import 'package:bus_ticket_mobile/models/bus_stop.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';


class BusStopsProvider extends BaseProvider<BusStop> {
  BusStopsProvider() : super('BusStops');

  @override
  BusStop fromJson(data) {
    return BusStop.fromJson(data);
  }
}
