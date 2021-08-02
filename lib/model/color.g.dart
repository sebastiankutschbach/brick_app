// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color _$ColorFromJson(Map<String, dynamic> json) => Color(
      json['id'] as int,
      json['name'] as String,
      json['rgb'] as String,
      json['is_trans'] as bool,
    );

Map<String, dynamic> _$ColorToJson(Color instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rgb': instance.rgb,
      'is_trans': instance.isTransparent,
    };
