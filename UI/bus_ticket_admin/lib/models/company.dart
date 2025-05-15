import 'package:bus_ticket_admin/models/city.dart';

class Company{
  int id;
  String name;
  String phoneNumber;
  String email;
  String webPage;
  String taxNumber;
  String identificationNumber;
  bool active;
  String logoUrl;
  int cityId;
  City? city;

  Company({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.webPage,
    required this.taxNumber,
    required this.identificationNumber,
    required this.active,
    required this.logoUrl,
    required this.cityId,
    required this.city,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      webPage: json['webPage'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      identificationNumber: json['identificationNumber'] ?? '',
      active: json['active'] ?? false,
      logoUrl: json['logoUrl'] ?? '',
      cityId: json['cityId'] ?? 0,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'webPage': webPage,
      'taxNumber': taxNumber,
      'identificationNumber': identificationNumber,
      'active': active,
      'logoUrl': logoUrl,
      'cityId': cityId,
      //'city': city,
    };
  }
}
