import 'package:bus_ticket_admin/models/bus_line_vehicle.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class BusLineVehiclesProvider extends BaseProvider<BusLineVehicle> {
  BusLineVehiclesProvider() : super('BusLineVehicles');

  @override
  BusLineVehicle fromJson(data) {
    return BusLineVehicle.fromJson(data);
  }
}
