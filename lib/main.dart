import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/auth/auth_gate.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart'; // jeśli używasz niestandardowego motywu

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicjalizacja danych lokalizacyjnych dla 'pl_PL'
  await initializeDateFormatting('pl_PL', null);

  runApp(const FibroTrackApp());
}

class FibroTrackApp extends StatelessWidget {
  const FibroTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FibroTrack',
      theme: AppTheme.darkTheme,   // lub ThemeData.light() jeśli nie masz AppTheme
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,    // Wymuszenie ciemnego motywu
      locale: const Locale('pl', 'PL'), // Język polski
      supportedLocales: const [
        Locale('pl', 'PL'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}
