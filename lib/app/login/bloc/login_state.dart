part of 'login_cubit.dart';

/// Clase base abstracta para todos los estados relacionados con el proceso de login.
///
/// Sirve como tipo común para los estados gestionados por [LoginCubit].
abstract class LoginState {
  /// Constructor constante para garantizar la inmutabilidad.
  const LoginState();
}

/// Clase abstracta auxiliar que mezcla [EquatableMixin] para soporte de comparación de estados.
///
/// Usada como base para estados que requieren comparación por valor.
abstract class LoginStateEquatable extends LoginState with EquatableMixin {
  /// Constructor constante para mantener la inmutabilidad.
  const LoginStateEquatable();

  @override
  List<Object> get props => <Object>[];
}

/// Estado inicial del login, típicamente emitido tras cargar la pantalla.
/// Extiende [LoginStateEquatable] para permitir la comparación.
class LoginInit extends LoginStateEquatable {}

/// Estado emitido cuando el login se realiza correctamente.
/// Puede ser utilizado para redirigir al usuario a la pantalla principal.
class LoginSucceeded extends LoginState {}

/// Estado emitido cuando falla el intento de login.
/// Puede ser utilizado para mostrar un mensaje de error.
class LoginFailed extends LoginState {}

/// Estado que indica si la contraseña está visible u oculta en el formulario.
/// Este estado es útil para actualizar dinámicamente el campo de contraseña.
class LoginPassword extends LoginState {
  /// Crea una instancia del estado con el valor actual de visibilidad.
  const LoginPassword({required this.isPasswordVisible});

  /// Indica si el texto de la contraseña debe mostrarse como visible.
  final bool isPasswordVisible;
}
