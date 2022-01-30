import 'package:brick_app/model/set_or_moc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moc.g.dart';

@JsonSerializable()
class Moc extends SetOrMoc {
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
  @JsonKey(name: 'moc_img_url')
  final String imgUrl;
  @override
  @JsonKey(name: 'moc_url')
  final String url;
  @JsonKey(name: 'designer_name')
  final String designerName;
  @JsonKey(name: 'designer_url')
  final String designerUrl;

  bool hasInstruction = false;

  Moc(this.setNum, this.name, this.year, this.themeId, this.numParts,
      this.imgUrl, this.url, this.designerName, this.designerUrl);

  factory Moc.fromJson(Map<String, dynamic> json) => _$MocFromJson(json);

  Map<String, dynamic> toJson() => _$MocToJson(this);
}
