import 'dart:convert';

class AuthResponse {
  bool result;
  int userId;
  String token;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? profilePhoto;
  final String? profilePhotoThumbnail;
  final bool? isClient;

  AuthResponse(
      {required this.result,
      required this.userId,
      required this.token,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
        required this.phoneNumber,
      required this.profilePhoto,
      required this.profilePhotoThumbnail,
      required this.isClient});

  factory AuthResponse.fromJson(Map<String, dynamic> data) {
    late String profilePhoto = data['profilePhoto'] ?? '';
    late String profilePhotoThumbnail = data['profilePhotoThumbnail'] ?? '';
    return AuthResponse(
        result: true,
        userId: data['userId'],
        token: data['token'],
        username: data['username'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        profilePhoto: profilePhoto,
        profilePhotoThumbnail: profilePhotoThumbnail,
        isClient: data['isClient']);
  }

  static AuthResponse authResultFromJson(String json) {
    final data = const JsonDecoder().convert(json);
    return AuthResponse.fromJson(data);
  }
}
