import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:holiday_mobile/data/repositories/authentification_api_repository.dart';
import 'package:holiday_mobile/logic/blocs/login_bloc/login_bloc.dart';
import 'package:holiday_mobile/presentation/widgets/common/GenericInputField.dart';
import 'package:holiday_mobile/presentation/widgets/common/custom_message.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../data/providers/authentification_api_provider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
          AuthRepository(RepositoryProvider.of<AuthAPiProvider>(context))),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Holiday',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.visible,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            // Message d'erreur
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentMaterialBanner()
                ..showMaterialBanner(CustomMessage(message: "${state.errorMessage}").build(context));
            }
          },
          builder: (context, state) {
            return _buildLoginForm(context);
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Center(
          child: Container(
            margin: const EdgeInsets.all(50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: const Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Form(
                      child: Column(
                        children: [
                          // EmailInput(),
                          Container(
                            margin:  const EdgeInsets.only(bottom: 20),
                            child: GenericInputField<LoginBloc, LoginState>(
                                    buildWhen: (previous, current) => previous.email != current.email,
                                    labelText: 'Email *',
                                    hintText: 'john.doe@gmail.com',
                                    onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email: email)),
                                    errorText: (state) => !state.email.isPure && state.email.isNotValid ? state.errorMessage : null
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: GenericInputField<LoginBloc, LoginState>(
                                buildWhen: (previous, current) => previous.password != current.password,
                                labelText: 'Mot de passe *',
                                hintText: '***********',
                                onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password: password)),
                                isPassword: true,
                                errorText: (state) => !state.password.isPure && state.password.isNotValid ? state.errorMessage : null
                            ),
                          ),
                          LoginButton(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    // Espacement interne du Container
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: const GoogleButton(),
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
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () {
              context.read<LoginBloc>().add(const LoginSubmit());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
            ),
            child: const Text("Se connecter"),
          ),
        );
      },
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.isSubmitted != current.isSubmitted,
      builder: (context, state) {
        return Container(
            margin: const EdgeInsets.only(top: 20),
            child: state.isSubmitted ? const CircularProgressIndicator() : SignInButton(
                Buttons.googleDark,
                text: 'Se connecter avec Google',
                onPressed: () => context.read<LoginBloc>().add(GoogleLoginSubmit()))
        );
      },
    );
  }
}
