import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/pain_options.dart';

class EditEntryScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditEntryScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedLocation;
  String? _selectedSubLocation;
  String? _customLocation;

  String? _selectedCharacter;
  String? _customCharacter;

  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late int _painIntensity;
  late bool _share;

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    // Obsługa sublokalizacji
    final loc = data['pain_location'] as String?;
    if (loc != null && loc.contains(' – ')) {
      final parts = loc.split(' – ');
      _selectedLocation = parts[0];
      _selectedSubLocation = parts[1];
    } else if (loc != null && painLocations.contains(loc)) {
      _selectedLocation = loc;
    } else {
      _selectedLocation = 'Inne';
      _customLocation = loc;
    }

    final character = data['pain_character'] as String?;
    if (character != null && painCharacters.contains(character)) {
      _selectedCharacter = character;
    } else {
      _selectedCharacter = 'Inne';
      _customCharacter = character;
    }

    _noteController = TextEditingController(text: data['note'] ?? '');
    _selectedDate = DateTime.tryParse(data['date'] ?? '') ?? DateTime.now();
    _painIntensity = data['pain_intensity'] ?? 5;
    _share = data['share'] ?? false;
  }

  Future<void> _updateEntry() async {
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

    final updatedData = {
      'pain_location': location,
      'pain_character': character,
      'note': _noteController.text.trim(),
      'pain_intensity': _painIntensity,
      'date': _selectedDate.toIso8601String(),
      'share': _share,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pain_entries')
        .doc(widget.docId)
        .update(updatedData);

    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteEntry() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Potwierdzenie'),
        content: const Text('Czy na pewno chcesz usunąć ten wpis?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anuluj')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Usuń')),
        ],
      ),
    );

    if (confirm == true) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('pain_entries')
            .doc(widget.docId)
            .delete();
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final sublocations = subPainLocations[_selectedLocation];

    return Scaffold(
      appBar: AppBar(title: const Text('Edytuj wpis')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: painLocations.contains(_selectedLocation) ? _selectedLocation : 'Inne',
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
                  initialValue: _customLocation,
                  decoration: const InputDecoration(labelText: 'Wpisz lokalizację'),
                  onChanged: (val) => _customLocation = val,
                  validator: (val) =>
                      (_selectedLocation == 'Inne' && (val == null || val.isEmpty))
                          ? 'Podaj własną lokalizację'
                          : null,
                ),
              if (_selectedLocation != null &&
                  _selectedLocation != 'Inne' &&
                  sublocations != null)
                DropdownButtonFormField<String>(
                  value: _selectedSubLocation,
                  decoration: const InputDecoration(labelText: 'Doprecyzuj lokalizację'),
                  items: sublocations
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSubLocation = val),
                ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: painCharacters.contains(_selectedCharacter) ? _selectedCharacter : 'Inne',
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
                  initialValue: _customCharacter,
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
                title: const Text('Udostępnij anonimowo'),
                value: _share,
                onChanged: (val) => setState(() => _share = val),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Zapisz zmiany'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateEntry();
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Usuń wpis', style: TextStyle(color: Colors.red)),
                onPressed: _deleteEntry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
