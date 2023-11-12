import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holiday_mobile/data/models/holiday/holiday.dart';
import 'package:holiday_mobile/logic/blocs/holiday_bloc/holiday_bloc.dart';
import 'package:holiday_mobile/logic/blocs/participant_bloc/participant_bloc.dart';
import 'package:holiday_mobile/presentation/screens/chat_page.dart';
import 'package:holiday_mobile/presentation/widgets/common/custom_message.dart';
import 'package:holiday_mobile/presentation/widgets/common/progress_loading_widget.dart';
import 'package:holiday_mobile/presentation/widgets/participant_card.dart';
import 'package:holiday_mobile/routes/app_router.gr.dart';
import '../widgets/activity_container.dart';


@RoutePage()
class MyHolidayPage extends StatefulWidget {
  final String holidayId;

  const MyHolidayPage({super.key, @PathParam() required this.holidayId});

  //Création de l'état
  @override
  _MyHolidayPageState createState() => _MyHolidayPageState();
}

class _MyHolidayPageState extends State<MyHolidayPage> {
  //Création du bloc
  final HolidayBloc _holidayBloc = HolidayBloc();

  //Création du bloc
  final ParticipantBloc _participantBloc = ParticipantBloc();

  @override
  void initState() {
    _holidayBloc.add(GetHoliday(holidayId: widget.holidayId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes vacances',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '28/03/2022',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.only(left: 10, right: 10)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color(0xFF1E3A8A);
                    }
                    return const Color(0xFF1E3A8A);
                  },
                ),
              ),
              icon: const Icon(Icons.chat),
              label: const Text('Chatter'),
              onPressed: () {
                Navigator.push(context,
                    PageRouteBuilder(pageBuilder: (_, __, ___) => ChatPage()));
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: _buildMyHoliday(),
    );
  }

  Widget _buildMyHoliday() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _holidayBloc,
        child: BlocListener<HolidayBloc, HolidayState>(
          listener: (context, state) {
            if (state is HolidayError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showMaterialBanner(CustomMessage(message: state.message!).build(context));
            }
          },
          child: BlocBuilder<HolidayBloc, HolidayState>(
            builder: (context, state) {
              if (state is HolidayInitial || state is HolidayLoading) {
                return const LoadingProgressor();
              } else if (state is HolidayLoaded) {
                final holiday = state.holidayItem;
                return _buildHoliday(context, holiday!);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHoliday(BuildContext context, Holiday holiday) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculez les largeurs des colonnes en pourcentage
    final nameColumnWidth = screenWidth * 0.20;
    final emailColumnWidth = screenWidth * 0.45;
    final buttonColumnWidth = screenWidth * 0.20;
    final tableParticipantHeight = screenHeight * 0.30;
    final cardActivityHeight = screenHeight * 0.45;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 10)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF1E3A8A)),
                      ),
                      icon: const Icon(Icons.cloud),
                      label: const Text('Météo'),
                      onPressed: () {
                        context.router.push(WeatherRoute(holidayId: holiday.id!));
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),

                    //SI VACANCES PUBLIEE
                    child: holiday.isPublish
                        ? Container(
                      height: 36.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6c757d),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Publiée',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    )

                    //SI VACANCES NON PUBLIEE
                        : ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 10)),
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF1E3A8A)),
                      ),
                      icon: const Icon(Icons.publish),
                      label: const Text('Publier'),
                      onPressed: () {
                        _holidayBloc.add(PublishHoliday(holiday: holiday));
                      },
                    ),
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 10)),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Quitter'),
                      onPressed: () {
                        //TODO CHANGE PARTICIPANT ID QUAND ON SERA CONNECTE
                        _participantBloc.add(LeaveHoliday(participantId: "22de2e91-94f8-475b-930b-87e8d9f80704", holiday: holiday));
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Tableau des participants
            ParticipantCard(
              nameColumnWidth: nameColumnWidth,
              emailColumnWidth: emailColumnWidth,
              buttonColumnWidth: buttonColumnWidth,
              tableParticipantsHeight: tableParticipantHeight,
              title: 'Participant(s)',
              icon: Icons.add,
              participants: holiday.participants,
              holidayId: widget.holidayId,
            ),

            ActivityContainer(
                activities: holiday.activities, activityHeight: cardActivityHeight)
          ],
        ),
      ),
    );
  }
}
