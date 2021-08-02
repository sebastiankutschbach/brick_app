import 'package:json_annotation/json_annotation.dart';

part 'brick_set_list.g.dart';

@JsonSerializable()
class BrickSetList {
  final int id;
  @JsonKey(name: 'is_buildable')
  final bool isBuildable;
  final String name;
  @JsonKey(name: 'num_sets')
  final int numSets;

  BrickSetList(this.id, this.isBuildable, this.name, this.numSets);

  factory BrickSetList.fromJson(Map<String, dynamic> json) =>
      _$BrickSetListFromJson(json);
}
