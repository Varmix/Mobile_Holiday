import 'dart:io';

import 'package:holiday_mobile/data/models/holiday/holiday.dart';
import 'package:holiday_mobile/data/models/participant/participant.dart';
import 'package:holiday_mobile/data/providers/data/HolidayData.dart';
import 'package:holiday_mobile/data/providers/holiday_api_provider.dart';

class HolidayApiRepository{
  final _holidayProvider = HolidayApiProvider();

  Future<List<Holiday>> fetchHolidayPublished(bool isPublished) {
    return _holidayProvider.fetchHolidayPublished(isPublished);
  }

  Future<List<Holiday>> fetchHolidayByParticipant(bool isPublished) {
    return _holidayProvider.fetchHolidayByParticipant(isPublished);
  }

  Future<Holiday> fetchHoliday(String holidayId) {
    return _holidayProvider.fetchHoliday(holidayId);
  }

  Future<void> publishHoliday(Holiday holiday) {
    return _holidayProvider.publishHoliday(holiday);
  }

  Future<void>  deleteHoliday(String holidayId) {
    return _holidayProvider.deleteHoliday(holidayId);
  }

  Future<void> exportHolidayToIcs(String holidayId) {
    return _holidayProvider.exportHolidayToIcs(holidayId);
  }

  Future<void> createHoliday(HolidayData holidayData) async {
    return await _holidayProvider.createHoliday(holidayData);
  }

  Future<void> updateHoliday(HolidayData holidayData) async {
    return await _holidayProvider.editHoliday(holidayData);
  }

  Future<void> leaveHoliday(String holidayId) async {
    return await _holidayProvider.leaveHoliday(holidayId);
  }

  Future<List<Participant>> getAllParticipantNotYetInHoliday(String holidayId, bool isParticipated) {
    return _holidayProvider.getAllParticipantNotYetInHoliday(holidayId, isParticipated);
  }

}