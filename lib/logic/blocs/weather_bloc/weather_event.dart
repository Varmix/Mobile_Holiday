part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable{
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeather extends WeatherEvent {
  final String holidayId;

  const GetWeather({required this.holidayId});

  @override
  List<Object> get props => [holidayId];
}