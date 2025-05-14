import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Extensión para la clase [String] que agrega funcionalidades adicionales.
extension StringExtension on String {
  /// Genera un hash SHA-256 del contenido de la cadena.
  ///
  /// Esta función es útil para el almacenamiento seguro de contraseñas,
  /// ya que transforma una cadena en su representación encriptada
  /// utilizando el algoritmo [SHA-256].
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// String hashed = 'mi_contraseña_segura'.hashPassword();
  /// ```
  ///
  /// Retorna una cadena hexadecimal que representa el hash generado.
  String hashPassword() {
    final bytes = utf8.encode(this); // Convierte la cadena a bytes UTF-8
    final digest = sha256.convert(bytes); // Aplica el algoritmo SHA-256
    return digest.toString(); // Devuelve el hash como string hexadecimal
  }

  /// Valida si el contenido del string es un correo electrónico válido.
  ///
  /// Utiliza una expresión regular para validar el formato de un correo,
  /// incluyendo letras, números, puntos, guiones y dominios válidos.
  ///
  /// Ejemplo:
  /// ```dart
  /// 'correo@ejemplo.com'.isValidEmail(); // true
  /// 'correo@mal'.isValidEmail(); // false
  /// ```
  bool isValidEmail() {
    final emailRegExp = RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
    );
    return emailRegExp.hasMatch(this);
  }
}
