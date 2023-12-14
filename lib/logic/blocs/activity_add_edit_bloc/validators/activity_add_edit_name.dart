import 'package:formz/formz.dart';

enum ActivityNameInputError { invalid, empty }

extension ActivityNameInputErrorExtension on ActivityNameInputError {
  String get message {
    switch (this) {
      case ActivityNameInputError.empty:
        return "Merci de spécifier un nom à votre activité !";
      case ActivityNameInputError.invalid:
        return "Le nom doit contenir entre 3 et 50 caractères et peut inclure des lettres, des chiffres, des apostrophes, des tirets, des espaces et certains caractères spéciaux.";
      default:
        return "Erreur inconnue. Veuillez contacter un administrateur.";
    }
  }
}

class ActivityNameInput extends FormzInput<String, ActivityNameInputError> {
  const ActivityNameInput.pure() : super.pure('');
  const ActivityNameInput.dirty({String value = ''}) : super.dirty(value);

  static final activityNameRegExp = RegExp(
    r"^[A-Za-z\dÀ-ÿ #$%*+@\[\]'\-,]{3,50}$",
  );

  @override
  ActivityNameInputError? validator(String value) {
    return value.isEmpty ? ActivityNameInputError.empty : activityNameRegExp.hasMatch(value) ? null : ActivityNameInputError.invalid;
  }
}