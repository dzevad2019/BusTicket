import 'package:bus_ticket_admin/models/notification.dart';
import 'package:bus_ticket_admin/providers/base_provider.dart';

class NotificationsProvider extends BaseProvider<NotificationData> {
  NotificationsProvider() : super('Notifications');

  @override
  NotificationData fromJson(data) {
    return NotificationData.fromJson(data);
  }
}
