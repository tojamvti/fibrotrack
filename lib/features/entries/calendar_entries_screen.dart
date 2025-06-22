import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../entries/edit_entry_screen.dart'; // Upewnij się, że masz ten import

class CalendarEntriesScreen extends StatefulWidget {
  const CalendarEntriesScreen({super.key});

  @override
  State<CalendarEntriesScreen> createState() => _CalendarEntriesScreenState();
}

class _CalendarEntriesScreenState extends State<CalendarEntriesScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<Map<String, dynamic>>> _entriesByDate = {};
  Map<String, String> _docIds = {}; // do edycji/usuwania
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
        .orderBy('date', descending: true)
        .get();

    final data = <String, List<Map<String, dynamic>>>{};
    final ids = <String, String>{};

    for (final doc in snapshot.docs) {
      final entry = doc.data();
      final docId = doc.id;
      final date = DateTime.tryParse(entry['date'] ?? '') ?? DateTime.now();
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      data.putIfAbsent(key, () => []).add({...entry, 'docId': docId});
      ids[docId] = key;
    }

    setState(() {
      _entriesByDate = data;
      _docIds = ids;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> _getEntriesForDay(DateTime day) {
    final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return _entriesByDate[key] ?? [];
  }

  Future<void> _deleteEntry(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Potwierdzenie'),
        content: const Text('Czy na pewno chcesz usunąć ten wpis?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Usuń')),
        ],
      ),
    );

    if (confirm != true) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pain_entries')
        .doc(docId)
        .delete();

    await _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _selectedDay != null ? _getEntriesForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(title: const Text('Wpisy według daty')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  calendarFormat: CalendarFormat.month,
                  eventLoader: _getEntriesForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (_selectedDay != null)
                  Expanded(
                    child: entries.isEmpty
                        ? const Center(child: Text('Brak wpisów tego dnia'))
                        : ListView.builder(
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              final docId = entry['docId'];
                              final location = entry['pain_location'] ?? '';
                              final character = entry['pain_character'] ?? '';
                              final intensity = entry['pain_intensity']?.toString() ?? '';
                              final note = entry['note'] ?? '';
                              final date = DateTime.tryParse(entry['date'] ?? '') ?? _selectedDay!;
                              final formattedDate =
                                  '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('📍 $location'),
                                      Text('🔥 Charakter: $character'),
                                      Text('📊 Intensywność: $intensity'),
                                      if (note.isNotEmpty) Text('📝 Notatka: $note'),
                                      Text('📅 Data: $formattedDate'),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            icon: const Icon(Icons.edit),
                                            label: const Text('Edytuj'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => EditEntryScreen(
                                                    docId: docId,
                                                    data: entry,
                                                  ),
                                                ),
                                              ).then((_) => _fetchEntries());
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            label: const Text('Usuń', style: TextStyle(color: Colors.red)),
                                            onPressed: () => _deleteEntry(docId),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
              ],
            ),
    );
  }
}
