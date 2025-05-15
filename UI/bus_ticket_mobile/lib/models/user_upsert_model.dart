class UserUpsertModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime? birthDate;
  final String? profilePhoto;
  final String address;
  final String? newPassword;
  final String? oldPassword;
  final int gender;
  final bool enableNotificationEmail;

  UserUpsertModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.birthDate,
    this.profilePhoto,
    required this.address,
    this.newPassword,
    this.oldPassword,
    required this.enableNotificationEmail,
  });

  factory UserUpsertModel.fromJson(Map<String, dynamic> json) {
    return UserUpsertModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      profilePhoto: json['profilePhoto'],
      address: json['address'],
      newPassword: json['newPassword'],
      gender: json['gender'],
      enableNotificationEmail: json['enableNotificationEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate?.toIso8601String(),
      'profilePhoto': profilePhoto,
      'address': address,
      'email': email,
      'newPassword': newPassword,
      'oldPassword': oldPassword,
      'gender': gender,
      'enableNotificationEmail': enableNotificationEmail,
    };
  }
}
