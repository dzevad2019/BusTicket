import 'package:bus_ticket_admin/models/company.dart';

class Vehicle {
  int id;
  String name;
  String registration;
  int capacity;
  VehicleType type;
  int? companyId;
  Company? company;

  Vehicle({
    required this.id,
    required this.name,
    required this.registration,
    required this.capacity,
    required this.type,
    required this.companyId,
    required this.company,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      name: json['name'],
      registration: json['registration'],
      capacity: json['capacity'],
      type: VehicleType.values.firstWhere(
            (e) => e.index == json['type'],
        orElse: () => VehicleType.bus, // default if not found
      ),
      companyId: json['companyId'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'registration': registration,
      'capacity': capacity,
      'type': type.index,
      'companyId': companyId
    };
  }
}

enum VehicleType {
  bus,
  minibus
}

