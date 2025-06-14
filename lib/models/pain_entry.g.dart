// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pain_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PainEntryAdapter extends TypeAdapter<PainEntry> {
  @override
  final int typeId = 0;

  @override
  PainEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PainEntry(
      date: fields[0] as DateTime,
      intensity: fields[1] as int,
      location: fields[2] as String,
      type: fields[3] as String,
      notes: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PainEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.intensity)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PainEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
