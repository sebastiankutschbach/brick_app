// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) => Inventory(
      json['id'] as int,
      json['inv_part_id'] as int,
      json['set_num'] as String,
      json['quantity'] as int,
      Part.fromJson(json['part'] as Map<String, dynamic>),
      Color.fromJson(json['color'] as Map<String, dynamic>),
      json['is_spare'] as bool,
      json['element_id'] as String,
      json['num_sets'] as int,
    );

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'id': instance.id,
      'inv_part_id': instance.partId,
      'set_num': instance.setNum,
      'quantity': instance.quantity,
      'part': instance.part,
      'color': instance.color,
      'is_spare': instance.isSpare,
      'element_id': instance.elementId,
      'num_sets': instance.numSets,
    };
