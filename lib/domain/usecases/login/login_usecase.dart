import 'package:equatable/equatable.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';

/// Abstract use case for user login authentication.
///
/// This use case defines a contract to handle user authentication
/// using a [LoginParams] object that contains credentials.
///
/// It returns an `Either<Failure, User>` to standardize error and success handling.
abstract class LoginUseCase extends UseCase<User, LoginParams> {}

/// Concrete implementation of [LoginUseCase] that authenticates a user
/// by retrieving their information and verifying credentials.
///
/// It also sets the authenticated user into the [GlobalState].
///
/// ### Dependencies:
/// - [UserRepository] for fetching user data.
/// - [GlobalState] for session persistence.
///
/// ### Returns:
/// - `Right(User)` if credentials are valid.
/// - `Left(Failure)` if user not found or credentials are invalid.
@Injectable(as: LoginUseCase)
class LoginUseCaseImpl implements LoginUseCase {
  LoginUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final UserRepository repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    final result = await repository.getUser(params.email);

    return result.fold(
      (l) => left(l),
      (User user) async {
        if (params.email == user.email && params.password == user.password) {
          globalState.user = user;
          return right(user);
        }
        return left(ServerFailure(message: ''));
      },
    );
  }
}

/// Parameters for the login use case containing user credentials.
///
/// This class uses Equatable for value comparison, helpful in tests and Bloc.
class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });

  /// User's email address (used as username).
  final String email;

  /// User's raw password (not encrypted in this context).
  final String password;

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
