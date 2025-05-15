part of 'register_cubit.dart';

/// Abstract base class representing the state of [RegisterCubit].
abstract class RegisterState {
  const RegisterState();
}

/// Abstract base class for states that require value comparison via [Equatable].
abstract class RegisterStateEquatable extends RegisterState
    with EquatableMixin {
  const RegisterStateEquatable();

  @override
  List<Object> get props => <Object>[];
}

/// Initial state of the registration form.
///
/// Typically emitted when the form is first loaded or reset.
class RegisterInit extends RegisterStateEquatable {}

/// State indicating that the user registration was successful.
///
/// Triggers success feedback and navigation in the UI.
class RegisterSucceeded extends RegisterState {}

/// State indicating that the form fields need validation.
///
/// Commonly used to show validation errors in the UI inputs.
class RegisterValidatedFields extends RegisterState {}

/// State indicating that the registration process failed.
///
/// May include an optional error [message] to inform the user.
class RegisterFailed extends RegisterState {
  /// Optional error message to display to the user.
  final String? message;

  /// Creates a [RegisterFailed] state with an optional [message].
  RegisterFailed({this.message});
}

/// State emitted when the password visibility changes.
///
/// Used to show or hide the password input in the UI.
class RegisterPassword extends RegisterState {
  /// Whether the password should be shown in plain text.
  final bool isPasswordVisible;

  /// Creates a [RegisterPassword] state with the given visibility status.
  const RegisterPassword({required this.isPasswordVisible});
}
