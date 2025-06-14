import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/pain_entry.dart';
import 'add_entry_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<PainEntry> painBox = Hive.box<PainEntry>('pain_entries');

    return Scaffold(
      appBar: AppBar(
        title: const Text('FibroTrack'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: painBox.listenable(),
        builder: (context, Box<PainEntry> box, _) {
          final entries = box.values.toList().cast<PainEntry>();
          entries.sort((a, b) => b.date.compareTo(a.date)); // latest first

          if (entries.isEmpty) {
            return const Center(child: Text('No entries yet'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text('Pain: ${entry.intensity}/10'),
                subtitle: Text(
                  '${entry.location} | ${entry.type}\n${entry.notes}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${entry.date.day}/${entry.date.month}',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  // Could implement edit view in future
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
