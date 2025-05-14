abstract class LocaleKeys {
  static GeneralLocaleKeys general = GeneralLocaleKeys();
  static ErrorLocaleKeys error = ErrorLocaleKeys();
  static LoginLocaleKeys login = LoginLocaleKeys();
  static RegisterLocaleKeys register = RegisterLocaleKeys();
}

class GeneralLocaleKeys {
  static const String prefix = "general";
  String get title => '$prefix title';
}

class ErrorLocaleKeys {
  static const String prefix = "error";
  String get title => '$prefix title';
}

class LoginLocaleKeys {
  static const String prefix = "login";
  String get title => '$prefix title';
  String get labelTextEmail => '$prefix labelTextEmail';
  String get hintTextEmail => '$prefix hintTextEmail';
  String get labelTextPassword => '$prefix labelTextPassword';
  String get hintTextPassword => '$prefix hintTextPassword';
  String get loginButton => '$prefix loginButton';
  String get questionRegister => '$prefix questionRegister';
  String get registerButton => '$prefix registerButton';
  String get succeededTitle => '$prefix succeededTitle';
  String get succeededMessage => '$prefix succeededMessage';
  String get failedTitle => '$prefix failedTitle';
  String get failedMessage => '$prefix failedMessage';
}

class RegisterLocaleKeys {
  static const String prefix = "register";
  String get title => '$prefix title';
  String get succeededTitle => '$prefix succeededTitle';
  String get succeededMessage => '$prefix succeededMessage';
  String get failedTitle => '$prefix failedTitle';
  String get failedMessage => '$prefix failedMessage';
  String get failedMessageExistingEmail => '$prefix FailedMessageExistingEmail';
  String get labelTextFirstName => '$prefix labelTextFirstName';
  String get labelTextLastName => '$prefix labelTextLastName';
  String get labelTextEmail => '$prefix labelTextEmail';
  String get labelTextPassword => '$prefix labelTextPassword';
  String get requiredField => '$prefix requiredField';
  String get emailFieldError => '$prefix emailFieldError';
  String get registerButton => '$prefix registerButton';
}
