class Country {
  late int id;
  late String name;
  late String abrv;
  late bool isActive;

  Country({required this.id, required this.name});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    abrv=json['abrv'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['abrv'] = abrv;
    data['isActive'] = isActive;
    return data;
  }
}