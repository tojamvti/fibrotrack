import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fibrotrack_app/features/utils/pdf_generator.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  DateTimeRange? _selectedRange;
  Map<String, int> locationCount = {};
  Map<String, int> characterCount = {};
  int highestPain = 0;
  int totalPain = 0;
  int entryCount = 0;
  bool _loading = false;

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
    final Map<String, int> characterCounter = {};
    int maxPain = 0;
    int painSum = 0;

    for (var doc in query.docs) {
      final data = doc.data();
      final location = data['pain_location'] ?? 'nieznane';
      final character = data['pain_character'] ?? 'nieznany';
      final intensity = (data['pain_intensity'] ?? 0) as int;

      painSum += intensity;
      maxPain = intensity > maxPain ? intensity : maxPain;
      locationCounter[location] = (locationCounter[location] ?? 0) + 1;
      characterCounter[character] = (characterCounter[character] ?? 0) + 1;
    }

    setState(() {
      locationCount = locationCounter;
      characterCount = characterCounter;
      highestPain = maxPain;
      totalPain = painSum;
      entryCount = query.docs.length;
    });
  }

  void _selectQuickRange(Duration duration) {
    final now = DateTime.now();
    final range = DateTimeRange(start: now.subtract(duration), end: now);
    setState(() {
      _selectedRange = range;
      _loading = true;
    });
    _loadData(range).then((_) => setState(() => _loading = false));
  }

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

  Future<void> _exportToPdf() async {
    if (_selectedRange == null) return;

    final file = await generatePainStatsPdf(
      startDate: _selectedRange!.start,
      endDate: _selectedRange!.end,
      entryCount: entryCount,
      highestPain: highestPain,
      averagePain: entryCount > 0 ? (totalPain / entryCount).toStringAsFixed(1) : "-",
      locationCount: locationCount,
      characterCount: characterCount,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('📄 Wygenerowano PDF: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statystyki'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {},
            tooltip: 'Eksportuj do PDF',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () => _selectQuickRange(const Duration(days: 1)), child: const Text('Ostatni dzień')),
                ElevatedButton(onPressed: () => _selectQuickRange(const Duration(days: 7)), child: const Text('Ostatni tydzień')),
                ElevatedButton(onPressed: () => _selectQuickRange(const Duration(days: 30)), child: const Text('Ostatni miesiąc')),
                ElevatedButton.icon(
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _selectedRange == null
                        ? 'Zakres dat'
                        : '${dateFormat.format(_selectedRange!.start)} – ${dateFormat.format(_selectedRange!.end)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_selectedRange != null)
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('📊 Statystyki ogólne'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Liczba wpisów: $entryCount'),
                            Text('Najwyższa intensywność: $highestPain'),
                            Text('Średnia intensywność: ${entryCount > 0 ? (totalPain / entryCount).toStringAsFixed(1) : "-"}'),
                          ],
                        ),
                      ),
                    ),
                    if (locationCount.isNotEmpty)
                      Card(
                        child: ListTile(
                          title: const Text('📍 Najczęstsze lokalizacje bólu'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: locationCount.entries
                                .map((e) => Text('${e.key}: ${e.value}×'))
                                .toList(),
                          ),
                        ),
                      ),
                    if (characterCount.isNotEmpty)
                      Card(
                        child: ListTile(
                          title: const Text('🔥 Najczęstszy charakter bólu'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: characterCount.entries
                                .map((e) => Text('${e.key}: ${e.value}×'))
                                .toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
