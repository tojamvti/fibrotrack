import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'edit_entry_screen.dart';

class CalendarEntriesScreen extends StatefulWidget {
  const CalendarEntriesScreen({super.key});

  @override
  State<CalendarEntriesScreen> createState() => _CalendarEntriesScreenState();
}

class _CalendarEntriesScreenState extends State<CalendarEntriesScreen> {
  final Map<DateTime, List<Map<String, dynamic>>> _entriesByDay = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pain_entries')
        .get();

    final entriesByDay = <DateTime, List<Map<String, dynamic>>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      data['doc_id'] = doc.id;
      final dateStr = data['date'];
      final parsedDate = DateTime.tryParse(dateStr ?? '');
      if (parsedDate == null) continue;

      final day = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

      entriesByDay.putIfAbsent(day, () => []);
      entriesByDay[day]!.add(data);
    }

    setState(() {
      _entriesByDay.clear(); // ✅ zamiast przypisania do late final
      _entriesByDay.addAll(entriesByDay);
      _loading = false;
    });
  }

  List<Map<String, dynamic>> _getEntriesForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _entriesByDay[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalendarz wpisów')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime.now(),
                  selectedDayPredicate: (day) =>
                      _selectedDay != null && isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: _getEntriesForDay,
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _selectedDay == null
                      ? const Center(child: Text('Wybierz dzień'))
                      : ListView(
                          children:
                              _getEntriesForDay(_selectedDay!).map((entry) {
                            final location = entry['pain_location'] ?? '–';
                            final character = entry['pain_character'] ?? '';
                            final intensity = entry['pain_intensity'] ?? '-';
                            final note = entry['note'] ?? '';
                            final docId = entry['doc_id'];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text('$location – $character'),
                                subtitle:
                                    Text('Intensywność: $intensity\n$note'),
                                onTap: () {
                                  if (docId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditEntryScreen(
                                          docId: docId,
                                          data: entry,
                                        ),
                                      ),
                                    ).then((_) {
                                      _fetchEntries(); // odśwież po edycji
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
    );
  }
}
