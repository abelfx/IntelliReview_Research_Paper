import 'package:flutter/foundation.dart';
import 'package:frontend/domain/entities/Categoryentities.dart';

class Categorymodel extends Categoryentities {
  final String id;
  final String name;
  final String description;
  Categorymodel(
      {required this.id, required this.name, required this.description})
      : super(id: id, name: name, description: description);

  factory Categorymodel.fromjson(Map<String, dynamic> json) {
    return Categorymodel(
        id:  json["id"] ?? json["_id"] ?? "", 
        name: json["name"] ?? "",
        description: json["description"] ?? "");
  }
}
