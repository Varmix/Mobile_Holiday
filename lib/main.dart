import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holiday_mobile/configuration.dart';
import 'package:holiday_mobile/data/providers/authentification_api_provider.dart';
import 'package:holiday_mobile/data/providers/dio/dio_instance.dart';
import 'package:holiday_mobile/data/repositories/authentification_api_repository.dart';
import 'package:holiday_mobile/logic/blocs/activity_bloc/activity_bloc.dart';
import 'package:holiday_mobile/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:holiday_mobile/logic/blocs/chat_bloc/chat_bloc.dart';
import 'package:holiday_mobile/logic/blocs/holiday_bloc/holiday_bloc.dart';
import 'package:holiday_mobile/logic/blocs/invitation_bloc/invitation_bloc.dart';
import 'package:holiday_mobile/presentation/widgets/common/bottom_navbar.dart';
import 'package:holiday_mobile/routes/app_router.dart';
import 'package:holiday_mobile/routes/app_router.gr.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}

tz.Location? globalLocation;

void main() {
  Configuration(isProduction: true);
  tz.initializeTimeZones();
  globalLocation = tz.getLocation('Europe/Paris');
  tz.setLocalLocation(globalLocation!);
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    AuthAPiProvider authRepository = AuthAPiProvider();
    void notAuthorizedReceived() {
      authRepository.logOut();
    }
    DioService().setCallBackMethod(notAuthorizedReceived);
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthAPiProvider>.value(value: authRepository)
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(repository: AuthRepository(RepositoryProvider.of<AuthAPiProvider>(context)))),
            BlocProvider<HolidayBloc>(
                create: (context) => HolidayBloc(repository : AuthRepository(RepositoryProvider.of<AuthAPiProvider>(context)))),
            BlocProvider<InvitationBloc>(
                create: (context) => InvitationBloc()),
            BlocProvider<ChatBloc>(
                create: (context) => ChatBloc(repository : AuthRepository(RepositoryProvider.of<AuthAPiProvider>(context)))),
            BlocProvider<ActivityBloc>(
                create: (context) => ActivityBloc()),
          ],
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authentificated) {
                _appRouter.replaceAll([const HolidaysRoute()]);
              }
              if (state.status == AuthStatus.disconnected) {
                _appRouter.replaceAll([const LoginRoute()]);
              }
            },
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: MaterialApp.router(
                    routerConfig: _appRouter.config(),
                  ),
                  bottomNavigationBar: state.status == AuthStatus.authentificated
                      ? BottomNavBar(appRouter: _appRouter)
                      : null,
                ),
              );
            },
          ),
        )
    );
  }
}






