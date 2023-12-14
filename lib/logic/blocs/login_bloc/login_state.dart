part of 'login_bloc.dart';


class LoginState extends Equatable {

  final FormzSubmissionStatus status;
  final EmailInput email;
  final PasswordInput password;
  final String? errorMessage;
  final bool isSubmitted;

  // Valeurs initiales à la création
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.errorMessage = "",
    this.isSubmitted = false
  });

  // Copier en conservant les anciennes valeurs non spécifiées en paramètres
  LoginState copyWith({
    FormzSubmissionStatus? status,
    EmailInput? email,
    PasswordInput? password,
    String? errorMessage,
    bool? isSubmitted,
  }) {
    return LoginState(
      status : status ?? this.status,
      email: email ?? this.email,
      password : password ?? this.password,
      errorMessage : errorMessage ?? this.errorMessage,
      isSubmitted : isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object> get props => [status, email, password, errorMessage ?? "", isSubmitted];
}
