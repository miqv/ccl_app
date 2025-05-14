import 'package:ccl_app/core/translations/localization_constants.dart';

Map<String, dynamic> esCO = {
  ..._general,
  ..._error,
  ..._login,
  ..._register,
};

Map<String, dynamic> _general = {
  LocaleKeys.general.title: 'Busqueda de nombre...',
};

Map<String, dynamic> _error = {
  LocaleKeys.error.title: 'Busqueda de nombre...',
};

Map<String, dynamic> _login = {
  LocaleKeys.login.title: 'Inicio de sesion',
  LocaleKeys.login.labelTextEmail: 'Correo',
  LocaleKeys.login.hintTextEmail: 'Ingrese Correo',
  LocaleKeys.login.labelTextPassword: 'Contraseña',
  LocaleKeys.login.hintTextPassword: 'Ingresa Contraseña',
  LocaleKeys.login.loginButton: 'Inicio de sesion',
  LocaleKeys.login.questionRegister: '¿Ya tienes cuenta?',
  LocaleKeys.login.registerButton: 'Registro',
  LocaleKeys.login.succeededTitle: 'Exitoso!',
  LocaleKeys.login.succeededMessage: 'Inicio de sesion exitoso',
  LocaleKeys.login.failedTitle: 'Error!',
  LocaleKeys.login.failedMessage: 'Credenciales incorrectas',
};

Map<String, dynamic> _register = {
  LocaleKeys.register.title: 'Nuevo Usuario',
  LocaleKeys.register.succeededTitle: 'Exitoso!',
  LocaleKeys.register.succeededMessage: 'El usuario se creo correctamente',
  LocaleKeys.register.failedTitle: 'Error!',
  LocaleKeys.register.failedMessage: 'No se creo correctamente',
  LocaleKeys.register.failedMessageExistingEmail: 'El correo electrónico ya está registrado',
  LocaleKeys.register.labelTextFirstName: 'Nombre',
  LocaleKeys.register.labelTextLastName: 'Apellido',
  LocaleKeys.register.labelTextEmail: 'Correo',
  LocaleKeys.register.labelTextPassword: 'Contraseña',
  LocaleKeys.register.requiredField: '* Campo obligatorio',
  LocaleKeys.register.emailFieldError: '* Correo invalido',
  LocaleKeys.register.registerButton: 'Crear usuario',
};
