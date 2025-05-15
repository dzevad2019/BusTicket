class Holiday {
  int id;
  String name;
  DateTime date;

  Holiday({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
    };
  }
}
