import 'package:bus_ticket_admin/models/apiResponse.dart';
import 'package:bus_ticket_admin/models/city.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super('Cities');

  List<City> cities = <City>[];

  @override
  Future<List<City>> get(Map<String, String>? params) async {
    cities = await super.get(params);
    return cities;
  }

  @override
  Future<ApiResponse<City>> getForPagination(Map<String, String>? params) async {
    return await super.getForPagination(params);
  }

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}