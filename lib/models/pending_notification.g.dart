// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingNotificationAdapter extends TypeAdapter<PendingNotification> {
  @override
  final int typeId = 3;

  @override
  PendingNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingNotification(
      payload: fields[0] as String,
      scheduledTime: fields[1] as DateTime,
      notificationShownTime: fields[2] as DateTime,
      notificationId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PendingNotification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.payload)
      ..writeByte(1)
      ..write(obj.scheduledTime)
      ..writeByte(2)
      ..write(obj.notificationShownTime)
      ..writeByte(3)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
