import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/models/invitation/invitation.dart';
import 'package:holiday_mobile/data/models/participant/participant.dart';
import 'package:holiday_mobile/data/providers/dio/dio_instance.dart';
import 'package:logger/logger.dart';

class InvitationsApiProvider{
  final Dio _dio = DioService().dio;
  var logger = Logger();

  Future<void> createInvitations(List<Participant> participants, String holidayId) async {
    try {

      //Création des invitations
      List<Invitation> invitations = Invitation.createInvitations(participants, holidayId);

      //Conversion en JSON
      List<Map<String, dynamic>> invitationsJsonList = Invitation.invitationsToJsonList(invitations);

      await _dio.post('v1/invitations', data: invitationsJsonList);
      logger.i("Création d'une invitation effectuée avec succès.");

    } on DioException catch (e){
      logger.e("Erreur lors de la création d'une invitation");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors de la création d'une invitation");
      throw ApiException("Une erreur s'est produite lors de la création des invitations", stacktrace);
    }
  }


  Future<List<Invitation>> fetchAllInvitationsByParticipant() async {
    try {
      final response = await _dio.get('v1/invitations');

      List<Invitation> invitations = (response.data as List<dynamic>).map((index) => Invitation.fromJson(index as Map<String, dynamic>)).toList();

      logger.i("Récupération de toutes les invitations d'un participant effectuée avec succès.");
      return invitations;

    } on DioException catch (e){
      logger.e("Erreur lors de la récupération de toutes les invitations d'un participant.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors de la récupération de toutes les invitations d'un participant.");
      throw ApiException("Une erreur s'est produite lors de la récupération de vos invitations.", stacktrace);
    }
  }

  Future<void> acceptInvitation(String invitationId) async {
    try {

      await _dio.put('v1/invitations/$invitationId');
      logger.i("Acceptation de l'invitation $invitationId réalisée avec succès.");

    } on DioException catch (e){
      logger.e("Erreur lors de l'acceptation de l'invitation $invitationId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors de l'acceptation de l'invitation $invitationId.");
      throw ApiException("Une erreur s'est produite lors de l'acceptation de l'invitation.'", stacktrace);
    }
  }

  Future<void> refuseInvitation(String invitationId) async {
    try {
      await _dio.delete('v1/invitations/$invitationId');
      logger.i("Refus de l'invitation $invitationId réalisée avec succès.");

    } on DioException catch (e){
      logger.e("Erreur lors du refus de l'invitation $invitationId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.e("Erreur lors du refus de l'invitation $invitationId .");
      throw ApiException("Une erreur s'est produite lors du refus de l'invitation.", stacktrace);
    }
  }
}