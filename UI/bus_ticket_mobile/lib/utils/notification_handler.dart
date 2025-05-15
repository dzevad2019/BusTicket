import 'dart:convert';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationHandler(this._notificationsPlugin);

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (granted == false) {
      print("Notifikacije nisu dozvoljene od strane korisnika.");
    }
  }


  Future<void> showNotification(List<dynamic> messageList) async {
    if (messageList.isEmpty) return;

    final message = messageList[0] as Map<String, dynamic>;

    final String body = message['message'] ?? 'Nova notifikacija';
    final String? lineName = message['Name'];
    final String? time = message['time'];

    final String notificationBody = lineName != null && time != null
        ? 'Linija $lineName • $time\n$body'
        : body;

    final BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
      notificationBody,
      htmlFormatBigText: true,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'bus_notifications',
      'Bus Notifications',
      channelDescription: 'Notifications about bus schedule changes',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyle,
      color: const Color(0xFF2196F3),
      autoCancel: true,
      timeoutAfter: 86400000,
      showWhen: true,
    );

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Obaveštenje o liniji',
      message['message'] ?? 'Nova notifikacija',
      platformChannelSpecifics,
      payload: jsonEncode(message),
    );
  }
}