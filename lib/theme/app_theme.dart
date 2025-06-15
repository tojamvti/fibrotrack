// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  /// 🎨 MOTYW JASNY
  static final lightTheme = ThemeData(
    brightness: Brightness.light, // → ogólny tryb jasny
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary, // → główny kolor aplikacji (np. przyciski, ikony)
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground, // → tło całej aplikacji
    cardColor: AppColors.lightCard, // → kolor kart (Card, ListTile itp.)
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightText), // → domyślny kolor tekstu
    ),
    useMaterial3: true,
  );

  /// 🌙 MOTYW CIEMNY
  static final darkTheme = ThemeData(
    brightness: Brightness.dark, // → ogólny tryb ciemny
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary, // → główny kolor aplikacji w dark mode
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground, // → tło całej aplikacji
    cardColor: AppColors.darkCard, // → kolor kart (np. ListTile, Card itp.)
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText), // → domyślny kolor tekstu
      titleLarge: TextStyle(color: Colors.white), // → np. tytuły przycisków, AppBar
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground, // → tło AppBar w dark mode
      titleTextStyle: TextStyle(
        color: Colors.white, // → kolor tekstu tytułu AppBar
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white), // → kolor ikon w AppBar
    ),
    useMaterial3: true,
  );
}
