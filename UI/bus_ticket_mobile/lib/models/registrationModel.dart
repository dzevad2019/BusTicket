import 'package:intl/intl.dart';

class RegistrationModel {
  late int id;
  late int cityId;
  late String firstName;
  late String lastName;
  late String createdAt;
  late String phoneNumber;
  late int gender;
  late String email;
  late DateTime birthDate;
  late String address;
  RegistrationModel();

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    // birthDate =
    //     DateFormat('dd.MM.yyyy').format(DateTime.parse(json['birthDate']));
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate.toIso8601String(),
      'address': address,
      'cityId': cityId,
      'isClient': true,
    };
  }

}
