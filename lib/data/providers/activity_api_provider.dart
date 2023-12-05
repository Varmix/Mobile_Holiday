import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/models/activity/activity.dart';
import 'package:holiday_mobile/data/models/participant/participant.dart';
import 'package:holiday_mobile/data/providers/data/ActivityData.dart';
import 'package:logger/logger.dart';
import 'dio/dio_instance.dart';

class ActivityApiProvider{

  final Dio _dio = DioService().dio;
  var logger = Logger();


  Future<Activity> fetchActivityById(String activityId) async {
    try {
      Response response = await _dio.get('v1/activities/$activityId');

      // conversion list
      final activity = Activity.fromJson(response.data);

      logger.i("Activité $activityId récupérée avec succès.");
      return activity;

    } on DioException catch (e){
      logger.e("Erreur lors de la récupération de l'activité $activityId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors de la récupération de l'activité $activityId.");
      throw ApiException("Une erreur s'est produite lors de la récupération de votre activité", stacktrace);
    }
  }

  Future<void> deleteActivity(String activityId) async {
    try {
      await _dio.delete('v1/activities/$activityId');
      logger.i("Activité $activityId supprimée avec succès.");

    } on DioException catch (e){
      logger.e("Erreur lors de la suppression de l'activité $activityId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors de la suppression de l'activité $activityId.");
      throw ApiException("Une erreur s'est produite lors de la suppression de votre activité", stacktrace);
    }
  }

  Future<void> createActivity(ActivityData activityData) async {
    try {
      final formData = await buildActivityFormData(activityData);
      await _dio.post('v1/activities/', data : formData);
      logger.i("Activité créée avec succès.");

    } on DioException catch (e){
      logger.i("Erreur lors de la création de l'activité.");
      throw ApiException(e.response?.data ?? "Erreur lors de la création de l'activité.", e);

    } catch (e, stacktrace) {
      logger.i("Erreur lors de la création de l'activité.");
      throw ApiException("Une erreur s'est produite lors de la création de votre activité.", stacktrace);
    }
  }

  Future<void> updateActivity(ActivityData activityData) async {
    try {
      final formData = await buildActivityFormData(activityData, isEdit: true);

      await _dio.put('v1/activities/${activityData.activityId}', data : formData);
      logger.i("Activité ${activityData.activityId} mise à jour avec succès.");

    } on DioException catch (e){
      logger.i("Erreur lors de la mise à jour de l'activité ${activityData.activityId}.");
      throw ApiException(e.response?.data ?? "Erreur lors de la mise à jour d'une activité", e);

    } catch (e, stacktrace) {
      logger.i("Erreur lors de la mise à jour de l'activité ${activityData.activityId}.");
      throw ApiException("Une erreur s'est produite lors de la mise à jour de votre activité.", stacktrace);
    }
  }

  Future<void> deleteParticipate(String activityId, String participantId) async {
    try {
      await _dio.delete('v1/activities/$activityId/participants/$participantId');
      logger.i("Suppression de la participation du participant $participantId à l'activité $activityId réalisée avec succès.");

    } on DioException catch (e){
      logger.i("Erreur lors de la suppression de la participation du participant $participantId à l'activité $activityId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.i("Erreur lors de la suppression de la participation du participant $participantId à l'activité $activityId.");
      throw ApiException("Une erreur s'est produite lors de la suppression de la participation à l'activité.", stacktrace);
    }
  }

  Future<List<Participant>> getParticipantsByActivity(String activityId, bool isParticipated) async {
    try {
      final response = await _dio.get('v1/activities/$activityId/participants',
          queryParameters: {
            'isParticipated' : isParticipated
          });

      List<Participant> participants = (response.data as List<dynamic>).map((index) => Participant.fromJson(index as Map<String, dynamic>)).toList();

      logger.i("Récupération de tous les participants de l'activité $activityId réalisée avec succès.");
      return participants;

    } on DioException catch (e){
      logger.i("Erreur lors de la récupération de tous les participants de l'activité $activityId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.i("Erreur lors de la récupération de tous les participants de l'activité $activityId.");
      throw ApiException("Une erreur s'est produite lors de la récupération des participants de l'activité.", stacktrace);
    }
  }

  Future<void> createParticipate(String activityId, String participantId) async {
    try {

      await _dio.post('v1/activities/$activityId/participants/$participantId');
      logger.i("Création d'une participation à une activité réalisée avec succès.");

    } on DioException catch (e){
      logger.e("Erreur lors de la création d'une participation à une activité.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors de la création d'une participation à une activité.");
      throw ApiException("Une erreur s'est produite lors de la création d'une participation à l'activité.", stacktrace);
    }
  }

  Future<FormData> buildActivityFormData(ActivityData activityData, {bool isEdit = false}) async {
    Map<String, dynamic> formDataMap = {
      'name': activityData.name,
      'description': activityData.description,
      'price': activityData.price.toString().replaceAll('.', ','),
      'startDate': activityData.startDate.toIso8601String(),
      'endDate': activityData.endDate.toIso8601String(),
      'location.street': activityData.locationData.street,
      'location.number': activityData.locationData.numberBox,
      'location.locality': activityData.locationData.locality,
      'location.postalCode': activityData.locationData.postalCode,
      'location.country': activityData.locationData.country,
      'holidayId': activityData.holidayId,
    };

    if (isEdit) {
      formDataMap.addAll({
        'location.id': activityData.locationData.locationId,
        'deleteImage': activityData.deleteImage,
        'initialPath': activityData.initialPath
      });
    }

    final formData = FormData.fromMap(formDataMap);

    if (activityData.file != null) {
      formData.files.add(MapEntry(
        'UploadedActivityPicture',
        await MultipartFile.fromFile(activityData.file!.path),
      ));
    }

    return formData;
  }

}