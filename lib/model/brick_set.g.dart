// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brick_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrickSet _$BrickSetFromJson(Map<String, dynamic> json) => BrickSet(
      json['set_num'] as String,
      json['name'] as String,
      json['year'] as int,
      json['theme_id'] as int,
      json['num_parts'] as int,
      json['set_img_url'] as String,
      json['set_url'] as String,
      DateTime.parse(json['last_modified_dt'] as String),
    );

Map<String, dynamic> _$BrickSetToJson(BrickSet instance) => <String, dynamic>{
      'set_num': instance.setNum,
      'name': instance.name,
      'year': instance.year,
      'theme_id': instance.themeId,
      'num_parts': instance.numParts,
      'set_img_url': instance.imgUrl,
      'set_url': instance.url,
      'last_modified_dt': instance.lastModified.toIso8601String(),
    };
