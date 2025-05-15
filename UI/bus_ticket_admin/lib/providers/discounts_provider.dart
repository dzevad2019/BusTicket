import 'package:bus_ticket_admin/models/discount.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class DiscountsProvider extends BaseProvider<Discount> {
  DiscountsProvider() : super('Discounts');

  @override
  Discount fromJson(data) {
    return Discount.fromJson(data);
  }
}