class UserTicket {
  int? id;
  String firstName;
  String lastName;
  String userName;

  UserTicket({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
  });

  factory UserTicket.fromJson(Map<String, dynamic> json) {
    return UserTicket(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
    };
  }
}
