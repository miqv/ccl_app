import 'package:equatable/equatable.dart';

/// Abstract base class representing a failure or error in the application.
///
/// All specific failure types should extend from [Failure].
/// Inherits from [Equatable] to support equality comparisons.
/// Provides a [message] field to describe the error.
abstract class Failure extends Equatable {
  const Failure({this.message = ''});

  /// A human-readable description of the failure.
  final String message;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Failure: $message';
}

/// Represents an unknown or unexpected error.
class UnknownFailure extends Failure {
  const UnknownFailure({String message = ''}) : super(message: message);
}

/// Represents an error that occurs during server or database interactions.
class ServerFailure extends Failure {
  const ServerFailure({String message = ''}) : super(message: message);
}

/// Represents a failure due to network connectivity or request issues.
class NetworkFailure extends Failure {
  const NetworkFailure({String message = ''}) : super(message: message);
}

/// Represents a failure related to authentication, such as invalid credentials.
class AuthFailure extends Failure {
  const AuthFailure({String message = ''}) : super(message: message);
}

/// Represents a failure due to user input validation (e.g., empty fields).
class InputValidationFailure extends Failure {
  const InputValidationFailure({String message = ''}) : super(message: message);
}

/// Represents a domain-level validation error (e.g., business rule violation).
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
