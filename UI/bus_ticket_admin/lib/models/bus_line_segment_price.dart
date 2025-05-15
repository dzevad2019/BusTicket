import 'bus_line_segment.dart';

class BusLineSegmentPrice {
  int id;

  int busLineSegmentFromId;
  BusLineSegment? busLineSegmentFrom;
  int busLineSegmentToId;
  BusLineSegment? busLineSegmentTo;
  double? oneWayTicketPrice;
  double? returnTicketPrice;

  bool? newSegmentNewPrice = false;

  BusLineSegmentPrice({
    required this.id,
    required this.busLineSegmentFromId,
    this.busLineSegmentFrom,
    required this.busLineSegmentToId,
    this.busLineSegmentTo,
    this.oneWayTicketPrice,
    this.returnTicketPrice,
    this.newSegmentNewPrice,
  });

  factory BusLineSegmentPrice.fromJson(Map<String, dynamic> json) {
    return BusLineSegmentPrice(
      id: json['id'],
      busLineSegmentFromId: json['busLineSegmentFromId'],
      busLineSegmentFrom: json['busLineSegmentFrom'] != null
          ? BusLineSegment.fromJson(json['busLineSegmentFrom'])
          : null,
      busLineSegmentToId: json['busLineSegmentToId'],
      busLineSegmentTo: json['busLineSegmentTo'] != null
          ? BusLineSegment.fromJson(json['busLineSegmentTo'])
          : null,
      oneWayTicketPrice: (json['oneWayTicketPrice'] as num).toDouble(),
      returnTicketPrice: (json['returnTicketPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busLineSegmentFromId': busLineSegmentFromId,
      //'busLineSegmentFrom': busLineSegmentFrom?.toJson(),
      'busLineSegmentToId': busLineSegmentToId,
      //'busLineSegmentTo': busLineSegmentTo?.toJson(),
      'oneWayTicketPrice': oneWayTicketPrice,
      'returnTicketPrice': returnTicketPrice,
    };
  }
}
