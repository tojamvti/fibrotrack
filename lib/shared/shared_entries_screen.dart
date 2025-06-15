import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SharedEntriesScreen extends StatelessWidget {
  const SharedEntriesScreen({super.key});

  Future<void> _deleteEntry(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Potwierdzenie'),
        content: const Text('Czy na pewno chcesz usunąć ten wpis z udostępnionych?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anuluj')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Usuń')),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('shared_entries').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wpis usunięty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Udostępnione wpisy')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shared_entries')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data?.docs ?? [];

          if (entries.isEmpty) {
            return const Center(child: Text('Brak udostępnionych wpisów.'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final doc = entries[index];
              final data = doc.data() as Map<String, dynamic>;
              final rawDate = data['date'];
              final date = rawDate is Timestamp ? rawDate.toDate() : DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('${data['pain_location'] ?? '-'} • ${data['pain_character'] ?? '-'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Intensywność: ${data['pain_intensity']}'),
                      if ((data['note'] ?? '').toString().isNotEmpty)
                        Text('Notatka: ${data['note']}'),
                      Text('Data: ${date.day}.${date.month}.${date.year}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEntry(context, doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
