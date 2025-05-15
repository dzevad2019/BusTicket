import 'package:bus_ticket_mobile/models/country.dart';

class City {
  late int id;
  late String name;
  late String abrv;
  late int countryId;
  late Country? country;
  late bool favorite;
  late int totalRecordsCount;

  City({required this.id, required this.name, required this.abrv, required this.favorite});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abrv=json['abrv'];
    countryId=json['countryId'];
    favorite = json['favorite'];

    if (json['country'] != null) {
      country = Country.fromJson(json['country']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['abrv'] = abrv;
    data['countryId'] = countryId;
    data['favorite'] = favorite;
    return data;
  }
}