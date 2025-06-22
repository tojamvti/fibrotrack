import 'package:flutter/material.dart';

class AppColors {
  // 🌞 Jasny motyw
  static const Color lightPrimary = Colors.deepPurple;
  static const Color lightBackground = Color(0xFFF5F5F5); // bardzo jasny szary
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF333333); // ciemny szary tekst

  // 🌙 Ciemny motyw
  static const Color darkPrimary = Color.fromARGB(255, 24, 0, 65);
  static const Color darkBackground = Color(0xFF121212); // typowe dark theme tło
  static const Color darkCard = Color(0xFF1E1E1E); // ciemniejszy niż tło
  static const Color darkText = Color(0xFFE0E0E0); // jasny tekst na ciemnym tle
}
