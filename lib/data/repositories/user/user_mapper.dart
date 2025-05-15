import 'package:ccl_app/domain/model/user.dart';
import 'package:injectable/injectable.dart';

/// A utility class responsible for mapping database query results to `User` model instances,
/// and providing SQL schema creation for the `users` table.
///
/// This mapper is used in conjunction with the local SQLite database layer to convert
/// raw query data into domain-specific objects.
///
/// Annotated with `@injectable` to enable dependency injection via `injectable` package.
@injectable
class UserMapper {
  /// Maps a dynamic result (usually from SQLite) into a list of [User] objects.
  ///
  /// Expects [result] to be a `List<dynamic>` where each item is a map representing a user.
  /// The expected keys in each map are:
  /// - `'id'`: user's ID
  /// - `'first_name'`: user's first name
  /// - `'last_name'`: user's last name
  /// - `'email'`: user's email
  /// - `'password'`: user's password
  ///
  /// Example:
  /// ```dart
  /// final users = userMapper.mapToUsers(dbResponse);
  /// ```
  List<User> mapToUsers(dynamic result) {
    return (result as List<dynamic>).map(
          (dynamic user) {
        return User(
          id: user['id'],
          firstName: user['first_name'],
          lastName: user['last_name'],
          email: user['email'],
          password: user['password'],
        );
      },
    ).toList();
  }

  /// SQL query to create the `users` table in SQLite if it does not already exist.
  ///
  /// The table contains the following fields:
  /// - `id`: INTEGER, primary key, auto-incremented
  /// - `first_name`: TEXT, not null
  /// - `last_name`: TEXT, not null
  /// - `email`: TEXT, not null
  /// - `password`: TEXT, not null
  ///
  /// Can be used in combination with `DatabaseClient.executeQuery()`.
  String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    );
  ''';
}
