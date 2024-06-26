import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart';

@JsonSerializable()
class Participant {
  final String? id;
  final String? lastName;
  final String firstName;
  final String? email;
  final String? passwordHash;

  Participant({
    this.id,
    this.lastName,
    required this.firstName,
    this.email,
    this.passwordHash
  });

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
