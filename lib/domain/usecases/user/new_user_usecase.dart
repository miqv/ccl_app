import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';

abstract class NewUserUseCase extends UseCase<User, User> {}

@Injectable(as: NewUserUseCase)
class NewUserUseCaseImpl implements NewUserUseCase {
  NewUserUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final UserRepository repository;

  @override
  Future<Either<Failure, User>> call(User user) async {
    // Validación: campos requeridos
    if (user.firstName.trim().isEmpty || user.email.trim().isEmpty) {
      return left(
        ValidationFailure(
            message: LocaleKeys.register.failedMessage.tr()),
      );
    }

    final resultUsers = await repository.getUsers();
    return resultUsers.fold(
      (l) => left(l),
      (List<User> users) async {
        globalState.users.addAll(users);
        // Validación: email ya registrado en memoria
        final emailExists = globalState.users.any((u) => u.email == user.email);
        if (emailExists) {
          return left(
            ValidationFailure(message: LocaleKeys.register.failedMessageExistingEmail.tr()),
          );
        }
        final result = await repository.newUser(user);
        return result.fold(
              (l) => left(l),
              (User user) async {
            globalState.user = user;
            globalState.users.add(user);
            return right(user);
          },
        );
      },
    );
  }
}
