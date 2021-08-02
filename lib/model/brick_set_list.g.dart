// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brick_set_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrickSetList _$BrickSetListFromJson(Map<String, dynamic> json) => BrickSetList(
      json['id'] as int,
      json['is_buildable'] as bool,
      json['name'] as String,
      json['num_sets'] as int,
    );

Map<String, dynamic> _$BrickSetListToJson(BrickSetList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_buildable': instance.isBuildable,
      'name': instance.name,
      'num_sets': instance.numSets,
    };
