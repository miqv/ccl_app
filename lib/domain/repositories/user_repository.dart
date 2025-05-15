import 'package:ccl_app/domain/core/failures.dart';
import 'package:ccl_app/domain/model/user.dart';
import 'package:dartz/dartz.dart';

/// Abstract contract that defines user-related operations for authentication and persistence.
///
/// This interface enables the separation of domain logic from infrastructure
/// and allows for interchangeable implementations (e.g., SQLite, Firebase).
/// Each method uses the functional `Either` type for consistent error handling.
///
/// ### Responsibilities:
/// - Authenticate users.
/// - Fetch single or multiple user records.
/// - Create new users.
/// - Retrieve user data by email or ID.
///
/// ### Error Handling:
/// Returns `Either<Failure, T>` where:
/// - `Left(Failure)` represents an error.
/// - `Right(T)` represents a successful result.
///
/// ### Example Usage:
/// ```dart
/// final result = await repository.getUserLogin('admin@example.com', '1234');
/// result.fold(
///   (failure) => handleError(failure),
///   (user) => handleLogin(user),
/// );
/// ```
abstract class UserRepository {
  /// Authenticates a user with [username] (usually email) and [password].
  ///
  /// Returns:
  /// - `Right(User)` on successful login.
  /// - `Left(Failure)` if credentials are incorrect or on error.
  Future<Either<Failure, User>> getUserLogin(String username, String password);

  /// Retrieves a list of all users from the data source.
  ///
  /// Returns:
  /// - `Right(List<User>)` on success.
  /// - `Left(Failure)` on failure (e.g., database issues).
  Future<Either<Failure, List<User>>> getUsers();

  /// Retrieves a single user by [email].
  ///
  /// Returns:
  /// - `Right(User)` if the user is found.
  /// - `Left(Failure)` if not found or error occurs.
  Future<Either<Failure, User>> getUser(String email);

  /// Retrieves a user by their [userId].
  ///
  /// Returns:
  /// - `Right(User)` on success.
  /// - `Left(Failure)` if the user is not found or an error occurs.
  Future<Either<Failure, User>> getUserId(int userId);

  /// Adds a new [User] to the data source.
  ///
  /// Returns:
  /// - `Right(User)` with the newly created user.
  /// - `Left(Failure)` if insertion fails.
  Future<Either<Failure, User>> newUser(User user);
}
