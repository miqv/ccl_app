part of 'login_cubit.dart';

/// Abstract base class for all states related to the login process.
///
/// Serves as a common type for the states managed by [LoginCubit].
abstract class LoginState {
  /// Constant constructor to ensure immutability.
  const LoginState();
}

/// Abstract helper class that mixes in [EquatableMixin] for value comparison.
///
/// Used as a base for states that require equality checks.
abstract class LoginStateEquatable extends LoginState with EquatableMixin {
  /// Constant constructor for immutability.
  const LoginStateEquatable();

  @override
  List<Object> get props => <Object>[];
}

/// Initial login state, typically emitted when the login screen is first loaded.
///
/// Extends [LoginStateEquatable] to enable state comparison.
class LoginInit extends LoginStateEquatable {}

/// State emitted when the login process completes successfully.
///
/// Can be used to navigate the user to the main/home screen.
class LoginSucceeded extends LoginState {}

/// State emitted when the login attempt fails.
///
/// Typically used to display an error message to the user.
class LoginFailed extends LoginState {}

/// State indicating whether the password is currently visible in the form.
///
/// Useful for dynamically updating the password field UI.
class LoginPassword extends LoginState {
  /// Creates an instance of [LoginPassword] with the current visibility setting.
  const LoginPassword({required this.isPasswordVisible});

  /// Whether the password text should be shown as visible.
  final bool isPasswordVisible;
}
