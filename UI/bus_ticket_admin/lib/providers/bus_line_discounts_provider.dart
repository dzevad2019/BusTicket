import 'package:bus_ticket_admin/models/bus_line_discount.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class BusLineDiscountsProvider extends BaseProvider<BusLineDiscount> {
  BusLineDiscountsProvider() : super('BusLineDiscounts');

  @override
  BusLineDiscount fromJson(data) {
    return BusLineDiscount.fromJson(data);
  }
}
