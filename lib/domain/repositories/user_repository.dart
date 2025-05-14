import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserLogin(String username, String password);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> getUser(String email);
  Future<Either<Failure, User>> getUserId(int userId);
  Future<Either<Failure, User>> newUser(User user);
}
