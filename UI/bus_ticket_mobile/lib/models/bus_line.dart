import 'package:bus_ticket_mobile/enums/enums.dart';

import 'bus_line_segment.dart';
import 'bus_line_discount.dart';
import 'bus_line_vehicle.dart';

class BusLine {
  int id;

  String name;
  String? departureTime;
  String? arrivalTime;
  bool active;

  List<BusLineSegment> segments;
  List<BusLineDiscount> discounts;
  List<BusLineVehicle> vehicles;

  int operatingDays;

  int? numberOfSeats;
  List<int>? busySeats;

  List<BusLine> returnLines;

  BusLine({
    required this.id,
    required this.name,
    this.departureTime,
    this.arrivalTime,
    required this.active,
    required this.segments,
    required this.discounts,
    required this.vehicles,
    this.operatingDays = 64,
    this.numberOfSeats,
    this.busySeats,
    required this.returnLines
  });

  factory BusLine.fromJson(Map<String, dynamic> json) {
    return BusLine(
      id: json['id'],
      name: json['name'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      active: json['active'] ?? false,
      segments: json['segments'] != null
          ? (json['segments'] as List)
          .map((e) => BusLineSegment.fromJson(e))
          .toList()
          : [],
      discounts: json['discounts'] != null
          ? (json['discounts'] as List)
          .map((e) => BusLineDiscount.fromJson(e))
          .toList()
          : [],
      vehicles: json['vehicles'] != null
          ? (json['vehicles'] as List)
          .map((e) => BusLineVehicle.fromJson(e))
          .toList()
          : [],
      returnLines: json['returnLines'] != null
          ? (json['returnLines'] as List)
          .map((e) => BusLine.fromJson(e))
          .toList()
          : [],
      operatingDays: json['operatingDays'] ?? 0,
      numberOfSeats: json['numberOfSeats'],
      busySeats: json['busySeats'] != null
          ? (json['busySeats'] as List)
          .map((e) => int.parse(e.toString()))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'active': active,
      'segments': segments.map((e) => e.toJson()).toList(),
      'discounts': discounts.map((e) => e.toJson()).toList(),
      'vehicles': vehicles.map((e) => e.toJson()).toList(),
      'operatingDays': operatingDays,
    };
  }
}
