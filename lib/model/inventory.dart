import 'package:brick_app/model/color.dart';
import 'package:brick_app/model/part.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable()
class Inventory {
  final int id;
  @JsonKey(name: 'inv_part_id')
  final int partId;
  @JsonKey(name: 'set_num')
  final String setNum;
  final int quantity;
  final Part part;
  final Color color;
  @JsonKey(name: 'is_spare')
  final bool isSpare;
  @JsonKey(name: 'element_id')
  final String? elementId;
  @JsonKey(name: 'num_sets')
  final int numSets;

  Inventory(this.id, this.partId, this.setNum, this.quantity, this.part,
      this.color, this.isSpare, this.elementId, this.numSets);

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}
