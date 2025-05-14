import 'package:flutter/material.dart';

//
class CclAppThemeData {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF0A1D37), // Azul oscuro
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0A1D37),
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF0A1D37),     // Azul oscuro
      secondary: Color(0xFF1C1C1C),   // Negro suave
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Color(0xFFF5F7FA),     // Gris claro de fondo
      onSurface: Colors.black87,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Color(0xFF0A1D37), fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Color(0xFF0A1D37)),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF0A1D37),
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF0A1D37),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF0A1D37),
      secondary: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white70,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}