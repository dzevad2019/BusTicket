import 'package:bus_ticket_admin/models/bus_line.dart';

class NotificationData {
  final int id;
  int? busLineId;
  BusLine? busLine;
  String? busLineName;
  DateTime? departureDateTime;
  final String message;

  NotificationData({
    required this.id,
    this.busLineId,
    this.busLine,
    this.busLineName,
    this.departureDateTime,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    'busLineId': busLineId,
    'departureDateTime': departureDateTime?.toIso8601String(),
    'message': message,
  };

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json['id'],
        busLineId: json['busLineId'],
        busLine: json['busLine'] != null ? BusLine.fromJson(json['busLine']) : null,
        message: json['message'],
        busLineName: json['busLineName'],
        departureDateTime: DateTime.parse(json['departureDateTime']),
      );
}

class SentNotification {
  final int id;
  final String message;
  final DateTime sentDate;
  final String lineName;
  final DateTime departureDateTime;

  SentNotification({
    required this.id,
    required this.message,
    required this.sentDate,
    required this.lineName,
    required this.departureDateTime,
  });

  factory SentNotification.fromJson(Map<String, dynamic> json) =>
      SentNotification(
        id: json['id'],
        message: json['message'],
        sentDate: DateTime.parse(json['sentDate']),
        lineName: json['lineName'],
        departureDateTime: DateTime.parse(json['departureDateTime']),
      );
}