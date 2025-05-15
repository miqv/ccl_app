import 'package:ccl_app/core/translations/localization_constants.dart';

Map<String, dynamic> esCO = {
  ..._general,
  ..._error,
  ..._login,
  ..._register,
  ..._products,
  ..._navigation,
};

Map<String, dynamic> _general = {
  LocaleKeys.general.title: 'Busqueda de nombre...',
  LocaleKeys.general.close: 'Cerrar',
  LocaleKeys.general.cancel: 'Cancelar',
  LocaleKeys.general.save: 'Guardar',
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
  LocaleKeys.register.failedMessageExistingEmail:
      'El correo electrónico ya está registrado',
  LocaleKeys.register.labelTextFirstName: 'Nombre',
  LocaleKeys.register.labelTextLastName: 'Apellido',
  LocaleKeys.register.labelTextEmail: 'Correo',
  LocaleKeys.register.labelTextPassword: 'Contraseña',
  LocaleKeys.register.requiredField: '* Campo obligatorio',
  LocaleKeys.register.emailFieldError: '* Correo invalido',
  LocaleKeys.register.registerButton: 'Crear usuario',
};

Map<String, dynamic> _products = {
  LocaleKeys.products.labelTextSearch: 'Buscar producto ...',
  LocaleKeys.products.noResultsFound: 'No se encontraron resultados',
  LocaleKeys.products.tooltipProduct: 'Agregar producto',
  LocaleKeys.products.titleInput: 'Entradas',
  LocaleKeys.products.titleOutput: 'Salidas',
  LocaleKeys.products.titleStock: 'Stock',
  LocaleKeys.products.addProductName: 'Nombre',
  LocaleKeys.products.errorProductName: 'Ingresa un nombre',
  LocaleKeys.products.addProductDescription: 'Descripción',
  LocaleKeys.products.errorProductDescription: 'Ingresa una descripción',
};

Map<String, dynamic> _navigation = {
  LocaleKeys.navigation.titleProducts: 'Productos',
  LocaleKeys.navigation.titleInputOutput: 'Entradas / Salidas',
};
