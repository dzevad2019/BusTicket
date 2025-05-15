class ListItem {
  late int id;
  late String label;

  ListItem({required this.id, required this.label});

  ListItem.fromJson(Map<String, dynamic> json) {
    id = json['key'];
    label = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = id;
    data['value'] = label;
    return data;
  }
}