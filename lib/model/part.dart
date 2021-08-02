import 'package:json_annotation/json_annotation.dart';

part 'part.g.dart';

@JsonSerializable()
class Part {
  @JsonKey(name: 'part_num')
  final String partNum;
  final String name;
  @JsonKey(name: 'part_cat_id')
  final int partCatId;
  @JsonKey(name: 'part_url')
  final String partUrl;
  @JsonKey(name: 'part_img_url')
  final String? partImgUrl;
  @JsonKey(name: 'print_of')
  final String? printOf;

  Part(this.partNum, this.name, this.partCatId, this.partUrl, this.partImgUrl,
      this.printOf);

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
}
