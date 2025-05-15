import 'package:bus_ticket_admin/models/apiResponse.dart';
import 'package:bus_ticket_admin/models/company.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class CompanyProvider extends BaseProvider<Company> {
  CompanyProvider() : super('Companies');

  List<Company> companies = <Company>[];

  @override
  Future<List<Company>> get(Map<String, String>? params) async {
    companies = await super.get(params);

    return companies;
  }

  @override
  Future<ApiResponse<Company>> getForPagination(Map<String, String>? params) async {
     return await super.getForPagination(params);
  }

  @override
  Company fromJson(data) {
    return Company.fromJson(data);
  }
}