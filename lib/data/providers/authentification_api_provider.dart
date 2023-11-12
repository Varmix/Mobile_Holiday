import 'dart:async';

import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/models/login/login.dart';
import 'package:holiday_mobile/data/models/user_authentificated/user_authentificated.dart';
import 'package:holiday_mobile/data/providers/dio_instance.dart';
import 'package:holiday_mobile/data/secure_storage/secure_storage.dart';
import 'package:holiday_mobile/logic/blocs/auth_bloc/auth_bloc.dart';

import '../services/authentification/authentification_service.dart';

class AuthAPiProvider {

  final DioService _dioService;
  late final Dio _dio;
  // TODO : passer dans le constructeur
  final AuthService _authService = AuthService();

  final _controller = StreamController<AuthStatus>();

  late UserAuthentificated? _userAuthentificated;

  // Syntaxe dart qui me permet de donner une liste
  // d'intialisation du constructeur mais qui sera exécute avant celui-ci
  AuthAPiProvider() : _dioService = DioService() {
    _dio = _dioService.dio;

    // regarder si jwt est en cache lorsque l'utilisateur revient sur l'application afin
    // de le reconnecter s'il est toujours valide

  }



  Future<void> logInSimple(Login login) async {
    try {
      Response response = await _dio.post('v1/authentification/login', data: {'email' : login.email, 'password': login.password});
      print(response.data);
      String jwt = response.data;

      // Decoder JWT
      try {
        _userAuthentificated = _authService.decodeJwt(jwt);
      } on ApiException catch (e) {
          throw ApiException(e.message, null);
      }
      // Bearer header
      _dioService.setAuthorizationBearer(jwt);
      // Secure Storage
      _authService.secureStorage.writeSecureData(SecureStorage.jwtKey, jwt);

      print('Headers in DioService: ${DioService().dio.options.headers}');
      print('STORAGE VALUE : ${await _authService.secureStorage.readSecureData(SecureStorage.jwtKey)}');

      // Avertir Bloc Authentification que l'utilisateur est connecté

      // Token -> string
     // return jwt;

    } on DioException catch (e){
      throw ApiException('Une erreur s\'est produite lors de l\'authentification', e);

    } catch (e, stacktrace) {
      throw ApiException("Une erreur s'est produite lors de l'authentification", e);
    }
  }
}