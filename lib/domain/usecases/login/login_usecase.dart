import 'package:equatable/equatable.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';

abstract class LoginUseCase extends UseCase<User, LoginParams> {}

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

class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
