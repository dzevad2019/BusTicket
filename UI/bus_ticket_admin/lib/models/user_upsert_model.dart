// user_profile.dart
import 'package:bus_ticket_admin/models/user_role.dart';

class UserUpsertModel {
  int? id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  DateTime? birthDate;
  int? gender;
  String? profilePhoto;
  String address;
  List<UserRoleModel>? userRoles;

  UserUpsertModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    this.birthDate,
    this.gender,
    this.profilePhoto,
    required this.address,
    this.userRoles,
  });

  factory UserUpsertModel.fromJson(Map<String, dynamic> json) {
    return UserUpsertModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'],
      profilePhoto: json['profilePhoto'],
      address: json['address'],
      userRoles: json['userRoles'] != null ? (json['userRoles'] as List).map((e) => UserRoleModel.fromJson(e)).toList() : null,
      //role: RoleLevel.values.elementAt(json['gender']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'profilePhoto': profilePhoto,
      'address': address,
      'userRoles': userRoles
    };
  }
}