import 'dart:convert';
import 'package:bus_ticket_mobile/models/apiResponse.dart';
import 'package:bus_ticket_mobile/models/notification.dart';
import 'package:bus_ticket_mobile/models/ticket.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:bus_ticket_mobile/utils/authorization.dart';


class NotificationsProvider extends BaseProvider<NotificationData> {
  NotificationsProvider() : super('Notifications');

  @override
  NotificationData fromJson(data) {
    return NotificationData.fromJson(data);
  }
}
