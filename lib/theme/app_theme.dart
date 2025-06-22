import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    primaryColor: Colors.blue[300],
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue[300]!,
      onPrimary: Colors.white,
      secondary: Colors.blueAccent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: const Color(0xFF161B22),
      onSurface: Colors.white,
      
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161B22),
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    cardTheme: CardThemeData(
    color: const Color(0xFF161B22),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E2633),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(color: Colors.blue[100]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: WidgetStateProperty.all(Colors.blue[400]),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Colors.white, fontSize: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.blue),
      trackColor: WidgetStateProperty.all(Colors.blueGrey),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.blue[300],
      inactiveTrackColor: Colors.blueGrey[800],
      thumbColor: Colors.blue[300],
      overlayColor: Colors.blue.withAlpha(50), // ok. 20% przezroczystości
    ),
  );
}
