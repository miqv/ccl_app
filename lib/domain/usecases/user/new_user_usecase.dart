import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/core/use_case.dart';
import 'package:ccl_app/domain/global_state/global_state.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';

/// Abstract use case for registering a new user.
///
/// Takes a [User] instance as input and returns either a [Failure]
/// or the successfully created [User].
abstract class NewUserUseCase extends UseCase<User, User> {}

/// Concrete implementation of [NewUserUseCase].
///
/// This use case handles:
/// - Field validation (e.g., required fields like first name and email).
/// - Checking if the email already exists in the in-memory user list.
/// - Persisting a new user via the [UserRepository].
/// - Updating the global application state with the new user.
///
/// ### Validation:
/// - Returns a [ValidationFailure] if:
///   - The `firstName` or `email` is empty.
///   - The email already exists in the user list (fetched from repository).
///
/// ### Success:
/// - Persists the user through the repository.
/// - Updates [GlobalState] with:
///   - The new current user.
///   - The global list of users (adds the new user).
///
/// ### Dependencies:
/// - [GlobalState]: Stores global app state (e.g., current user, cached users).
/// - [UserRepository]: Abstract repository interface for user data operations.
@Injectable(as: NewUserUseCase)
class NewUserUseCaseImpl implements NewUserUseCase {
  NewUserUseCaseImpl(this.globalState, this.repository);

  final GlobalState globalState;
  final UserRepository repository;

  @override
  Future<Either<Failure, User>> call(User user) async {
    // Validate required fields
    if (user.firstName.trim().isEmpty || user.email.trim().isEmpty) {
      return left(
        ValidationFailure(message: LocaleKeys.register.failedMessage.tr()),
      );
    }

    // Fetch all users to validate duplicate email
    final resultUsers = await repository.getUsers();
    return resultUsers.fold(
          (l) => left(l),
          (List<User> users) async {
        globalState.users.addAll(users);

        final emailExists = globalState.users.any((u) => u.email == user.email);
        if (emailExists) {
          return left(
            ValidationFailure(
              message: LocaleKeys.register.failedMessageExistingEmail.tr(),
            ),
          );
        }

        // Save the new user
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
