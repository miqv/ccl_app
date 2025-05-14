import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message = ''});
  final String message;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Failure: $message';
}

class UnknownFailure extends Failure {
  const UnknownFailure({String message = ''}) : super(message: message);
}

class ServerFailure extends Failure {
  const ServerFailure({String message = ''}) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = ''}) : super(message: message);
}

class AuthFailure extends Failure {
  const AuthFailure({String message = ''}) : super(message: message);
}

class InputValidationFailure extends Failure {
  const InputValidationFailure({String message = ''}) : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
