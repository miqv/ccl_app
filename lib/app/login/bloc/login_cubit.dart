import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/core/utils.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/usecases/login/login_usecase.dart';

part 'login_state.dart';

/// [LoginCubit] manages the state logic for the login process.
///
/// It uses the BLoC (Cubit) pattern to handle different login-related states:
/// initialization, success, failure, and password visibility toggle.
///
/// It also validates the email format and hashes the password using SHA-256
/// before sending the credentials to the use case.
@injectable
class LoginCubit extends Cubit<LoginState> {
  /// Constructs a [LoginCubit] and injects the login use case dependency.
  ///
  /// Requires an instance of [LoginUseCase].
  LoginCubit(this._loginUseCase) : super(LoginInit());

  /// The use case responsible for user authentication.
  final LoginUseCase _loginUseCase;

  /// Flag that determines whether the password is visible in the UI.
  bool _isPasswordVisible = false;

  /// Simulates an initial loading delay before emitting the login initial state.
  ///
  /// Useful for splash screens or introductory animations.
  Future<void> start() async {
    await Future.delayed(const Duration(seconds: 3));
    emit(LoginInit());
  }

  /// Attempts to log in with the provided credentials.
  ///
  /// - Validates that the email has a proper format using [StringExtension.isValidEmail].
  /// - Hashes the password using SHA-256 via [StringExtension.hashPassword].
  /// - Emits [LoginSucceeded] if authentication is successful.
  /// - Emits [LoginFailed] on validation or authentication failure.
  ///
  /// Parameters:
  /// - [email]: The user’s input email address.
  /// - [password]: The plain password that will be hashed before use.
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

  /// Toggles the password visibility state in the UI.
  ///
  /// Switches between hidden and visible password states and emits
  /// a [LoginPassword] state with the updated visibility flag.
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPassword(isPasswordVisible: _isPasswordVisible));
  }
}
