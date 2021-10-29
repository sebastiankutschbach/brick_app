import 'package:brick_app/model/set_or_moc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brick_set.g.dart';

@JsonSerializable()
class BrickSet extends SetOrMoc {
  @override
  @JsonKey(name: 'set_num')
  final String setNum;
  @override
  final String name;
  @override
  final int year;
  @override
  @JsonKey(name: 'theme_id')
  final int themeId;
  @override
  @JsonKey(name: 'num_parts')
  final int numParts;
  @override
  @JsonKey(name: 'set_img_url')
  final String imgUrl;
  @override
  @JsonKey(name: 'set_url')
  final String url;
  @JsonKey(name: 'last_modified_dt')
  final DateTime lastModified;

  BrickSet(this.setNum, this.name, this.year, this.themeId, this.numParts,
      this.imgUrl, this.url, this.lastModified);

  factory BrickSet.fromJson(Map<String, dynamic> json) =>
      _$BrickSetFromJson(json);

  Map<String, dynamic> toJson() => _$BrickSetToJson(this);
}
