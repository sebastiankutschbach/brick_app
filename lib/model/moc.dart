import 'package:brick_app/model/set_or_moc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moc.g.dart';

@JsonSerializable()
class Moc extends SetOrMoc {
  @JsonKey(name: 'set_num')
  final String setNum;
  final String name;
  final int year;
  @JsonKey(name: 'theme_id')
  final int themeId;
  @JsonKey(name: 'num_parts')
  final int numParts;
  @JsonKey(name: 'moc_img_url')
  final String imgUrl;
  @JsonKey(name: 'moc_url')
  final String url;
  @JsonKey(name: 'designer_name')
  final String designerName;
  @JsonKey(name: 'designer_url')
  final String designerUrl;

  Moc(this.setNum, this.name, this.year, this.themeId, this.numParts,
      this.imgUrl, this.url, this.designerName, this.designerUrl);

  factory Moc.fromJson(Map<String, dynamic> json) => _$MocFromJson(json);

  Map<String, dynamic> toJson() => _$MocToJson(this);
}
