import 'package:holiday_mobile/data/providers/data/HolidayData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/models/holiday/holiday.dart';
import 'package:holiday_mobile/data/models/participant/participant.dart';
import 'package:holiday_mobile/data/providers/dio/dio_instance.dart';
import 'package:open_file/open_file.dart';
import 'package:logger/logger.dart';

class HolidayApiProvider{

    final Dio _dio = DioService().dio;
    var logger = Logger();

    Future<List<Holiday>> fetchHolidayByParticipant(bool isPublished) async {
      try {
        Response response = await _dio.get('v1/holidays/',
            queryParameters: {
              'isPublished': isPublished
        });

        List<Holiday> holidays = (response.data as List<dynamic>).map((index) => Holiday.fromJson(index as Map<String, dynamic>)).toList();

        logger.i("Récupération de toutes les vacances d'un participant réalisée avec succès.");
        return holidays;

      } on DioException catch (e){
        logger.e("Erreur lors de la récupération de toutes les vacances d'un participant.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la récupération de toutes les vacances d'un participant.");
        throw ApiException("Une erreur s'est produite lors de la récupération de vos vacances.", stacktrace);
      }
    }

    Future<List<Holiday>> fetchHolidayPublished(bool isPublished) async {
      try {
        Response response = await _dio.get('v1/holidays/',
        queryParameters: {
          'isPublished' : isPublished
        });

        // conversion list
        List<Holiday> holidays = (response.data as List<dynamic>).map((index) => Holiday.fromJson(index as Map<String, dynamic>)).toList();

        logger.i("Récupération de toutes les vacances publiées réalisée avec succès.");
        return holidays;

      } on DioException catch (e){
        logger.e("Erreur lors de la récupération de toutes les vacances publiées.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la récupération de toutes les vacances publiées.");
        throw ApiException("Une erreur s'est produite lors de la récupération des vacances publiées.", stacktrace);
      }
    }

    Future<List<Participant>> getAllParticipantNotYetInHoliday(String holidayId, bool isParticipated) async {
      try {
        final response = await _dio.get('v1/holidays/$holidayId/participants',
            queryParameters: {
              'isParticipated' : isParticipated
            });

        List<Participant> participants = (response.data as List<dynamic>).map((index) => Participant.fromJson(index as Map<String, dynamic>)).toList();
        logger.i("Récupération de tous les participants qui ne sont pas encore dans la vacances $holidayId réalisée avec succès.");

        return participants;

      } on DioException catch (e){
        logger.e("Erreur lors de la récupération de tous les participants qui ne sont pas encore dans la vacances $holidayId.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la récupération de tous les participants qui ne sont pas encore dans la vacances $holidayId.");
        throw ApiException("Une erreur s'est produite lors de la récupération des utilisateurs ajoutables à la vacances.", stacktrace);
      }
    }

    Future<Holiday> fetchHoliday(String holidayId) async {
      try {
        Response response = await _dio.get('v1/holidays/$holidayId');
        Holiday holiday = Holiday.fromJson(response.data);

        logger.i("Récupération de la vacances $holidayId réalisée avec succès.");
        return holiday;

      } on DioException catch (e){
        logger.e("Erreur lors de la récupération de la vacances $holidayId.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la récupération de la vacances $holidayId.");
        throw ApiException("Une erreur s'est produite lors de la récupération de votre vacance", stacktrace);
      }
    }

    Future<void> publishHoliday(Holiday holiday) async {
      try {
        final holidayJson = holiday.toJson();

        await _dio.put('v1/holidays/publish', data: holidayJson);
        logger.i("Publication de la vacances ${holiday.id} réalisée avec succès.");

      } on DioException catch (e){
        logger.e("Erreur lors de la publication de la vacances ${holiday.id}.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la publication de la vacances ${holiday.id}.");
        throw ApiException("Une erreur s'est produite lors de la publication de votre vacances", stacktrace);
      }
    }

