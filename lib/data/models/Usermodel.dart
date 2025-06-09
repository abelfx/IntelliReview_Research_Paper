import 'package:frontend/domain/entities/Userentities.dart';

class Usermodel extends Userentities {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String country;
  final String role;
  Usermodel(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.country,
      required this.role})
      : super(
             id:id,
            name: name,
            email: email,
            password: password,
            country: country,
            role: role);

  factory Usermodel.fromjson(Map<String, dynamic> json) {
    return Usermodel(
      id:json["id"]??"",
        name: json["name"] ?? " ",
        email: json["email"] ?? " ",
        password: json["password"] ?? " ",
        country: json["country"] ?? " ",
        role: json["role"] ?? " ");
  }
}
