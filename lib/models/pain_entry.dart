import 'package:hive/hive.dart';

part 'pain_entry.g.dart'; // needed for code generation

@HiveType(typeId: 0)
class PainEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int intensity; // 0–10 scale

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String type; // e.g. burning, stabbing, etc.

  @HiveField(4)
  final String notes;

  PainEntry({
    required this.date,
    required this.intensity,
    required this.location,
    required this.type,
    required this.notes,
  });
}