    Future<void> deleteHoliday(String holidayId) async {
      try {
        await _dio.delete('v1/holidays/$holidayId');
        logger.i("Suppression de la vacances $holidayId réalisée avec succès.");

      } on DioException catch (e){
        logger.e("Erreur lors de la suppresion de la vacances $holidayId.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la suppresion de la vacances $holidayId.");
        throw ApiException("Une erreur s'est produite lors de la suppression de votre vacances", stacktrace);
      }
    }

    Future<void> exportHolidayToIcs(String holidayId) async {
      try {
        String filePath = '${(await getTemporaryDirectory()).path}/holiday.ics';

        await _dio.download(
          'v1/holidays/$holidayId/ics',
          filePath,
        );

        OpenFile.open(filePath);
        logger.i("Exportation de la vacances $holidayId réalisée avec succès.");

      } on DioException catch (e){
        logger.i("Erreur lors de l'exportation de la vacances $holidayId.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.i("Erreur lors de l'exportation de la vacances $holidayId.");
        throw ApiException("Une erreur s'est produite lors de l'exportation de votre vacance", stacktrace);
      }
    }

  Future<void> createHoliday(HolidayData holidayData) async {
      try {
        final formData = await buildHolidayFormData(holidayData);
        await _dio.post('v1/holidays/', data : formData);
        logger.i("Création de la vacances effectuée avec succès.");

      } on DioException catch (e){
        logger.e("Erreur lors de la création de la vacances.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la création de la vacances");
        throw ApiException("Une erreur s'est produite lors de la création de votre vacances.", stacktrace);
      }
  }

    Future<void> editHoliday(HolidayData holidayData) async {
      try {

        final formData = await buildHolidayFormData(holidayData, isEdit: true);
        await _dio.put('v1/holidays/${holidayData.holidayId!}', data : formData);
        logger.i("Mise à jour de la vacances ${holidayData.holidayId} effectuée avec succès.");

      } on DioException catch (e){
        logger.e("Erreur lors de la mise à jour de la vacances ${holidayData.holidayId}.");
        throw ApiException(e.response?.data ?? "Une erreur est survenue lors de l'édition de la vacances.", e);

      } catch (e, stacktrace) {
        logger.e("Erreur lors de la mise à jour de la vacances ${holidayData.holidayId}.");
        throw ApiException("Une erreur s'est produite lors de la l'édition de votre vacances.", stacktrace);
      }
    }

    Future<void> leaveHoliday(String holidayId) async {
      try {
        await _dio.delete('v1/holidays/$holidayId/leave');
        logger.i("Vacances $holidayId quittée avec succès par un participant.");

      } on DioException catch (e){
        logger.e("Une erreur est survenue lorsqu'un utilisateur a essayé de quitté la vacances $holidayId.");
        throw ApiException(e.response?.data, e);

      } catch (e, stacktrace) {
        logger.e("Une erreur est survenue lorsqu'un utilisateur a essayé de quitté la vacances $holidayId.");
        throw ApiException("Une erreur s'est produite lors de la suppression de votre vacances.", stacktrace);
      }
    }

    Future<FormData> buildHolidayFormData(HolidayData holidayData, {bool isEdit = false}) async {
      Map<String, dynamic> formDataMap = {
        'name': holidayData.name,
        'description': holidayData.description,
        'startDate': holidayData.startDate.toIso8601String(),
        'endDate': holidayData.endDate.toIso8601String(),
        'location.street': holidayData.locationData.street,
        'location.number': holidayData.locationData.numberBox,
        'location.locality': holidayData.locationData.locality,
        'location.postalCode': holidayData.locationData.postalCode,
        'location.country': holidayData.locationData.country,
        'creatorId': holidayData.creatorId,
      };

      if (isEdit) {
        formDataMap.addAll({
          'location.id' : holidayData.locationData.locationId,
          'deleteImage' : holidayData.deleteImage,
          'initialPath' : holidayData.initialPath!,
          'isPublish' : holidayData.isPublish
        });
      }
      final formData = FormData.fromMap(formDataMap);

      if (holidayData.file != null) {
        formData.files.add(MapEntry(
          'uploadedHolidayPicture',
          await MultipartFile.fromFile(holidayData.file!.path),
        ));
      }
      return formData;
    }
}