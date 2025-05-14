part of 'register_cubit.dart';

/// Clase base abstracta para representar los estados del `RegisterCubit`.
abstract class RegisterState {
  const RegisterState();
}

/// Clase base para estados que deben implementar comparación por valor usando Equatable.
abstract class RegisterStateEquatable extends RegisterState with EquatableMixin {
  const RegisterStateEquatable();

  @override
  List<Object> get props => <Object>[];
}

/// Estado inicial del formulario de registro.
class RegisterInit extends RegisterStateEquatable {}

/// Estado que indica que el registro fue exitoso.
class RegisterSucceeded extends RegisterState {}

/// Estado que se emite cuando los campos del formulario necesitan validación.
/// Se utiliza para mostrar errores en los inputs de la UI.
class RegisterValidatedFields extends RegisterState {}

/// Estado que indica que el registro falló.
/// Puede incluir un mensaje opcional de error para mostrar al usuario.
class RegisterFailed extends RegisterState {
  final String? message;

  /// [message] es un mensaje opcional con detalles del error.
  RegisterFailed({this.message});
}

/// Estado que se emite cuando se cambia la visibilidad de la contraseña.
/// Se usa para mostrar u ocultar el texto del campo de contraseña en la UI.
class RegisterPassword extends RegisterState {
  const RegisterPassword({required this.isPasswordVisible});

  /// Indica si la contraseña debe mostrarse o no en texto plano.
  final bool isPasswordVisible;
}
