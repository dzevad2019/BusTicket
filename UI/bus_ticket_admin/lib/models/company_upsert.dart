class CompanyUpsert{
  int id;
  String name;
  String phoneNumber;
  String email;
  String webPage;
  String taxNumber;
  String identificationNumber;
  bool active;
  int cityId;
  String image;

  CompanyUpsert({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.webPage,
    required this.taxNumber,
    required this.identificationNumber,
    required this.active,
    required this.cityId,
    required this.image
  });

  factory CompanyUpsert.fromJson(Map<String, dynamic> json) {
    return CompanyUpsert(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      webPage: json['webPage'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      identificationNumber: json['identificationNumber'] ?? '',
      active: json['active'] ?? false,
      cityId: json['cityId'] ?? 0,
      image: json['image'] ?? ''
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
      'cityId': cityId,
      'image': image,
    };
  }
}
