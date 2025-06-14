import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/pain_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  double _intensity = 5.0;
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'Aching';
  DateTime _selectedDate = DateTime.now();

  final List<String> _painTypes = ['Aching', 'Burning', 'Stabbing', 'Throbbing', 'Sharp'];

  void _saveEntry() async {
    final entry = PainEntry(
      date: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
      ),
      intensity: _intensity.round(),
      location: _locationController.text.trim(),
      type: _selectedType,
      notes: _notesController.text.trim(),
    );

    final box = Hive.box<PainEntry>('pain_entries');
    await box.add(entry);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nowy wpis bólu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Intensywność bólu:'),
            Slider(
              value: _intensity,
              min: 0,
              max: 10,
              divisions: 10,
              label: _intensity.round().toString(),
              onChanged: (value) => setState(() => _intensity = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokalizacja bólu'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _painTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
              decoration: const InputDecoration(labelText: 'Typ bólu'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notatki (opcjonalnie)'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Data wpisu: '),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveEntry,
              icon: const Icon(Icons.save),
              label: const Text('Zapisz wpis'),
            )
          ],
        ),
      ),
    );
  }
}
