import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  DateTimeRange? _selectedRange;
  Map<String, int> locationCount = {};
  int highestPain = 0;
  int totalPain = 0;
  int entryCount = 0;

  bool _loading = false;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );

    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedRange ?? initialRange,
      firstDate: DateTime(2020),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedRange = picked;
        _loading = true;
      });
      await _loadData(picked);
      setState(() => _loading = false);
    }
  }

  Future<void> _loadData(DateTimeRange range) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query = await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .collection('pain_entries')
    .where('date', isGreaterThanOrEqualTo: range.start.toIso8601String())
    .where('date', isLessThan: range.end.add(const Duration(days: 1)).toIso8601String())
    .get();


    final Map<String, int> locationCounter = {};
    int maxPain = 0;
    int painSum = 0;

    for (var doc in query.docs) {
      final data = doc.data();
      final location = data['pain_location'] ?? 'nieznane';
      final intensity = (data['pain_intensity'] ?? 0) as int;

      painSum += intensity;
      maxPain = intensity > maxPain ? intensity : maxPain;
      locationCounter[location] = (locationCounter[location] ?? 0) + 1;
    }

    setState(() {
      locationCount = locationCounter;
      highestPain = maxPain;
      totalPain = painSum;
      entryCount = query.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Statystyki')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.date_range),
              label: Text(
                _selectedRange == null
                    ? 'Wybierz zakres dat'
                    : '${dateFormat.format(_selectedRange!.start)} – ${dateFormat.format(_selectedRange!.end)}',
              ),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading && _selectedRange != null)
              Expanded(
                child: ListView(
                  children: [
                    Text('Liczba wpisów: $entryCount'),
                    Text('Najwyższa intensywność bólu: $highestPain'),
                    Text('Średnia intensywność: ${entryCount > 0 ? (totalPain / entryCount).toStringAsFixed(1) : "-"}'),
                    const SizedBox(height: 12),
                    const Text('Najczęstsze lokalizacje bólu:'),
                    for (var entry in locationCount.entries)
                      Text('${entry.key}: ${entry.value}×'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
