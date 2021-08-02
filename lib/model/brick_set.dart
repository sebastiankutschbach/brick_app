import 'package:brick_app/model/set_or_moc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brick_set.g.dart';

@JsonSerializable()
class BrickSet extends SetOrMoc {
  @JsonKey(name: 'set_num')
  final String setNum;
  final String name;
  final int year;
  @JsonKey(name: 'theme_id')
  final int themeId;
  @JsonKey(name: 'num_parts')
  final int numParts;
  @JsonKey(name: 'set_img_url')
  final String imgUrl;
  @JsonKey(name: 'set_url')
  final String url;
  @JsonKey(name: 'last_modified_dt')
  final DateTime lastModified;

  BrickSet(this.setNum, this.name, this.year, this.themeId, this.numParts,
      this.imgUrl, this.url, this.lastModified);

  factory BrickSet.fromJson(Map<String, dynamic> json) =>
      _$BrickSetFromJson(json);
}
