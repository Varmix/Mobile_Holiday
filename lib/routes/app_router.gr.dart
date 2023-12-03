// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:holiday_mobile/data/models/activity/activity.dart' as _i17;
import 'package:holiday_mobile/data/models/holiday/holiday.dart' as _i18;
import 'package:holiday_mobile/presentation/screens/activity/activity_screen.dart'
    as _i1;
import 'package:holiday_mobile/presentation/screens/activity/add_and_edit_activity_screen.dart'
    as _i3;
import 'package:holiday_mobile/presentation/screens/authentification/login_page.dart'
    as _i9;
import 'package:holiday_mobile/presentation/screens/chat/chat_page.dart' as _i2;
import 'package:holiday_mobile/presentation/screens/holiday/add_and_edit_holiday_screen.dart'
    as _i4;
import 'package:holiday_mobile/presentation/screens/holiday/holidays_screen.dart'
    as _i7;
import 'package:holiday_mobile/presentation/screens/holiday/my_holiday_screen.dart'
    as _i11;
import 'package:holiday_mobile/presentation/screens/invitation/invitations_screen.dart'
    as _i8;
import 'package:holiday_mobile/presentation/screens/maps/maps_screen.dart'
    as _i10;
import 'package:holiday_mobile/presentation/screens/participant/encode_participant_activity_screen.dart'
    as _i5;
import 'package:holiday_mobile/presentation/screens/participant/encode_participant_holiday_screen.dart'
    as _i6;
import 'package:holiday_mobile/presentation/screens/profile/profile_screen.dart'
    as _i12;
import 'package:holiday_mobile/presentation/screens/splash/splash_screen.dart'
    as _i13;
import 'package:holiday_mobile/presentation/screens/weather/weather_screen.dart'
    as _i14;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    ActivityRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ActivityRouteArgs>(
          orElse: () => ActivityRouteArgs(
                activityId: pathParams.getString('activityId'),
                holidayId: pathParams.getString('holidayId'),
                isPublish: pathParams.getBool('isPublish'),
              ));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ActivityScreen(
          key: args.key,
          activityId: args.activityId,
          holidayId: args.holidayId,
          isPublish: args.isPublish,
        ),
      );
    },
    ChatRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRouteArgs>(
          orElse: () => ChatRouteArgs(
                holidayName: pathParams.getString('holidayName'),
                holidayId: pathParams.getString('holidayId'),
              ));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ChatScreen(
          key: args.key,
          holidayName: args.holidayName,
          holidayId: args.holidayId,
        ),
      );
    },
    EncodeActivityRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EncodeActivityRouteArgs>(
          orElse: () => EncodeActivityRouteArgs(
              holidayId: pathParams.getString('holidayId')));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.EncodeActivityScreen(
          key: args.key,
          holidayId: args.holidayId,
          activity: args.activity,
        ),
      );
    },
    EncodeHoliday.name: (routeData) {
      final args = routeData.argsAs<EncodeHolidayArgs>(
          orElse: () => const EncodeHolidayArgs());
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.EncodeHoliday(
          key: args.key,
          holiday: args.holiday,
        ),
      );
    },
    EncodeParticipantActivityRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EncodeParticipantActivityRouteArgs>(
          orElse: () => EncodeParticipantActivityRouteArgs(
              activityId: pathParams.getString('activityId')));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.EncodeParticipantActivityScreen(
          key: args.key,
          activityId: args.activityId,
        ),
      );
    },
    EncodeParticipantHolidayRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EncodeParticipantHolidayRouteArgs>(
          orElse: () => EncodeParticipantHolidayRouteArgs(
              holidayId: pathParams.getString('holidayId')));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.EncodeParticipantHolidayScreen(
          key: args.key,
          holidayId: args.holidayId,
        ),
      );
    },
    HolidaysRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HolidaysScreen(),
      );
    },
    InvitationsRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.InvitationsScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.LoginPage(),
      );
    },
    MapRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<MapRouteArgs>(
          orElse: () => MapRouteArgs(
                activityName: pathParams.getString('activityName'),
                destinationLatitude:
                    pathParams.getDouble('destinationLatitude'),
                destinationLongitude:
                    pathParams.getDouble('destinationLongitude'),
              ));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.MapScreen(
          key: args.key,
          activityName: args.activityName,
          destinationLatitude: args.destinationLatitude,
          destinationLongitude: args.destinationLongitude,
        ),
      );
    },
    MyHolidayRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<MyHolidayRouteArgs>(
          orElse: () =>
              MyHolidayRouteArgs(holidayId: pathParams.getString('holidayId')));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.MyHolidayPage(
          key: args.key,
          holidayId: args.holidayId,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.ProfilePage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SplashPage(),
      );
    },
    WeatherRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WeatherRouteArgs>(
          orElse: () => WeatherRouteArgs(
                holidayId: pathParams.getString('holidayId'),
                holidayName: pathParams.getString('holidayName'),
              ));
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.WeatherScreen(
          key: args.key,
          holidayId: args.holidayId,
          holidayName: args.holidayName,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ActivityScreen]
