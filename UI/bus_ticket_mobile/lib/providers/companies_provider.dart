import 'dart:convert';
import 'package:bus_ticket_mobile/models/apiResponse.dart';
import 'package:bus_ticket_mobile/models/company.dart';
import 'package:bus_ticket_mobile/models/ticket.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:bus_ticket_mobile/screens/company/companies_list.dart';
import 'package:http/http.dart' as http;
import 'package:bus_ticket_mobile/utils/authorization.dart';


class CompaniesProvider extends BaseProvider<Company> {
  CompaniesProvider() : super('Companies');

  @override
  Company fromJson(data) {
    print(data);
    return Company.fromJson(data);
  }
}
