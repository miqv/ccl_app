import 'package:flutter/material.dart';

/// Clase que define los temas de estilo visual para la aplicación CCL.
///
/// Esta clase contiene dos temas:
/// - [lightTheme] para modo claro.
/// - [darkTheme] para modo oscuro.
///
/// Ambos temas configuran colores principales, fondo, AppBar, esquemas de color,
/// tipografías y estilos de botones (ElevatedButton y TextButton) para mantener
/// consistencia visual en toda la aplicación.
class CclAppThemeData {
  /// Tema claro de la aplicación.
  ///
  /// Paleta de colores:
  /// - Primario: Azul oscuro (`#0A1D37`)
  /// - Fondo: Blanco
  /// - AppBar: Azul oscuro con texto blanco
  /// - Superficie: Gris claro (`#F5F7FA`)
  /// - Texto: Azul oscuro y negro con alta legibilidad
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF0A1D37),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A1D37),
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0A1D37),
      secondary: Color(0xFF1C1C1C),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Color(0xFFF5F7FA),
      onSurface: Colors.black87,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xFF0A1D37),
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: Color(0xFF0A1D37)),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A1D37),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.black38,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF0A1D37),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );

  /// Tema oscuro de la aplicación.
  ///
  /// Paleta de colores:
  /// - Primario: Azul oscuro (`#0A1D37`)
  /// - Fondo: Gris oscuro (`#121212`)
  /// - AppBar: Azul oscuro con texto blanco
  /// - Superficie: Gris medio (`#1E1E1E`)
  /// - Texto: Blanco sólido y con opacidad
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF0A1D37),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A1D37),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0A1D37),
      secondary: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white70,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0A1D37),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.white38,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
