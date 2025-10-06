// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineLogAdapter extends TypeAdapter<MedicineLog> {
  @override
  final int typeId = 2;

  @override
  MedicineLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineLog(
      id: fields[0] as String,
      medicineId: fields[1] as String,
      isTaken: fields[2] as bool,
      scheduledTime: fields[3] as DateTime,
      actualTakenTime: fields[4] as DateTime?,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicineId)
      ..writeByte(2)
      ..write(obj.isTaken)
      ..writeByte(3)
      ..write(obj.scheduledTime)
      ..writeByte(4)
      ..write(obj.actualTakenTime)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
