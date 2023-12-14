import 'package:flutter/material.dart';
import 'package:holiday_mobile/data/models/weather_hour/weather_hour.dart';
import 'package:holiday_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

class WeatherHourItem extends StatelessWidget {
  final WeatherHour weatherHour;

  const WeatherHourItem({super.key, required this.weatherHour});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm');

    return SizedBox(
      width: 70,
      child: Card(
        color: const Color(0xFFEFF6FF),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                "${weatherHour.temp} °C",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Image.network("https:${weatherHour.pathImage}"),

            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(
                dateFormat.format(TZDateTime.parse(globalLocation!, weatherHour.dateAndTime)),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}