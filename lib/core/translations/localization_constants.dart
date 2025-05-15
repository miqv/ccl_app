abstract class LocaleKeys {
  static GeneralLocaleKeys general = GeneralLocaleKeys();
  static ErrorLocaleKeys error = ErrorLocaleKeys();
  static LoginLocaleKeys login = LoginLocaleKeys();
  static RegisterLocaleKeys register = RegisterLocaleKeys();
  static ProductsLocaleKeys products = ProductsLocaleKeys();
  static NavigationLocaleKeys navigation = NavigationLocaleKeys();
}

class GeneralLocaleKeys {
  static const String prefix = "general";
  String get title => '$prefix title';
  String get close => '$prefix close';
  String get cancel => '$prefix cancel';
  String get save => '$prefix save';
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

class ProductsLocaleKeys {
  static const String prefix = "products";
  String get labelTextSearch => '$prefix labelTextSearch';
  String get noResultsFound => '$prefix noResultsFound';
  String get tooltipProduct => '$prefix tooltipProduct';
  String get titleInput => '$prefix titleInput';
  String get titleOutput => '$prefix titleOutput';
  String get titleStock => '$prefix titleStock';
  String get addProductName => '$prefix addProductName';
  String get errorProductName => '$prefix errorProductName';
  String get addProductDescription => '$prefix addProductDescription';
  String get errorProductDescription => '$prefix errorProductDescription';
}

class NavigationLocaleKeys {
  static const String prefix = "navigation";
  String get titleProducts => '$prefix titleProducts';
  String get titleInputOutput => '$prefix titleInputOutput';
}
