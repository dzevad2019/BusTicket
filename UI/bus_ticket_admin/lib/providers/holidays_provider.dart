import 'package:bus_ticket_admin/models/holiday.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class HolidaysProvider extends BaseProvider<Holiday> {
  HolidaysProvider() : super('Holidays');

  @override
  Holiday fromJson(data) {
    return Holiday.fromJson(data);
  }
}
