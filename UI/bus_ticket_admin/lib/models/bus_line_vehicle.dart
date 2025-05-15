import 'bus_line.dart';
import 'vehicle.dart';

class BusLineVehicle {
  int id;

  int? busLineId;
  BusLine? busLine;
  int vehicleId;
  Vehicle? vehicle;

  BusLineVehicle({
    required this.id,
    required this.busLineId,
    this.busLine,
    required this.vehicleId,
    this.vehicle,
  });

  factory BusLineVehicle.fromJson(Map<String, dynamic> json) {
    return BusLineVehicle(
      id: json['id'],
      busLineId: json['busLineId'],
      busLine: json['busLine'] != null ? BusLine.fromJson(json['busLine']) : null,
      vehicleId: json['vehicleId'],
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busLineId': busLineId,
      'busLine': busLine?.toJson(),
      'vehicleId': vehicleId,
      'vehicle': vehicle?.toJson(),
    };
  }
}
