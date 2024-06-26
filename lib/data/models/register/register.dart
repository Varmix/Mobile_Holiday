import 'package:json_annotation/json_annotation.dart';

part 'register.g.dart';

@JsonSerializable()
class Register {
  final String email;
  final String lastName;
  final String firstName;
  final String password;
  final String confirmPassword;

  Register({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.password,
    required this.confirmPassword,
  });

  factory Register.fromJson(Map<String, dynamic> json) => _$RegisterFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterToJson(this);
}