import 'package:holiday_mobile/data/models/activity/activity.dart';
import 'package:holiday_mobile/data/models/location/location.dart';
import 'package:json_annotation/json_annotation.dart';

import '../participant/participant.dart';

part 'holiday.g.dart';

@JsonSerializable()
class Holiday {
  final String? id;
  final String name;
  final String? description;
  final String startDate;
  final String endDate;
  final Location location;
  final String creatorId;
  final List<Participant> participants;
  bool isPublish;
  final List<Activity> activities;
  final String holidayPath;

  Holiday({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.creatorId,
    required this.participants,
    required this.isPublish,
    required this.activities,
    required this.holidayPath,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) => _$HolidayFromJson(json);
  Map<String, dynamic> toJson() => _$HolidayToJson(this);
}
