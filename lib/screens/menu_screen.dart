import 'package:flutter/material.dart';
import 'add_entry_screen.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'stats_screen.dart';



class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FibroTrack Menu')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('New Entry'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEntryScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('View Entries'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pain Calendar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              },
        ),
        ElevatedButton.icon(
  icon: const Icon(Icons.bar_chart),
  label: const Text('Statystyki'),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StatsScreen()),
    );
  },
),


          ],
          
        ),
      ),
    );
  }
}
