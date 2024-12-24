import 'dart:async';

import 'package:json_annotation/json_annotation.dart';
import 'package:requests_with_riverpod/models/kind.dart';

part 'cat.g.dart';

@JsonSerializable()
class Cat {
  Cat({
    required this.id,
    required this.color,
    required this.age,
    required this.description,
    required this.userId,
    required this.kind,
    required this.averageRating,
  });

  final int id;
  final String color;
  final int age;
  final String description;
  @JsonKey(name: 'user')
  final int userId;
  final Kind kind;
  @JsonKey(name: 'average_rating')
  final double averageRating;

  factory Cat.fromJson(Map<String, dynamic> json) => _$CatFromJson(json);
  Map<String, dynamic> toJson() => _$CatToJson(this);
}