class ActivityRoute extends _i15.PageRouteInfo<ActivityRouteArgs> {
  ActivityRoute({
    _i16.Key? key,
    required String activityId,
    required String holidayId,
    required bool isPublish,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ActivityRoute.name,
          args: ActivityRouteArgs(
            key: key,
            activityId: activityId,
            holidayId: holidayId,
            isPublish: isPublish,
          ),
          rawPathParams: {
            'activityId': activityId,
            'holidayId': holidayId,
            'isPublish': isPublish,
          },
          initialChildren: children,
        );

  static const String name = 'ActivityRoute';

  static const _i15.PageInfo<ActivityRouteArgs> page =
      _i15.PageInfo<ActivityRouteArgs>(name);
}

class ActivityRouteArgs {
  const ActivityRouteArgs({
    this.key,
    required this.activityId,
    required this.holidayId,
    required this.isPublish,
  });

  final _i16.Key? key;

  final String activityId;

  final String holidayId;

  final bool isPublish;

  @override
  String toString() {
    return 'ActivityRouteArgs{key: $key, activityId: $activityId, holidayId: $holidayId, isPublish: $isPublish}';
  }
}

/// generated route for
/// [_i2.ChatScreen]
class ChatRoute extends _i15.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i16.Key? key,
    required String holidayName,
    required String holidayId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            holidayName: holidayName,
            holidayId: holidayId,
          ),
          rawPathParams: {
            'holidayName': holidayName,
            'holidayId': holidayId,
          },
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const _i15.PageInfo<ChatRouteArgs> page =
      _i15.PageInfo<ChatRouteArgs>(name);
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.holidayName,
    required this.holidayId,
  });

  final _i16.Key? key;

  final String holidayName;

  final String holidayId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, holidayName: $holidayName, holidayId: $holidayId}';
  }
}

/// generated route for
/// [_i3.EncodeActivityScreen]
class EncodeActivityRoute extends _i15.PageRouteInfo<EncodeActivityRouteArgs> {
  EncodeActivityRoute({
    _i16.Key? key,
    required String holidayId,
    _i17.Activity? activity,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EncodeActivityRoute.name,
          args: EncodeActivityRouteArgs(
            key: key,
            holidayId: holidayId,
            activity: activity,
          ),
          rawPathParams: {'holidayId': holidayId},
          initialChildren: children,
        );

  static const String name = 'EncodeActivityRoute';

  static const _i15.PageInfo<EncodeActivityRouteArgs> page =
      _i15.PageInfo<EncodeActivityRouteArgs>(name);
}

class EncodeActivityRouteArgs {
  const EncodeActivityRouteArgs({
    this.key,
    required this.holidayId,
    this.activity,
  });

  final _i16.Key? key;

  final String holidayId;

  final _i17.Activity? activity;

  @override
  String toString() {
    return 'EncodeActivityRouteArgs{key: $key, holidayId: $holidayId, activity: $activity}';
  }
}

/// generated route for
/// [_i4.EncodeHoliday]
class EncodeHoliday extends _i15.PageRouteInfo<EncodeHolidayArgs> {
  EncodeHoliday({
    _i16.Key? key,
    _i18.Holiday? holiday,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EncodeHoliday.name,
          args: EncodeHolidayArgs(
            key: key,
            holiday: holiday,
          ),
          initialChildren: children,
        );

  static const String name = 'EncodeHoliday';

  static const _i15.PageInfo<EncodeHolidayArgs> page =
      _i15.PageInfo<EncodeHolidayArgs>(name);
}

class EncodeHolidayArgs {
  const EncodeHolidayArgs({
    this.key,
    this.holiday,
  });

  final _i16.Key? key;

  final _i18.Holiday? holiday;

