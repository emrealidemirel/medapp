// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      id: fields[0] as String,
      name: fields[1] as String,
      note: fields[2] as String?,
      intakeDays: (fields[3] as List).cast<int>(),
      intakeTimes: (fields[4] as List).cast<String>(),
      repeatCycle: fields[5] as RepeatCycle,
      createdAt: fields[6] as DateTime,
      remainingCount: fields[7] as int?,
      isActive: fields[8] as bool?,
      isUnlimited: fields[9] as bool?,
      totalCount: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.intakeDays)
      ..writeByte(4)
      ..write(obj.intakeTimes)
      ..writeByte(5)
      ..write(obj.repeatCycle)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.remainingCount)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.isUnlimited)
      ..writeByte(10)
      ..write(obj.totalCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatCycleAdapter extends TypeAdapter<RepeatCycle> {
  @override
  final int typeId = 1;

  @override
  RepeatCycle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatCycle.daily;
      case 1:
        return RepeatCycle.weekly;
      case 2:
        return RepeatCycle.monthly;
      default:
        return RepeatCycle.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatCycle obj) {
    switch (obj) {
      case RepeatCycle.daily:
        writer.writeByte(0);
        break;
      case RepeatCycle.weekly:
        writer.writeByte(1);
        break;
      case RepeatCycle.monthly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatCycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
