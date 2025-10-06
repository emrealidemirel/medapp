import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/services/medicine_log_service.dart';
import 'package:medicine_app/services/notifications/notification_service.dart';
import 'package:uuid/uuid.dart';
import 'package:medicine_app/models/medicine_log.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final Box<Medicine> medicineBox;
  final MedicineLogService logService;
  final NotificationService notificationService;

  static const List<int> allDays = [1, 2, 3, 4, 5, 6, 7];

  MedicineCubit({
    required this.medicineBox,
    required this.logService,
    required this.notificationService,
  }) : super(MedicineInitial()) {
    loadMedicines();
  }

  Future<void> loadMedicines({AppTab? targetTab}) async {
    final medicines = medicineBox.values.toList();
    final allLogs = logService.getAllLogs();

    int newVersion = 1;
    if (state is MedicineLoaded) {
      newVersion = (state as MedicineLoaded).version + 1;
    }

    emit(
      MedicineLoaded(
        medicines,
        allLogs,
        targetTab: targetTab,
        version: newVersion,
      ),
    );
  }

  void showForm({Medicine? medicine}) {
    if (state is MedicineFormState) return;

    List<DateTime> intakeDatesFromDays = [];
    if (medicine?.repeatCycle == RepeatCycle.monthly &&
        medicine?.intakeDays != null) {
      final now = DateTime.now();
      intakeDatesFromDays = medicine!.intakeDays
          .map((d) => DateTime(now.year, now.month, d))
          .toList();
    }

    List<int> initialIntakeDays = medicine?.intakeDays ?? [];
    if (medicine?.repeatCycle == RepeatCycle.daily &&
        initialIntakeDays.isEmpty) {
      initialIntakeDays = allDays;
    }

    emit(
      MedicineFormState(
        medicineToEdit: medicine,
        name: medicine?.name ?? '',
        note: medicine?.note ?? '',
        remainingCount: medicine?.remainingCount,
        repeatCycle: medicine?.repeatCycle ?? RepeatCycle.daily,
        intakeDays: initialIntakeDays,
        intakeDates: intakeDatesFromDays,
        intakeTimes: medicine?.intakeTimes ?? [],
        isUnlimited: medicine?.isUnlimited ?? false,
      ),
    );
  }

  void resetForm({AppTab? targetTab}) {
    loadMedicines(targetTab: targetTab);
  }

  void updateForm({
    String? name,
    String? note,
    int? remainingCount,
    RepeatCycle? repeatCycle,
    List<int>? intakeDays,
    List<DateTime>? intakeDates,
    List<String>? intakeTimes,
    bool? isUnlimited,
  }) {
    if (state is MedicineFormState) {
      final currentState = state as MedicineFormState;

      if (isUnlimited != null && isUnlimited) {
        remainingCount = null;
      } else if (isUnlimited != null &&
          !isUnlimited &&
          remainingCount == null) {
        remainingCount = currentState.remainingCount;
      }

      if (repeatCycle != null && repeatCycle != currentState.repeatCycle) {
        intakeDays = repeatCycle == RepeatCycle.daily ? allDays : [];
        intakeDates = [];
      }

      emit(
        currentState.copyWith(
          name: name,
          note: note,
          remainingCount: remainingCount,
          repeatCycle: repeatCycle,
          intakeDays: intakeDays,
          intakeDates: intakeDates,
          intakeTimes: intakeTimes,
          isUnlimited: isUnlimited,
        ),
      );
    }
  }

  Future<void> saveMedicine() async {
    final formState = state as MedicineFormState;

    final List<int> intakeDaysToSave;
    if (formState.repeatCycle == RepeatCycle.daily) {
      intakeDaysToSave = allDays;
    } else if (formState.repeatCycle == RepeatCycle.weekly) {
      intakeDaysToSave = formState.intakeDays;
    } else {
      intakeDaysToSave = formState.intakeDates.map((e) => e.day).toList();
    }

    final int? newTotalCount;
    if (formState.medicineToEdit != null &&
        formState.medicineToEdit!.totalCount != null) {
      newTotalCount = formState.medicineToEdit!.totalCount;
    } else {
      newTotalCount = formState.isUnlimited ? null : formState.remainingCount;
    }

    final id = formState.medicineToEdit?.id ?? const Uuid().v4();
    final medicine = Medicine(
      id: id,
      name: formState.name,
      note: formState.note,
      intakeDays: intakeDaysToSave,
      intakeTimes: formState.intakeTimes,
      repeatCycle: formState.repeatCycle,
      createdAt: formState.medicineToEdit?.createdAt ?? DateTime.now(),
      remainingCount: formState.isUnlimited ? null : formState.remainingCount,
      isUnlimited: formState.isUnlimited,
      totalCount: newTotalCount,
      isActive: formState.isUnlimited || (formState.remainingCount ?? 0) > 0,
    );

    if (formState.medicineToEdit != null) {
      await updateMedicine(medicine);
    } else {
      await addMedicine(medicine);
    }
    loadMedicines();
  }

  Future<void> addMedicine(Medicine medicine) async {
    await medicineBox.put(medicine.id, medicine);
    await _scheduleNotifications(medicine);
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await notificationService.cancelNotificationsForMedicine(medicine.id);
    await medicineBox.put(medicine.id, medicine);
    await _scheduleNotifications(medicine);
  }

  Future<void> _scheduleNotifications(Medicine medicine) async {
    try {
      await notificationService.scheduleMedicineNotifications(medicine);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Bildirim planlanırken bir hata oluştu: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteMedicine(String id) async {
    await medicineBox.delete(id);
    await notificationService.cancelNotificationsForMedicine(id);
    loadMedicines();
  }

  Future<void> _createLogAndRemovePending({
    required String payload,
    required bool isTaken,
    required DateTime scheduledTime,
  }) async {
    final parts = payload.split(':');
    final medicineId = parts[0];

    await logService.addLog(
      medicineId: medicineId,
      scheduledTime: scheduledTime,
      isTaken: isTaken,
      actualTakenTime: isTaken ? DateTime.now() : null,
    );

    bool isLimitReached = false;

    if (isTaken) {
      final medicine = medicineBox.get(medicineId);

      if (medicine != null && !(medicine.isUnlimited ?? false)) {
        if ((medicine.remainingCount ?? 0) <= 0) return;

        medicine.remainingCount = (medicine.remainingCount ?? 0) - 1;

        if (medicine.remainingCount == 0) {
          medicine.isActive = false;
          isLimitReached = true;

          await notificationService.cancelNotificationsForMedicine(medicine.id);
        }
        await medicine.save();
      }
    }

    if (!isLimitReached) {
      await notificationService.advancePendingNotificationTime(payload);
    }
  }

  Future<void> processNotificationAction({
    required String payload,
    required bool isTaken,
    required DateTime scheduledTime,
  }) async {
    await _createLogAndRemovePending(
      payload: payload,
      isTaken: isTaken,
      scheduledTime: scheduledTime,
    );
    await loadMedicines();
  }

  List<PendingNotification> getPendingNotifications() {
    processExpiredNotifications();

    final now = DateTime.now();

    final activeNotifications = notificationService
        .getActivePendingNotifications();

    return activeNotifications
        .where((p) => p.scheduledTime.isBefore(now))
        .toList();
  }

  void processExpiredNotifications() {
    final allPending = notificationService.getActivePendingNotifications();
    final now = DateTime.now();

    final expired = allPending
        .where(
          (p) => p.notificationShownTime
              .add(const Duration(hours: 24))
              .isBefore(now),
        )
        .toList();

    for (var notif in expired) {
      _createLogAndRemovePending(
        payload: notif.payload,
        isTaken: false,
        scheduledTime: notif.scheduledTime,
      );

      notificationService.removePendingNotification(notif.payload);
    }
  }

  Future<void> updateLogStatus(String logId, bool isTaken) async {
    final log = logService.getLog(logId);
    if (log == null) return;

    final medicine = medicineBox.get(log.medicineId);

    if (medicine != null && !(medicine.isUnlimited ?? false)) {
      final bool wasInactiveAndZero =
          (medicine.remainingCount ?? 0) == 0 && !(medicine.isActive ?? false);

      if (isTaken && !log.isTaken) {
        medicine.remainingCount = (medicine.remainingCount ?? 0) - 1;
      } else if (!isTaken && log.isTaken) {
        medicine.remainingCount = (medicine.remainingCount ?? 0) + 1;
      }

      if ((medicine.remainingCount ?? 0) > 0) {
        medicine.isActive = true;
      } else if ((medicine.remainingCount ?? 0) == 0) {
        medicine.isActive = false;
      }

      if (wasInactiveAndZero && (medicine.isActive ?? false)) {
        await _scheduleNotifications(medicine);
      }

      await medicine.save();
    }

    log.isTaken = isTaken;
    if (isTaken) {
      log.actualTakenTime = DateTime.now();
    } else {
      log.actualTakenTime = null;
    }
    await log.save();

    await loadMedicines();
  }

  Future<void> clearLogs() async {
    await logService.clearAllLogs();
    loadMedicines();
  }
}
