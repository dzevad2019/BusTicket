import 'package:bus_ticket_mobile/models/city.dart';

class BusStop {
  int id;
  String name;
  int? cityId;
  City? city;

  BusStop({
    required this.id,
    required this.name,
    this.cityId,
    this.city,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['id'],
      name: json['name'],
      cityId: json['cityId'],
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cityId': cityId
    };
  }
}
