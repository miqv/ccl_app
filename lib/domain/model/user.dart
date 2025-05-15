import 'package:equatable/equatable.dart';

/// Represents a user entity within the CCL application domain.
///
/// This model encapsulates the identity and credentials of a user.
/// It uses `Equatable` to enable value-based equality, which is especially useful
/// for testing and state comparison in Bloc or Cubit patterns.
///
/// ### Fields:
/// - [id] *(optional)*: Unique identifier for the user (may be null before DB insertion).
/// - [firstName]: The user's first name (required).
/// - [lastName]: The user's last name (required).
/// - [email]: The user's email address (required).
/// - [password]: The user's password (required; should be encrypted in production).
///
/// ### Features:
/// - `copyWith` method for immutability and state updates.
/// - `toMap` method for serialization (e.g., for database or API usage).
/// - Equatable integration for value comparison.
///
/// ### Example Usage:
/// ```dart
/// final user = User(
///   firstName: 'Alice',
///   lastName: 'Smith',
///   email: 'alice@example.com',
///   password: 'secure123',
/// );
///
/// final updatedUser = user.copyWith(lastName: 'Johnson');
/// final json = user.toMap();
/// ```
class User extends Equatable {
  /// Creates a [User] instance.
  ///
  /// [id] is optional (null if not yet persisted), others are required.
  const User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// Unique identifier of the user (nullable).
  final int? id;

  /// User's first name.
  final String firstName;

  /// User's last name.
  final String lastName;

  /// User's email address.
  final String email;

  /// User's password.
  final String password;

  /// Equatable props for enabling value equality.
  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    password,
  ];

  /// Creates a copy of the current user with updated fields.
  ///
  /// Useful for immutable state management.
  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Converts the user instance into a map.
  ///
  /// Useful for database insertion or API serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }
}
