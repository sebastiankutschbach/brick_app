class Color {
  final int id;
  final String name;
  final String rgb;
  final bool isTransparent;

  Color.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        rgb = json['rgb'],
        isTransparent = json['is_trans'] == 'true';
}
