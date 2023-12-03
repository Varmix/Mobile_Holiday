import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/models/weather/weather.dart';
import 'package:holiday_mobile/data/providers/dio/dio_instance.dart';
import 'package:logger/logger.dart';

class WeatherApiProvider{
  final Dio _dio = DioService().dio;
  var logger = Logger();

  Future<Weather> fetchWeatherByHoliday(String holidayId) async {
    try {
      Response response = await _dio.get('v1/weather/$holidayId');

      Weather weather = Weather.fromJson(response.data);

      logger.i("Récupération des données météo pour la vacances $holidayId réalisée avec succès.");
      return weather;

    } on DioException catch (e){
      logger.i("Erreur lors de la récupération des données météo pour la vacances $holidayId.");
      throw ApiException(e.response?.data, e);

    } catch (e, stacktrace) {
      logger.i("Erreur lors de la récupération des données météo pour la vacances $holidayId.");
      throw ApiException("Une erreur s'est produite lors de la récupération des données météo.", stacktrace);
    }
  }
}