  @override
  String toString() {
    return 'EncodeHolidayArgs{key: $key, holiday: $holiday}';
  }
}

/// generated route for
/// [_i5.EncodeParticipantActivityScreen]
class EncodeParticipantActivityRoute
    extends _i15.PageRouteInfo<EncodeParticipantActivityRouteArgs> {
  EncodeParticipantActivityRoute({
    _i16.Key? key,
    required String activityId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EncodeParticipantActivityRoute.name,
          args: EncodeParticipantActivityRouteArgs(
            key: key,
            activityId: activityId,
          ),
          rawPathParams: {'activityId': activityId},
          initialChildren: children,
        );

  static const String name = 'EncodeParticipantActivityRoute';

  static const _i15.PageInfo<EncodeParticipantActivityRouteArgs> page =
      _i15.PageInfo<EncodeParticipantActivityRouteArgs>(name);
}

class EncodeParticipantActivityRouteArgs {
  const EncodeParticipantActivityRouteArgs({
    this.key,
    required this.activityId,
  });

  final _i16.Key? key;

  final String activityId;

  @override
  String toString() {
    return 'EncodeParticipantActivityRouteArgs{key: $key, activityId: $activityId}';
  }
}

/// generated route for
/// [_i6.EncodeParticipantHolidayScreen]
class EncodeParticipantHolidayRoute
    extends _i15.PageRouteInfo<EncodeParticipantHolidayRouteArgs> {
  EncodeParticipantHolidayRoute({
    _i16.Key? key,
    required String holidayId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          EncodeParticipantHolidayRoute.name,
          args: EncodeParticipantHolidayRouteArgs(
            key: key,
            holidayId: holidayId,
          ),
          rawPathParams: {'holidayId': holidayId},
          initialChildren: children,
        );

  static const String name = 'EncodeParticipantHolidayRoute';

  static const _i15.PageInfo<EncodeParticipantHolidayRouteArgs> page =
      _i15.PageInfo<EncodeParticipantHolidayRouteArgs>(name);
}

class EncodeParticipantHolidayRouteArgs {
  const EncodeParticipantHolidayRouteArgs({
    this.key,
    required this.holidayId,
  });

  final _i16.Key? key;

  final String holidayId;

  @override
  String toString() {
    return 'EncodeParticipantHolidayRouteArgs{key: $key, holidayId: $holidayId}';
  }
}

/// generated route for
/// [_i7.HolidaysScreen]
class HolidaysRoute extends _i15.PageRouteInfo<void> {
  const HolidaysRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HolidaysRoute.name,
          initialChildren: children,
        );

  static const String name = 'HolidaysRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i8.InvitationsScreen]
class InvitationsRoute extends _i15.PageRouteInfo<void> {
  const InvitationsRoute({List<_i15.PageRouteInfo>? children})
      : super(
          InvitationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'InvitationsRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i10.MapScreen]
class MapRoute extends _i15.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i16.Key? key,
    required String activityName,
    required double destinationLatitude,
    required double destinationLongitude,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          MapRoute.name,
          args: MapRouteArgs(
            key: key,
            activityName: activityName,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude,
          ),
          rawPathParams: {
            'activityName': activityName,
            'destinationLatitude': destinationLatitude,
            'destinationLongitude': destinationLongitude,
          },
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i15.PageInfo<MapRouteArgs> page =
      _i15.PageInfo<MapRouteArgs>(name);
}

class MapRouteArgs {
  const MapRouteArgs({
    this.key,
    required this.activityName,
    required this.destinationLatitude,
    required this.destinationLongitude,
  });

  final _i16.Key? key;

  final String activityName;

  final double destinationLatitude;

  final double destinationLongitude;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, activityName: $activityName, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude}';
  }
}

/// generated route for
/// [_i11.MyHolidayPage]
class MyHolidayRoute extends _i15.PageRouteInfo<MyHolidayRouteArgs> {
  MyHolidayRoute({
    _i16.Key? key,
    required String holidayId,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          MyHolidayRoute.name,
          args: MyHolidayRouteArgs(
            key: key,
            holidayId: holidayId,
          ),
          rawPathParams: {'holidayId': holidayId},
          initialChildren: children,
        );

  static const String name = 'MyHolidayRoute';

  static const _i15.PageInfo<MyHolidayRouteArgs> page =
      _i15.PageInfo<MyHolidayRouteArgs>(name);
}

class MyHolidayRouteArgs {
  const MyHolidayRouteArgs({
    this.key,
    required this.holidayId,
  });

  final _i16.Key? key;

  final String holidayId;

  @override
  String toString() {
    return 'MyHolidayRouteArgs{key: $key, holidayId: $holidayId}';
  }
}

/// generated route for
/// [_i12.ProfilePage]
class ProfileRoute extends _i15.PageRouteInfo<void> {
  const ProfileRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SplashPage]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i14.WeatherScreen]
class WeatherRoute extends _i15.PageRouteInfo<WeatherRouteArgs> {
  WeatherRoute({
    _i16.Key? key,
    required String holidayId,
    required String holidayName,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          WeatherRoute.name,
          args: WeatherRouteArgs(
            key: key,
            holidayId: holidayId,
            holidayName: holidayName,
          ),
          rawPathParams: {
            'holidayId': holidayId,
            'holidayName': holidayName,
          },
          initialChildren: children,
        );

  static const String name = 'WeatherRoute';

  static const _i15.PageInfo<WeatherRouteArgs> page =
      _i15.PageInfo<WeatherRouteArgs>(name);
}

class WeatherRouteArgs {
  const WeatherRouteArgs({
    this.key,
    required this.holidayId,
    required this.holidayName,
  });

  final _i16.Key? key;

  final String holidayId;

  final String holidayName;

  @override
  String toString() {
    return 'WeatherRouteArgs{key: $key, holidayId: $holidayId, holidayName: $holidayName}';
  }
}
