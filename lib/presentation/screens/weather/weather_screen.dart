import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holiday_mobile/data/models/weather/weather.dart';
import 'package:holiday_mobile/logic/blocs/weather_bloc/weather_bloc.dart';
import 'package:holiday_mobile/main.dart';
import 'package:holiday_mobile/presentation/widgets/common/custom_message.dart';
import 'package:holiday_mobile/presentation/widgets/common/progress_loading_widget.dart';
import 'package:holiday_mobile/presentation/widgets/weather/weather_hour_tem.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

@RoutePage()
class WeatherScreen extends StatefulWidget {
  final String holidayId;
  final String holidayName;

  const WeatherScreen(
      {super.key,
      @PathParam() required this.holidayId, @PathParam() required this.holidayName});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //Création du bloc
  final WeatherBloc _weatherBloc = WeatherBloc();

  @override
  void initState() {
    _weatherBloc.add(GetWeather(holidayId: widget.holidayId));
    super.initState();
  }

  //FORMAT DES DATES A AFFICHER
  DateFormat dateFormatFull = DateFormat('dd-MM-yyyy à HH:mm');
  DateFormat dateFormatDay = DateFormat('dd-MM-yyyy');

  //INDEX DU JOUR AFFICHE
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Météo pour ${widget.holidayName}'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: _buildWeather(),
    );
  }

  Widget _buildWeather() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _weatherBloc,
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state.status == WeatherStateStatus.error) {
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showMaterialBanner(
                    CustomMessage(message: state.errorMessage!).build(context));
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state.status == WeatherStateStatus.initial || state.status == WeatherStateStatus.loading ) {
                return const LoadingProgressor();
              } else if (state.status == WeatherStateStatus.loaded ) {
                final weather = state.weather;
                return _buildWeatherInfo(context, weather!);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(BuildContext context, Weather weather) {
    return Column(
      children: [
        // METEO DU JOUR
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              weather.weatherDays.isNotEmpty && weather.weatherDays[selectedIndex] != null
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child:  Text(
                            "Météo pour le ${dateFormatDay.format(TZDateTime.parse(globalLocation!,  weather.weatherDays[selectedIndex].date))}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Dernière mise à jour effectuée à ${DateFormat('HH:mm').format(TZDateTime.parse(globalLocation!, weather.currentDay?.date ?? weather.weatherDays[selectedIndex].date))}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                        Image.network("https:${weather.weatherDays[selectedIndex].condition.iconPath}"),


                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child:  Text(
                            weather.weatherDays[selectedIndex].condition.description,
                            style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                            ),
                            ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        ),
                      ],
                    )
                  : Container(),

              //DETAILS HEURES METEO AUJOURD'HUI
              Container(
                margin: const EdgeInsets.fromLTRB(5, 25, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    weather.weatherDays.isNotEmpty && weather.weatherDays[selectedIndex] != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Aujourd'hui",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),

                            // Slider horizontal

                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: weather.weatherDays[selectedIndex].weatherByHour.length,
                                itemBuilder: (context, index) {
                                  final weatherHour = weather.weatherDays[selectedIndex].weatherByHour[index];
                                  return WeatherHourItem(weatherHour: weatherHour);
                                },
                              ),
                            ),

                          ],
                        )
                        : Container(),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: const Text(
                        "Prochains jours",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A)),
                      ),
                    ),

                    // PROCHAINS JOURS
                    DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: 20,
                      headingRowHeight: 0,
                      // de cette manière, on cache le heaedr
                      columns: const [
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('')),
                      ],
                      rows: weather.weatherDays
                          .asMap()
                          .map((index, weatherDay) {
                            return MapEntry(
                                index,
                                DataRow(
                                    cells: [
                                      DataCell(
                                          Text(
                                              dateFormatDay.format(TZDateTime.parse(globalLocation!, weatherDay.date))
                                          )
                                      ),
                                      DataCell(Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.water_drop,
                                            color: Color(0xFF1E3A8A),
                                          ),
                                          Text('${weatherDay.riskOfRain}%')
                                        ],
                                      )),
                                      DataCell( Image.network("https:${weatherDay.condition.iconPath}")),
                                      DataCell(
                                          Text('${weatherDay.minTemp} °C')),
                                      DataCell(
                                          Text('${weatherDay.maxTemp} °C'))
                                    ],

                                    onSelectChanged: (_) {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    }));
                          })
                          .values
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
