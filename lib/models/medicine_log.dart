import 'package:hive/hive.dart';
part 'medicine_log.g.dart';

@HiveType(typeId: 2)
class MedicineLog extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String medicineId;

  @HiveField(2)
  late bool isTaken;

  @HiveField(3)
  late DateTime scheduledTime;

  @HiveField(4)
  late DateTime? actualTakenTime;

  @HiveField(5)
  late DateTime createdAt;

  MedicineLog({
    required this.id,
    required this.medicineId,
    required this.isTaken,
    required this.scheduledTime,
    this.actualTakenTime,
    required this.createdAt,
  });
}
