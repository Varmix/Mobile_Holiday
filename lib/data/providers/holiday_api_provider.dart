import 'package:dio/dio.dart';
import 'package:holiday_mobile/data/exceptions/api_exception.dart';
import 'package:holiday_mobile/data/models/holiday/holiday.dart';
import 'package:holiday_mobile/data/providers/dio_instance.dart';

class HolidayApiProvider{
    final Dio _dio = createDioInstance();


    Future<Holiday> fetchHolidayPublished() async {
      try {
        Response response = await _dio.get('v1/Holiday/allPublished');
        print(response.data);

        return Holiday.fromJson(response.data);

      } on DioException catch (e){
        print("Exception 1 occurred: $e ");
        throw ApiException.fromJson(e.response?.data);

      } catch (e, stacktrace) {
        print("Exception 2 occurred: $e stackTrace: $stacktrace");
        throw ApiException("Une erreur s'est produite lors de la récupération des vacances publiées", e);
      }
    }
}