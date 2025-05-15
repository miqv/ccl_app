import 'package:ccl_app/domain/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Generic abstract class representing a use case in the application.
///
/// Use cases encapsulate a single action or business logic operation.
/// This abstraction returns a [Future] that emits either a [Failure] (on error)
/// or a valid result of type [Type].
///
/// [Params] represents the parameters required to execute the use case.
///
/// Example usage:
/// ```dart
/// class GetProducts extends UseCase<List<Product>, NoParams> {
///   @override
///   Future<Either<Failure, List<Product>>> call(NoParams params) {
///     // Business logic to retrieve products
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Generic abstract class representing a use case that returns a result directly.
///
/// Unlike [UseCase] which uses an [Either] for error handling, this abstraction
/// returns a [Future] that emits a result of type [Type]. This might be used when
/// you need the use case to throw exceptions directly rather than using the Either mechanism.
///
/// [Params] represents the parameters for executing the use case.
///
/// Example:
/// ```dart
/// class ComputeSomething extends UseCaseResult<int, SomeParams> {
///   @override
///   Future<int> call(SomeParams params) {
///     // Perform computation and return an integer result.
///   }
/// }
/// ```
abstract class UseCaseResult<Type, Params> {
  Future<Type> call(Params params);
}

/// A helper class representing no parameters needed.
///
/// This is useful for use cases that don't require any input parameters. It extends [Equatable]
/// for easy value comparisons.
///
/// Example:
/// ```dart
/// final result = await getProductsUseCase(NoParams());
/// ```
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
