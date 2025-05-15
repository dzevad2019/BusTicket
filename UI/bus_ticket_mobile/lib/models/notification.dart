class NotificationData {
  final int id;
  int? busLineId;
  String? busLineName;
  DateTime? departureDateTime;
  final String message;

  NotificationData({
    required this.id,
    this.busLineId,
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
        message: json['message'],
        busLineName: json['busLineName'],
        departureDateTime: DateTime.parse(json['departureDateTime']),
      );
}