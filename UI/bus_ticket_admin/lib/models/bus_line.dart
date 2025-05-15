import 'package:bus_ticket_admin/enums/enums.dart';

import 'bus_line_segment.dart';
import 'bus_line_discount.dart';
import 'bus_line_vehicle.dart';

class BusLine {
  int id;

  String name;
  //String? departureTime = "00:00";
  //String? arrivalTime = "00:00";
  bool active;

  List<BusLineSegment> segments;
  List<BusLineDiscount> discounts;
  List<BusLineVehicle> vehicles;

  int operatingDays;

  BusLine({
    required this.id,
    required this.name,
    //this.departureTime,
    //this.arrivalTime,
    required this.active,
    required this.segments,
    required this.discounts,
    required this.vehicles,
    this.operatingDays = 64
  });

  factory BusLine.fromJson(Map<String, dynamic> json) {
    return BusLine(
      id: json['id'],
      name: json['name'] ?? '',
      //departureTime: json['departureTime'] ?? '',
      //arrivalTime: json['arrivalTime'] ?? '',
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
      operatingDays: json['operatingDays'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      //'departureTime': departureTime,
      //'arrivalTime': arrivalTime,
      'active': active,
      'segments': segments.map((e) => e.toJson()).toList(),
      'discounts': discounts.map((e) => e.toJson()).toList(),
      'vehicles': vehicles.map((e) => e.toJson()).toList(),
      'operatingDays': operatingDays,
    };
  }
}
