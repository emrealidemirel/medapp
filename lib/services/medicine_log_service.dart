import 'package:hive/hive.dart';
import 'package:medicine_app/models/medicine_log.dart';
import 'package:uuid/uuid.dart';

class MedicineLogService {
  final Box<MedicineLog> logBox;

  MedicineLogService(this.logBox);

  Future<void> addLog({
    required String medicineId,
    required DateTime scheduledTime,
    required bool isTaken,
    DateTime? actualTakenTime,
  }) async {
    final log = MedicineLog(
      id: const Uuid().v4(),
      medicineId: medicineId,
      scheduledTime: scheduledTime,
      isTaken: isTaken,
      actualTakenTime: actualTakenTime,
      createdAt: DateTime.now(),
    );
    await logBox.put(log.id, log);
  }

  List<MedicineLog> getAllLogs() {
    return logBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> clearAllLogs() async {
    await logBox.clear();
  }

  MedicineLog? getLog(String id) {
    return logBox.get(id);
  }
}
