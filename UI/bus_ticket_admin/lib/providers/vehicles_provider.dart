import 'package:bus_ticket_admin/models/apiResponse.dart';
import 'package:bus_ticket_admin/models/vehicle.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class VehiclesProvider extends BaseProvider<Vehicle> {
  VehiclesProvider() : super('Vehicles');

  List<Vehicle> vehicles = <Vehicle>[];

  @override
  Future<List<Vehicle>> get(Map<String, String>? params) async {
    vehicles = await super.get(params);
    return vehicles;
  }

  @override
  Future<ApiResponse<Vehicle>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  @override
  Vehicle fromJson(data) {
    return Vehicle.fromJson(data);
  }
}