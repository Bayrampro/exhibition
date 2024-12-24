import 'package:json_annotation/json_annotation.dart';

part 'kind.g.dart';

@JsonSerializable()
class Kind {
  Kind({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Kind.fromJson(Map<String, dynamic> json) => _$KindFromJson(json);

  Map<String, dynamic> toJson() => _$KindToJson(this);
}
