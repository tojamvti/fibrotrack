import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/pain_entry.dart';
import '../widgets/pain_by_weekday_chart.dart';


class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = Hive.box<PainEntry>('pain_entries').values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Statystyki')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: entries.isEmpty
            ? const Center(child: Text('Brak danych do analizy.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Intensywność bólu (ostatnie wpisy)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  PainByWeekdayChart(entries: entries),
                ],
              ),
      ),
    );
  }
}
