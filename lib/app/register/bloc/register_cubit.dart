import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/core/utils.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/usecases/user/new_user_usecase.dart';

part 'register_state.dart';

/// [RegisterCubit] gestiona el estado de la pantalla de registro de usuario.
/// Controla la visibilidad de la contraseña, la validación de campos y
/// la ejecución del caso de uso de registro de nuevo usuario.
@injectable
class RegisterCubit extends Cubit<RegisterState> {
  /// Constructor que inyecta el caso de uso necesario.
  RegisterCubit(this._newUserUseCase) : super(RegisterInit());

  final NewUserUseCase _newUserUseCase;

  bool _isPasswordVisible = false;
  bool _isValidatedFields = false;

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;

  /// Reinicia el estado del formulario.
  Future<void> start() async {
    emit(RegisterInit());
  }

  /// Asigna el primer nombre y valida si ya se solicitó validación previa.
  void setFirstName(String firstName) {
    _firstName = firstName.trim();
    _emitValidationIfNeeded();
  }

  /// Asigna el apellido y valida si ya se solicitó validación previa.
  void setLastName(String lastName) {
    _lastName = lastName.trim();
    _emitValidationIfNeeded();
  }

  /// Asigna el correo electrónico y valida si ya se solicitó validación previa.
  void setEmail(String email) {
    _email = email.trim();
    _emitValidationIfNeeded();
  }

  /// Asigna la contraseña (encriptada) y valida si ya se solicitó validación previa.
  void setPassword(String password) {
    _password = password.hashPassword();
    _emitValidationIfNeeded();
  }

  /// Ejecuta el proceso de registro si los campos son válidos.
  Future<void> register() async {
    // Validación previa de campos
    if (_areFieldsValid()) {
      final user = User(
        firstName: _firstName!,
        lastName: _lastName!,
        email: _email!,
        password: _password!,
      );

      final Either<Failure, User> result = await _newUserUseCase(user);

      result.fold(
            (failure) => emit(RegisterFailed(message: failure.message)),
            (registeredUser) {
          // Validación adicional del usuario registrado
          if (registeredUser.firstName == _firstName) {
            emit(RegisterSucceeded());
          } else {
            emit(RegisterFailed());
          }
        },
      );
    } else {
      _isValidatedFields = true;
      emit(RegisterValidatedFields());
    }
  }

  /// Alterna la visibilidad de la contraseña.
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(RegisterPassword(isPasswordVisible: _isPasswordVisible));
  }

  /// Valida si todos los campos requeridos son válidos.
  bool _areFieldsValid() {
    return _firstName?.isNotEmpty == true &&
        _lastName?.isNotEmpty == true &&
        _email?.isValidEmail() == true &&
        _password?.isNotEmpty == true;
  }

  /// Emite el estado de validación si ya se ha solicitado.
  void _emitValidationIfNeeded() {
    if (_isValidatedFields) {
      emit(RegisterValidatedFields());
    }
  }
}
