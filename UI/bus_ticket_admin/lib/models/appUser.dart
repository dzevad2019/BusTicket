import 'base.dart';

class AppUser extends BaseModel {
  late String userName;
  late String email;
  late String phoneNumber;

  AppUser();

  AppUser.fromJson(Map<String, dynamic> json) {
    //id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['id'] = id;
    data['userName'] = userName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
