import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/core/utils.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/usecases/user/new_user_usecase.dart';

part 'register_state.dart';

/// [RegisterCubit] manages the state of the user registration screen.
///
/// It controls password visibility, field validation, and the execution
/// of the user registration use case.
@injectable
class RegisterCubit extends Cubit<RegisterState> {
  /// Creates a [RegisterCubit] with the required [NewUserUseCase] dependency.
  RegisterCubit(this._newUserUseCase) : super(RegisterInit());

  final NewUserUseCase _newUserUseCase;

  bool _isPasswordVisible = false;
  bool _isValidatedFields = false;

  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;

  /// Resets the registration form state to its initial state.
  Future<void> start() async {
    emit(RegisterInit());
  }

  /// Updates the first name value and triggers validation if needed.
  void setFirstName(String firstName) {
    _firstName = firstName.trim();
    _emitValidationIfNeeded();
  }

  /// Updates the last name value and triggers validation if needed.
  void setLastName(String lastName) {
    _lastName = lastName.trim();
    _emitValidationIfNeeded();
  }

  /// Updates the email value and triggers validation if needed.
  void setEmail(String email) {
    _email = email.trim();
    _emitValidationIfNeeded();
  }

  /// Updates the password value (hashed) and triggers validation if needed.
  void setPassword(String password) {
    _password = password.hashPassword();
    _emitValidationIfNeeded();
  }

  /// Attempts to register the user if all required fields are valid.
  ///
  /// Emits [RegisterSucceeded] on success or [RegisterFailed] on failure.
  Future<void> register() async {
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

  /// Toggles the password visibility.
  ///
  /// Emits a [RegisterPassword] state with the updated visibility status.
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(RegisterPassword(isPasswordVisible: _isPasswordVisible));
  }

  /// Checks if all required fields are filled in and valid.
  bool _areFieldsValid() {
    return _firstName?.isNotEmpty == true &&
        _lastName?.isNotEmpty == true &&
        _email?.isValidEmail() == true &&
        _password?.isNotEmpty == true;
  }

  /// Emits a validation state if validation has been previously requested.
  void _emitValidationIfNeeded() {
    if (_isValidatedFields) {
      emit(RegisterValidatedFields());
    }
  }
}
