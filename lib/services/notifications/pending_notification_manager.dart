import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:medicine_app/models/medicine.dart';

class PendingNotificationManager {
  final Box<PendingNotification> _pendingBox;
  VoidCallback? onPendingNotificationsChanged;

  PendingNotificationManager(this._pendingBox);

  Future<void> advancePendingNotificationTime(String payload) async {
    final parts = payload.split(':');
    final cycleString = parts[1];
    final currentRecord = _pendingBox.get(payload);
    if (currentRecord == null) return;

    tz.TZDateTime nextScheduledTime;

    int hour, minute;

    if (cycleString == RepeatCycle.daily.name) {
      hour = int.parse(parts[2]);
      minute = int.parse(parts[3]);
      nextScheduledTime = _nextInstanceOfDaily(hour, minute);
    } else if (cycleString == RepeatCycle.weekly.name) {
      final day = int.parse(parts[2]);
      hour = int.parse(parts[3]);
      minute = int.parse(parts[4]);
      nextScheduledTime = _nextInstanceOfWeekday(day, hour, minute);
    } else if (cycleString == RepeatCycle.monthly.name) {
      final day = int.parse(parts[2]);
      hour = int.parse(parts[3]);
      minute = int.parse(parts[4]);
      nextScheduledTime = _nextInstanceOfMonthDay(day, hour, minute);
    } else {
      return;
    }

    final updatedNotification = PendingNotification(
      payload: currentRecord.payload,
      scheduledTime: nextScheduledTime.toLocal(),
      notificationShownTime: DateTime.now(),
      notificationId: currentRecord.notificationId,
    );

    await _pendingBox.put(payload, updatedNotification);
    onPendingNotificationsChanged?.call();
  }

  tz.TZDateTime _nextInstanceOfDaily(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now.add(const Duration(minutes: 1)))) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    var scheduledDate = _nextInstanceOfDaily(hour, minute);
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMonthDay(int dayOfMonth, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      dayOfMonth,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now) ||
        dayOfMonth > DateTime(now.year, now.month + 1, 0).day) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month + 1,
        dayOfMonth,
        hour,
        minute,
      );
    }
    return scheduledDate;
  }

  Future<void> addPendingNotification(
    String payload,
    DateTime scheduledTime, {
    required int notificationId,
  }) async {
    final notification = PendingNotification(
      payload: payload,
      scheduledTime: scheduledTime.toLocal(),
      notificationShownTime: DateTime.now(),
      notificationId: notificationId,
    );

    await _pendingBox.put(payload, notification);
    onPendingNotificationsChanged?.call();
  }

  Future<void> removePendingNotification(String payload) async {
    await _pendingBox.delete(payload);
    onPendingNotificationsChanged?.call();
  }

  List<PendingNotification> getActivePendingNotifications() {
    final now = tz.TZDateTime.now(tz.local);

    final active = _pendingBox.values.where((pn) {
      final scheduledTZ = tz.TZDateTime.from(pn.scheduledTime, tz.local);

      final isOverdue = scheduledTZ.isBefore(now);

      final isWithin24Hours = scheduledTZ
          .add(const Duration(hours: 24))
          .isAfter(now);

      return isOverdue && isWithin24Hours;
    }).toList();

    return active;
  }
}
