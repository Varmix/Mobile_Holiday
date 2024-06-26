import 'dart:async';
import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/exceptions/holiday_auth_exception.dart';
import 'package:holiday_mobile/data/exceptions/holiday_storage_exception.dart';
import 'package:holiday_mobile/data/models/login/login.dart';
import 'package:holiday_mobile/data/models/user_authentificated/user_authentificated.dart';
import 'package:holiday_mobile/data/providers/dio/dio_instance.dart';
import 'package:holiday_mobile/data/secure_storage/secure_storage.dart';
import 'package:holiday_mobile/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:logger/logger.dart';
import '../services/authentification/authentification_service.dart';

class AuthAPiProvider {
  final DioService _dioService;
  late final Dio _dio;
  var logger = Logger();

  final AuthService _authService = AuthService();
  final _controller = StreamController<AuthStatus>();
  UserAuthentificated? _userAuthentificated;
  UserAuthentificated? get userConnected => _userAuthentificated;

  // Syntaxe dart qui me permet de donner une liste
  // d'intialisation du constructeur mais qui sera exécute avant celui-ci
  AuthAPiProvider() : _dioService = DioService() {
    _dio = _dioService.dio;

    // Vérifier si le jwt est en cache. S'il est toujours valide, on va le reconnecter.
    readCacheData();
  }

  Stream<AuthStatus> get authStatusStream => _controller.stream;

  void _emitAuthStatus(AuthStatus status) {
    _controller.add(status);
  }

  Future<void> logInSimple(Login login) async {
    try {
      Response response = await _dio.post('v1/authentification/login',
          data: {'email': login.email, 'password': login.password});
      String jwt = response.data;

      await loginProcedure(jwt);
      logger.i("Authentification réalisée avec succès.");

    } on DioException catch (e) {
      logger.e("Erreur lors de l'authentification.");
      throw ApiException(e.response?.data ?? "Une erreur s'est produite lors de l'authentification", e);
    } on HolidayAuthException catch (e) {
      logger.e("Erreur lors de l'authentification.");
      throw ApiException(e.message, null);
    } on HolidayStorageException catch (e) {
      logger.e("Erreur lors de la récupération du token dans le stockage sécurisé.");
      throw ApiException(e.message, null);
    }
    (e, stacktrace) {
      logger.e("Erreur lors de l'authentification.");
      throw ApiException("Une erreur s'est produite lors de l'authentification", e);
    };
  }

  Future<void> logInGoogle(String tokenId) async {
    try {
      Response response = await _dio
          .post('v1/authentification/googleauth', data: {'tokenId': tokenId});
      String jwt = response.data;

      await loginProcedure(jwt);
      logger.i("Authentification avec Google réalisée avec succès.");

    } on DioException catch (e) {
      logger.e("Erreur lors de l'authentification avec Google.");
      throw ApiException(e.response?.data ?? "Une erreur s'est produite lors de l'authentification", e);
    } on HolidayAuthException catch (e) {
      logger.e("Erreur lors de l'authentification avec Google.");
      throw ApiException(e.message, null);
    } on HolidayStorageException catch (e) {
      logger.e("Erreur lors de la récupération du token dans le stockage sécurisé lors de l'authentification Google.");
      throw ApiException(e.message, null);
    }
    (e, stacktrace) {
      logger.e("Erreur lors de l'authentification avec Google.");
      throw ApiException("Une erreur s'est produite lors de l'authentification", e);
    };
  }

  Future<void> loginProcedure(String jwt) async {
    // Decoder JWT (si exception attrapée dans la méthode parente)
    _userAuthentificated = _authService.decodeJwt(jwt);
    // Placer le bearer dans les headers du Dio
    _dioService.setAuthorizationBearer(jwt);
    await _authService.secureStorage.writeSecureData(SecureStorage.jwtKey, jwt);

    // Avertir Bloc Authentification que l'utilisateur est connecté
    _emitAuthStatus(AuthStatus.authentificated);
  }

  void readCacheData() async {
    try {
      String? token =
          await _authService.secureStorage.readSecureData(SecureStorage.jwtKey);
      // Si le token est null, l'utilisateur a été deconnecté au préalable
      if (token == null) {
        _emitAuthStatus(AuthStatus.disconnected);
        return;
      }
      int tokenExpiration = _authService.decodeJwtExp(token);
      // Si le token en cache est expité, l'utilisateur est considéré comme déconnecté
      if (_authService.isTokenExpired(tokenExpiration)) {
        // on va la catch juste en dessous et il réalisera la procédure de déconnexion
        throw HolidayAuthException("JWT expiré");
      }
      // Si l'utilisateur est connecté
      _dioService.setAuthorizationBearer(token);
      _userAuthentificated = _authService.decodeJwt(token);
      _emitAuthStatus(AuthStatus.authentificated);
    } on HolidayAuthException {
      await disconnectProcedure();
    } on HolidayStorageException {
      await disconnectProcedure();
    }
  }

  Future<void> disconnectProcedure() async {
    try {
      await _authService.secureStorage.deleteSecureData(SecureStorage.jwtKey);
    } catch (e) {
      // Pas besoin d'informer l'utilisateur. Pourquoi ? Le pire des cas est que le token
      // reste dans le cache dès qu'il va se login, ça le remplacera de toute manière
      logger.e("Le token n'a pas pu être supprimé du stockage sécurisé lors de la procédure de déconnexion.");
    } finally {
      _emitAuthStatus(AuthStatus.disconnected);
    }
  }

  void logOut() async {
    _dioService.setAuthorizationBearer(null);
    await disconnectProcedure();
  }

  void dispose() {
    _controller.close();
  }
}
