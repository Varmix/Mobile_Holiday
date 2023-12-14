import 'package:formz/formz.dart';

enum HolidayNameInputError { invalid, empty }

extension HolidayNameInputErrorExtension on HolidayNameInputError {
  String get message {
    switch (this) {
      case HolidayNameInputError.empty:
        return "Merci de spécifier un nom à votre séjour !";
      case HolidayNameInputError.invalid:
        return "Le nom doit contenir entre 3 et 50 caractères et peut inclure des lettres, des chiffres, des apostrophes, des tirets, des espaces et certains caractères spéciaux.";
      default:
        return "Erreur inconnue. Veuillez contacter un administrateur.";
    }
  }
}

class HolidayNameInput extends FormzInput<String, HolidayNameInputError> {
  const HolidayNameInput.pure() : super.pure('');
  const HolidayNameInput.dirty({String value = ''}) : super.dirty(value);

  static final holidayNameRegExp = RegExp(
    r"^[A-Za-z\dÀ-ÿ #$%*+@\[\]'\-,]{3,50}$",
  );

  @override
  HolidayNameInputError? validator(String value) {
    return value.isEmpty ? HolidayNameInputError.empty : holidayNameRegExp.hasMatch(value) ? null : HolidayNameInputError.invalid;
  }
}