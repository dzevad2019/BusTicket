import 'bus_line.dart';
import 'bus_stop.dart';
import 'bus_line_segment_price.dart';

class BusLineSegment {
  int id;

  int? busLineId;
  BusLine? busLine;
  int busStopId;
  BusStop? busStop;
  BusLineSegmentType? busLineSegmentType;
  int? stopOrder;
  String? departureTime = "00:00";
  List<BusLineSegmentPrice>? prices;

  BusLineSegment({
    required this.id,
    this.busLineId,
    this.busLine,
    required this.busStopId,
    this.busStop,
    this.busLineSegmentType,
    this.stopOrder,
    this.departureTime,
    this.prices,
  });

  factory BusLineSegment.fromJson(Map<String, dynamic> json) {
    return BusLineSegment(
      id: json['id'],
      busLineId: json['busLineId'],
      busLine: json['busLine'] != null ? BusLine.fromJson(json['busLine']) : null,
      busStopId: json['busStopId'],
      busStop: json['busStop'] != null ? BusStop.fromJson(json['busStop']) : null,
      busLineSegmentType: busLineSegmentTypeFromInt(json['busLineSegmentType']),
      stopOrder: json['stopOrder'],
      departureTime: json['departureTime'],
      prices: json['prices'] != null
          ? (json['prices'] as List)
          .map((e) => BusLineSegmentPrice.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busLineId': busLineId,
      'busLine': busLine?.toJson(),
      'busStopId': busStopId,
      'busStop': busStop?.toJson(),
      'busLineSegmentType': busLineSegmentType != null ? busLineSegmentTypeToString(busLineSegmentType!) : null,
      'stopOrder': stopOrder,
      'departureTime': departureTime,
      'prices': prices?.map((e) => e.toJson()).toList(),
    };
  }
}


enum BusLineSegmentType {
  departure,
  middle,
  arrival,
}

BusLineSegmentType busLineSegmentTypeFromInt(int value) {
  return BusLineSegmentType.values.firstWhere(
          (e) => e.index == value
  );
}

int busLineSegmentTypeToString(BusLineSegmentType type) {
  return type.index;
}