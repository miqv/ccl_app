import 'package:ccl_app/data/remote/db/db_client.dart';
import 'package:ccl_app/data/repositories/user/user_mapper.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Implementation of [UserRepository] that handles local database operations
/// related to user data, using SQLite via [DatabaseClient] and mapping logic via [UserMapper].
///
/// Responsibilities:
/// - Handles user login authentication
/// - Creates new users
/// - Queries users by email or ID
/// - Retrieves the list of all users
///
/// This class is injectable with the `@injectable` annotation and can be injected
/// wherever [UserRepository] is required.
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.dbClient,
    required this.mapper,
  });

  final DatabaseClient dbClient;
  final UserMapper mapper;

  /// Attempts to authenticate a user by [username] and [password].
  ///
  /// Queries the `users` table using both fields.
  /// Returns:
  /// - `Right(User)` if found
  /// - `Left(ServerFailure)` on query error
  /// - `Left(UnknownFailure)` if no matching user is found
  @override
  Future<Either<Failure, User>> getUserLogin(
      String username, String password) async {
    Either<String, dynamic> result = await dbClient
        .get('users', 'email = ? AND password = ?', [username, password]);

    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        final users = await mapper.mapToUsers(response);
        if (users.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(users.first);
      },
    );
  }

  /// Fetches all users from the `users` table.
  ///
  /// Returns:
  /// - `Right(List<User>)` if successful
  /// - `Left(ServerFailure)` on error
  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    Either<String, dynamic> result = await dbClient.getAll('users');

    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        List<User> users = mapper.mapToUsers(response);
        return right(users);
      },
    );
  }

  /// Retrieves a single user by [email].
  ///
  /// Returns:
  /// - `Right(User)` if found
  /// - `Left(ServerFailure)` on query error
  /// - `Left(UnknownFailure)` if not found
  @override
  Future<Either<Failure, User>> getUser(String email) async {
    Either<String, dynamic> result =
    await dbClient.get('users', 'email = ?', [email]);

    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        final users = await mapper.mapToUsers(response);
        if (users.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(users.first);
      },
    );
  }

  /// Inserts a new [user] into the database.
  ///
  /// Ensures the `users` table exists before inserting.
  /// Returns the newly created user by re-querying after insertion.
  ///
  /// Returns:
  /// - `Right(User)` if successful
  /// - `Left(ServerFailure)` on error
  @override
  Future<Either<Failure, User>> newUser(User user) async {
    Either<String, bool> existsTable = await dbClient.existsTable('users');

    return existsTable.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (bool exists) async {
        if (!exists) {
          await dbClient.executeQuery(mapper.createTableQuery);
        }

        Either<String, dynamic> result =
        await dbClient.insert('users', user.toMap());

        return result.fold(
              (String l) => left(ServerFailure(message: l.toString())),
              (dynamic _) async => getUser(user.email),
        );
      },
    );
  }

  /// Retrieves a user by [userId].
  ///
  /// Returns:
  /// - `Right(User)` if found
  /// - `Left(ServerFailure)` on query error
  /// - `Left(UnknownFailure)` if not found
  @override
  Future<Either<Failure, User>> getUserId(int userId) async {
    Either<String, dynamic> result =
    await dbClient.get('users', 'id = ?', [userId]);

    return result.fold(
          (String l) => left(ServerFailure(message: l.toString())),
          (dynamic response) async {
        final users = await mapper.mapToUsers(response);
        if (users.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(users.first);
      },
    );
  }
}
