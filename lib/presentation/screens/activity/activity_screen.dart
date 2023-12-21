import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holiday_mobile/configuration.dart';
import 'package:holiday_mobile/data/models/activity/activity.dart';
import 'package:holiday_mobile/logic/blocs/activity_bloc/activity_bloc.dart';
import 'package:holiday_mobile/logic/blocs/holiday_bloc/holiday_bloc.dart';
import 'package:holiday_mobile/logic/blocs/maps_bloc/maps_bloc.dart';
import 'package:holiday_mobile/main.dart';
import 'package:holiday_mobile/presentation/widgets/common/custom_message.dart';
import 'package:holiday_mobile/presentation/widgets/common/icon_with_text.dart';
import 'package:holiday_mobile/presentation/widgets/common/progress_loading_widget.dart';
import 'package:holiday_mobile/routes/app_router.gr.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

@RoutePage()
class ActivityScreen extends StatefulWidget {
  final String activityId;
  final String holidayId;
  final bool isPublish;

  const ActivityScreen({
    super.key,
    @PathParam() required this.activityId,
    @PathParam() required this.holidayId,
    @PathParam() required this.isPublish,
  });

  @override
  State<ActivityScreen> createState() => _ActivityState();
}

class _ActivityState extends State<ActivityScreen> {
  final ActivityBloc _activityBloc = ActivityBloc();
  final MapsBloc _mapsBloc = MapsBloc();

  late Activity _activity;
  bool _isActivityEdited = false;

  @override
  void initState() {
    _activityBloc.add(GetActivity(activityId: widget.activityId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text("Activité"),
      ),
      body: _buildActivity(),
    );
  }


  Widget _buildActivity(){
    return WillPopScope(
        onWillPop: () async {
      if (_isActivityEdited) {
        context.read<HolidayBloc>().add(GetHoliday(holidayId: widget.holidayId));
      }
      context.read<HolidayBloc>().add(WaitingActivityAction());
      return true;
    },
    child: Container(
      margin: const EdgeInsets.all(8.0),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ActivityBloc>(
            create: (_) => _activityBloc,
          ),
          BlocProvider<MapsBloc>(
            create: (_) => _mapsBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ActivityBloc, ActivityState>(
              listener: (context, state) {
                if (state.status == ActivityStateStatus.error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(CustomMessage(message: state.errorMessage!).build(context));
                }
                if (state.status == ActivityStateStatus.deleted) {
                  context.router.pop(context);
                }
              },
            ),
            BlocListener<MapsBloc, MapsState>(
              listener: (context, state) {
                if (state.status == MapsStatus.error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(CustomMessage(message: state.errorMessage!).build(context));
                }
                if (state.status == MapsStatus.loaded) {
                  context.router.push(MapRoute(destinationLatitude: _mapsBloc.state.latitude, destinationLongitude: _mapsBloc.state.longitude, activityName: _activity.name));
                }
              },
            ),
          ],
          child: BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, state) {
              if (state.status == ActivityStateStatus.initial || state.status == ActivityStateStatus.loading) {
                return const LoadingProgressor();
              } else if (state.status == ActivityStateStatus.loaded) {
                _activity = state.activity! ;
                return _buildActivityInformation(context, _activity);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    ),
    );
  }


  Widget _buildActivityInformation(BuildContext context, Activity activity) {
    return Center(
      child: IntrinsicHeight(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                    '${Configuration().baseUrl}${activity.activityPath}'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pour espacer les widgets à l'extrémité
                  children: [
                    SizedBox(
                      width: 190.0,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          activity.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Color(0xFF1E3A8A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (!widget.isPublish)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.router
                                  .push(EncodeActivityRoute(
                                  holidayId: widget.holidayId, activity: _activity))
                                  .then((value) {
                                if (value == true) {
                                  _isActivityEdited = true;
                                }
                                _activityBloc
                                    .add(GetActivity(activityId: widget.activityId));
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDeleteConfirmationDialog(context, activity);
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                // Marge pour le Text
                child: Text(
                  activity.description ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    iconWithText(
                        Icons.calendar_month,
                        DateFormat('dd/MM/yyyy HH:mm').format(TZDateTime.parse(globalLocation!, activity.startDate))),
                    iconWithText(Icons.euro, activity.price.toStringAsFixed(2)),
                    iconWithText(Icons.location_on, activity.location.country),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    if (!widget.isPublish)
                    ElevatedButton.icon(
                      onPressed: () {
                        context.router.push(EncodeParticipantActivityRoute(
                            activityId: activity.id!));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                      ),
                      icon: const Icon(Icons.group),
                      label: const Text("Participants"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        _mapsBloc.add(GetCoordFromAddress(address: _activity.location.getFormattedAddress()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                      ),
                      icon: const Icon(Icons.location_on),
                      label: const Text("S'y rendre"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Etes-vous sûr de vouloir supprimer cette activité ?"),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer la popup
                  },
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _activityBloc.add(DeleteActivity(activityId: activity.id!));
                    context.read<HolidayBloc>().add(GetHoliday(holidayId: widget.holidayId));
                    context.router.pop();
                  },
                  child: const Text("Supprimer"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
