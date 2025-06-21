import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/pain_options.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedLocation;
  String? _selectedSubLocation;
  String? _customLocation;

  String? _selectedCharacter;
  String? _customCharacter;

  final TextEditingController _noteController = TextEditingController();

  int _painIntensity = 5;
  DateTime _selectedDate = DateTime.now();
  bool _share = false;

  Future<void> _saveEntry() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  String? location;
  if (_selectedLocation == 'Inne') {
    location = _customLocation?.trim();
  } else if (_selectedSubLocation != null) {
    location = '$_selectedLocation – $_selectedSubLocation';
  } else {
    location = _selectedLocation;
  }

  final character = _selectedCharacter == 'Inne'
      ? _customCharacter?.trim()
      : _selectedCharacter;

  final entryData = {
    'date': _selectedDate.toIso8601String(),
    'pain_location': location,
    'pain_intensity': _painIntensity,
    'pain_character': character,
    'note': _noteController.text.trim(),
    'share': _share,
    'created_at': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('pain_entries')
      .add(entryData);

  if (_share) {
    final sharedData = Map.of(entryData)..remove('share');
    await FirebaseFirestore.instance
        .collection('shared_entries')
        .add(sharedData);
  }

  if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 12),
          Text('Zapisano!'),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );

  await Future.delayed(const Duration(seconds: 2));
  Navigator.pop(context);
}
  }



  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final sublocations = subPainLocations[_selectedLocation];

    return Scaffold(
      appBar: AppBar(title: const Text('Nowy wpis')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Lokalizacja bólu
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(labelText: 'Gdzie boli'),
                items: painLocations
                    .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList()
                  ..add(const DropdownMenuItem(value: 'Inne', child: Text('Inne'))),
                onChanged: (val) => setState(() {
                  _selectedLocation = val;
                  _selectedSubLocation = null;
                  _customLocation = null;
                }),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Wybierz lokalizację' : null,
              ),
              if (_selectedLocation == 'Inne')
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Wpisz lokalizację'),
                  onChanged: (val) => _customLocation = val,
                  validator: (val) =>
                      (_selectedLocation == 'Inne' && (val == null || val.isEmpty))
                          ? 'Podaj lokalizację'
                          : null,
                ),
              if (_selectedLocation != null &&
                  _selectedLocation != 'Inne' &&
                  sublocations != null)
                DropdownButtonFormField<String>(
                  value: _selectedSubLocation,
                  decoration: const InputDecoration(labelText: 'Doprecyzuj lokalizację'),
                  items: sublocations
                      .map((sub) =>
                          DropdownMenuItem(value: sub, child: Text(sub)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSubLocation = val),
                ),
              const SizedBox(height: 16),

              // Charakter bólu
              DropdownButtonFormField<String>(
                value: _selectedCharacter,
                decoration: const InputDecoration(labelText: 'Charakter bólu'),
                items: painCharacters
                    .map((ch) => DropdownMenuItem(value: ch, child: Text(ch)))
                    .toList()
                  ..add(const DropdownMenuItem(value: 'Inne', child: Text('Inne'))),
                onChanged: (val) => setState(() {
                  _selectedCharacter = val;
                  _customCharacter = null;
                }),
              ),
              if (_selectedCharacter == 'Inne')
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Wpisz charakter'),
                  onChanged: (val) => _customCharacter = val,
                ),
              const SizedBox(height: 24),

              Text('Skala bólu: $_painIntensity', style: textStyle),
              Slider(
                value: _painIntensity.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: _painIntensity.toString(),
                onChanged: (value) => setState(() => _painIntensity = value.toInt()),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Notatka'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data'),
                subtitle: Text(
                  '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                value: _share,
                onChanged: (val) => setState(() => _share = val),
                title: const Text('Udostępnij anonimowo'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Zapisz wpis'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveEntry();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
