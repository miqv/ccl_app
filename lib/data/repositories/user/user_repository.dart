import 'package:ccl_app/data/remote/db/db_client.dart';
import 'package:ccl_app/data/repositories/user/user_mapper.dart';
import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:ccl_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.dbClient,
    required this.mapper,
  });

  final DatabaseClient dbClient;
  final UserMapper mapper;

  @override
  Future<Either<Failure, User>> getUserLogin(
      String username, String password) async {
    Either<String, dynamic> result = await dbClient
        .get('users', 'email = ? AND password = ?', [username, password]);
    return result.fold(
      (String l) {
        return left(ServerFailure(message: l.toString()));
      },
      (dynamic response) async {
        final users = await mapper.mapToUsers(response);
        if (users.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(users.first);
      },
    );
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    Either<String, dynamic> result = await dbClient.getAll('users');
    return result.fold(
      (String l) {
        return left(ServerFailure(message: l.toString()));
      },
      (dynamic response) async {
        List<User> users = mapper.mapToUsers(response);
        return right(users);
      },
    );
  }

  @override
  Future<Either<Failure, User>> getUser(String email) async {
    Either<String, dynamic> result =
        await dbClient.get('users', 'email = ?', [email]);
    return result.fold(
      (String l) {
        return left(ServerFailure(message: l.toString()));
      },
      (dynamic response) async {
        final users = await mapper.mapToUsers(response);
        if (users.isEmpty) {
          return left(UnknownFailure(message: ""));
        }
        return right(users.first);
      },
    );
  }

  @override
  Future<Either<Failure, User>> newUser(User user) async {
    Either<String, bool> existsTable = await dbClient.existsTable('users');
    return existsTable.fold(
      (String l) {
        return left(ServerFailure(message: l.toString()));
      },
      (bool exists) async {
        if (!exists) {
          await dbClient.executeQuery(mapper.createTableQuery);
        }

        Either<String, dynamic> result =
            await dbClient.insert('users', user.toMap());
        return result.fold(
          (String l) {
            return left(ServerFailure(message: l.toString()));
          },
          (dynamic response) async {
            Future<Either<Failure, User>> resultUser = getUser(user.email);
            return resultUser;
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, User>> getUserId(int userId) async {
    Either<String, dynamic> result =
        await dbClient.get('users', 'id = ?', [userId]);
    return result.fold(
      (String l) {
        return left(ServerFailure(message: l.toString()));
      },
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
