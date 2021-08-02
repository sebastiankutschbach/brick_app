// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Part _$PartFromJson(Map<String, dynamic> json) => Part(
      json['part_num'] as String,
      json['name'] as String,
      json['part_cat_id'] as int,
      json['part_url'] as String,
      json['part_img_url'] as String?,
      json['print_of'] as String?,
    );

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
      'part_num': instance.partNum,
      'name': instance.name,
      'part_cat_id': instance.partCatId,
      'part_url': instance.partUrl,
      'part_img_url': instance.partImgUrl,
      'print_of': instance.printOf,
    };
