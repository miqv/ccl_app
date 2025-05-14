import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/core/utils.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/usecases/login/login_usecase.dart';

part 'login_state.dart';

/// [LoginCubit] gestiona la lógica del estado para el proceso de inicio de sesión.
///
/// Utiliza el patrón BLoC (Cubit) para manejar diferentes estados relacionados
/// con el login: inicialización, éxito, fallo y visibilidad de la contraseña.
///
/// También valida el formato del correo electrónico y encripta la contraseña
/// usando SHA-256 antes de enviar las credenciales.
@injectable
class LoginCubit extends Cubit<LoginState> {
  /// Constructor que inyecta la dependencia del caso de uso de login.
  ///
  /// Requiere una instancia de [LoginUseCase].
  LoginCubit(this._loginUseCase) : super(LoginInit());

  final LoginUseCase _loginUseCase;

  /// Bandera que indica si la contraseña está visible o no.
  bool _isPasswordVisible = false;

  /// Simula una carga inicial antes de emitir el estado inicial del login.
  ///
  /// Útil para pantallas de presentación o splash.
  Future<void> start() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(LoginInit());
  }

  /// Intenta iniciar sesión con las credenciales proporcionadas.
  ///
  /// - Valida que el email tenga un formato válido usando [StringExtension.isValidEmail].
  /// - Encripta la contraseña con SHA-256 mediante [StringExtension.hashPassword].
  /// - Emite [LoginSucceeded] si el login es exitoso.
  /// - Emite [LoginFailed] si falla la validación o el login.
  Future<void> login(String email, String password) async {
    if (email.isValidEmail()) {
      final params = LoginParams(
        email: email,
        password: password.hashPassword(),
      );

      Either<Failure, User> result = await _loginUseCase(params);
      result.fold(
        (failure) => emit(LoginFailed()),
        (user) => emit(LoginSucceeded()),
      );
    } else {
      emit(LoginFailed());
    }
  }

  /// Cambia el estado de visibilidad de la contraseña.
  ///
  /// Alterna entre visible y oculto y emite [LoginPassword] con el nuevo valor.
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPassword(isPasswordVisible: _isPasswordVisible));
  }
}
