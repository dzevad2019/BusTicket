class ListItemPackage {
  late int id;
  late String label;

  ListItemPackage({required this.id, required this.label});

  ListItemPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }
}