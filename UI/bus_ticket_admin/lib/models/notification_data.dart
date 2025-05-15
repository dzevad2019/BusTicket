class NotificationData {
  final int lineId;
  final DateTime departureDate;
  final String message;

  NotificationData({
    required this.lineId,
    required this.departureDate,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    'lineId': lineId,
    'departureDate': departureDate.toIso8601String(),
    'message': message,
  };
}

class SentNotification {
  final int id;
  final String message;
  final DateTime sentDate;
  final String lineName;
  final DateTime departureDate;

  SentNotification({
    required this.id,
    required this.message,
    required this.sentDate,
    required this.lineName,
    required this.departureDate,
  });

  factory SentNotification.fromJson(Map<String, dynamic> json) =>
      SentNotification(
        id: json['id'],
        message: json['message'],
        sentDate: DateTime.parse(json['sentDate']),
        lineName: json['lineName'],
        departureDate: DateTime.parse(json['departureDate']),
      );
}