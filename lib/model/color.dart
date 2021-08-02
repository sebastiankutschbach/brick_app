import 'package:json_annotation/json_annotation.dart';

part 'color.g.dart';

@JsonSerializable()
class Color {
  final int id;
  final String name;
  final String rgb;
  @JsonKey(name: 'is_trans')
  final bool isTransparent;

  Color(this.id, this.name, this.rgb, this.isTransparent);

  factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);

  Map<String, dynamic> toJson() => _$ColorToJson(this);
}
