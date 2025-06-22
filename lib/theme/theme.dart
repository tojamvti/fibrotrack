import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryBlue = Color(0xFF1E88E5); // odcień niebieskiego
  static const _darkBackground = Color(0xFF121212);
  static const _lightBackground = Color(0xFFF5F5F5);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryBlue,
    scaffoldBackgroundColor: _lightBackground,
    colorScheme: ColorScheme.light(
      primary: _primaryBlue,
      secondary: Colors.blueAccent,
      onPrimary: Colors.white,
      background: _lightBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryBlue,
    scaffoldBackgroundColor: _darkBackground,
    colorScheme: ColorScheme.dark(
      primary: _primaryBlue,
      secondary: Colors.blueAccent,
      onPrimary: Colors.white,
      background: _darkBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
  );
}
