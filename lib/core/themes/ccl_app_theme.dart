import 'package:flutter/material.dart';

/// Defines the light and dark visual themes for the CCL application.
///
/// This class centralizes the configuration of color schemes, typography,
/// AppBar styles, button themes, and scaffold backgrounds to ensure a
/// consistent look and feel across the app.
///
/// It includes:
/// - [lightTheme] for light mode.
/// - [darkTheme] for dark mode.
class CclAppThemeData {
  /// Light theme configuration.
  ///
  /// Color palette:
  /// - Primary: Dark blue (`#0A1D37`)
  /// - Background: White
  /// - AppBar: Dark blue with white text
  /// - Surface: Light gray (`#F5F7FA`)
  /// - Text: Dark blue and black with high readability
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF5F7FA), // superficie clara
      labelStyle: TextStyle(color: Color(0xFF0A1D37)),
      hintStyle: TextStyle(color: Colors.black45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black26),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF0A1D37), width: 2),
      ),
    ),
  );

  /// Dark theme configuration.
  ///
  /// Color palette:
  /// - Primary: Dark blue (`#0A1D37`)
  /// - Background: Dark gray (`#121212`)
  /// - AppBar: Dark blue with white text
  /// - Surface: Medium gray (`#1E1E1E`)
  /// - Text: Solid white and white with opacity
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1E1E1E), // superficie oscura
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
    ),
  );
}
