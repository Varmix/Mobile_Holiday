part of 'login_bloc.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginSubmit extends LoginEvent {
  const LoginSubmit();
}

class GoogleLoginSubmit extends LoginEvent {
  const GoogleLoginSubmit();
}

class GoogleLoginSubmitted extends LoginEvent {
  final String idToken;
  const GoogleLoginSubmitted({required this.idToken});
  @override
  List<Object> get props => [idToken];
}
