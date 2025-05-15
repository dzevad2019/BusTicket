class UserRoleModel {
  int id;
  int userId;
  int roleId;

  UserRoleModel({
    required this.id,
    required this.userId,
    required this.roleId,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'],
      userId: json['userId'],
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'roleId': roleId,
    };
  }
}
