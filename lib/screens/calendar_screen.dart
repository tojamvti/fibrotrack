import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import '../models/pain_entry.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<PainEntry>> _entriesGroupedByDate = {};

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final box = Hive.box<PainEntry>('pain_entries');
    final entries = box.values.toList();

    final grouped = <DateTime, List<PainEntry>>{};

    for (var entry in entries) {
      final normalizedDate = _normalizeDate(entry.date);
      grouped.putIfAbsent(normalizedDate, () => []);
      grouped[normalizedDate]!.add(entry);
    }

    setState(() {
      _entriesGroupedByDate = grouped;
    });
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Color _getColorByIntensity(int intensity) {
    if (intensity <= 3) return Colors.green;
    if (intensity <= 6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pain Calendar')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) {
                    final dayEntries =
                        _entriesGroupedByDate[_normalizeDate(day)];
                    if (dayEntries != null && dayEntries.isNotEmpty) {
                      final latest = dayEntries.reduce((a, b) =>
                          a.date.isAfter(b.date) ? a : b);
                      return Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getColorByIntensity(latest.intensity),
                        ),
                        child: Center(
                          child: Text('${day.day}',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedDay != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Entries for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...?_entriesGroupedByDate[_normalizeDate(_selectedDay!)]?.map(
                  (entry) => _buildEntryDetails(entry),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntryDetails(PainEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Time: ${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}'),
              Text('Pain: ${entry.intensity}/10',
                  style: const TextStyle(fontSize: 16)),
              Text('Location: ${entry.location}'),
              Text('Type: ${entry.type}'),
              if (entry.notes.isNotEmpty) Text('Notes: ${entry.notes}'),
            ],
          ),
        ),
      ),
    );
  }
}
