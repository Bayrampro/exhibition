// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cat _$CatFromJson(Map<String, dynamic> json) => Cat(
      id: (json['id'] as num).toInt(),
      color: json['color'] as String,
      age: (json['age'] as num).toInt(),
      description: json['description'] as String,
      userId: (json['user'] as num).toInt(),
      kind: Kind.fromJson(json['kind'] as Map<String, dynamic>),
      averageRating: (json['average_rating'] as num).toDouble(),
    );

Map<String, dynamic> _$CatToJson(Cat instance) => <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'age': instance.age,
      'description': instance.description,
      'user': instance.userId,
      'kind': instance.kind,
      'average_rating': instance.averageRating,
    };
