import 'package:fibrotrack_app/shared/shared_entries_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entries/add_entry_screen.dart';
import '../entries/calendar_entries_screen.dart';
import '../stats/stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final iconColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: iconColor),
        label: Text(label, style: textStyle),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24), // przesunięcie logo niżej
              // 🟪 Tytuł aplikacji na górze, większy i wyśrodkowany
              Text(
                'FibroTrack',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 📋 Menu wyśrodkowane z równą szerokością
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuButton(
                        context,
                        icon: Icons.add,
                        label: 'Nowy wpis',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuButton(
                        context,
                        icon: Icons.list,
                        label: 'Przegląd wpisów',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CalendarEntriesScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMenuButton(
                        context,
                        icon: Icons.bar_chart,
                        label: 'Statystyki',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const StatsScreen()),
                          );
                        },
                      ),
                      
                      
                      const SizedBox(height: 12),
                      _buildMenuButton(
                        context,
                        icon: Icons.file_download,
                        label: 'Eksport danych',
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SharedEntriesScreen()),
                        );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 🚪 Przycisk wyloguj + email
              Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Wyloguj',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user != null)
                    Text(
                      'Zalogowano jako: ${user.email}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
