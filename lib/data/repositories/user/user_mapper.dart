import 'package:ccl_app/domain/model/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserMapper {
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
