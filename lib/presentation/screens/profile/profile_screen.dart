import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holiday_mobile/data/providers/authentification_api_provider.dart';
import 'package:holiday_mobile/data/repositories/authentification_api_repository.dart';
import 'package:holiday_mobile/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:holiday_mobile/logic/blocs/profile/profile_bloc.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
          AuthRepository(RepositoryProvider.of<AuthAPiProvider>(context))),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Mon profil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.visible,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF1E3A8A),
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              context.read<ProfileBloc>().add(const ProfileEmailRequest());
              return buildProfilePage(context);
            },
          )),
    );
  }

  Container buildProfilePage(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: const Icon(
                      Icons.account_circle,
                      size: 150,
                    ),
                  ),
                  const Text("Connecté en tant que : ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email,
                    builder: (context, state) {
                      return Text(
                        state.email,
                        style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                      child: Image.asset("assets/images/vacation.gif")
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthentificationLogoutRequest());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                ),
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Se déconnecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
