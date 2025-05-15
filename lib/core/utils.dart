import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Extension on [String] providing additional utilities.
///
/// This extension adds common string-related functionality such as password
/// hashing and email format validation. Useful in scenarios involving user
/// authentication and form input validation.
extension StringExtension on String {
  /// Hashes the string using the SHA-256 algorithm.
  ///
  /// Typically used to securely transform a password into its hashed
  /// representation for secure storage.
  ///
  /// Example:
  /// ```dart
  /// String hashed = 'my_secure_password'.hashPassword();
  /// ```
  ///
  /// Returns a hexadecimal string representing the hashed value.
  String hashPassword() {
    final bytes = utf8.encode(this); // Convert the string to UTF-8 bytes
    final digest = sha256.convert(bytes); // Apply SHA-256 hashing
    return digest.toString(); // Return the result as a hexadecimal string
  }

  /// Validates whether the string is a well-formed email address.
  ///
  /// Uses a regular expression to match valid email formats including
  /// letters, numbers, dots, dashes, and domains.
  ///
  /// Example:
  /// ```dart
  /// 'user@example.com'.isValidEmail(); // true
  /// 'invalid@email'.isValidEmail(); // false
  /// ```
  ///
  /// Returns `true` if the string matches a valid email format, `false` otherwise.
  bool isValidEmail() {
    final emailRegExp = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    );
    return emailRegExp.hasMatch(this);
  }
}
