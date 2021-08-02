// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Moc _$MocFromJson(Map<String, dynamic> json) => Moc(
      json['set_num'] as String,
      json['name'] as String,
      json['year'] as int,
      json['theme_id'] as int,
      json['num_parts'] as int,
      json['moc_img_url'] as String,
      json['moc_url'] as String,
      json['designer_name'] as String,
      json['designer_url'] as String,
    );

Map<String, dynamic> _$MocToJson(Moc instance) => <String, dynamic>{
      'set_num': instance.setNum,
      'name': instance.name,
      'year': instance.year,
      'theme_id': instance.themeId,
      'num_parts': instance.numParts,
      'moc_img_url': instance.imgUrl,
      'moc_url': instance.url,
      'designer_name': instance.designerName,
      'designer_url': instance.designerUrl,
    };
