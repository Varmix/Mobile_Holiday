
import 'package:holiday_mobile/data/models/holiday/holiday.dart';
import 'package:json_annotation/json_annotation.dart';

import '../participant/participant.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String sendAt;
  final String content;
  final Holiday? holiday;
  final String? holidayId;
  final Participant participant;
  final String participantId;

  Message({
    required this.sendAt,
    required this.content,
    this.holiday,
    this.holidayId,
    required this.participant,
    required this.participantId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}