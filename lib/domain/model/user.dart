import 'package:equatable/equatable.dart';

/// Modelo que representa a un usuario dentro de la aplicación.
///
/// Utiliza Equatable para facilitar la comparación de instancias,
/// especialmente útil para tests o patrones como Bloc.
class User extends Equatable {
  /// Constructor constante para la clase [User].
  ///
  /// El campo [id] es opcional, los demás son obligatorios.
  const User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// Identificador único del usuario (puede ser nulo si aún no está en base de datos).
  final int? id;

  /// Nombre del usuario.
  final String firstName;

  /// Apellido del usuario.
  final String lastName;

  /// Dirección de correo electrónico del usuario.
  final String email;

  /// Contraseña del usuario (debería estar encriptada si se usa en producción).
  final String password;

  /// Sobrescribe `props` para permitir la comparación por valor con Equatable.
  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        password,
      ];

  /// Crea una copia del usuario actual con campos opcionalmente modificados.
  ///
  /// Útil para mantener la inmutabilidad del estado.
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

  /// Convierte la instancia de [User] a un mapa (JSON serializable).
  ///
  /// Ideal para interacciones con bases de datos o APIs.
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
