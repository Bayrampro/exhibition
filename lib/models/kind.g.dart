// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kind.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kind _$KindFromJson(Map<String, dynamic> json) => Kind(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$KindToJson(Kind instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
