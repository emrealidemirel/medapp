import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:medicine_app/services/notifications/pending_notification_manager.dart';

int _getDeterministicId(String payload) {
  return payload.hashCode.abs();
}

class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final PendingNotificationManager _pendingManager;

  NotificationScheduler(
    this._flutterLocalNotificationsPlugin,
    this._pendingManager,
  );

  Future<void> scheduleMedicineNotifications(Medicine medicine) async {
    await cancelNotificationsForMedicine(medicine.id);

    const title = 'İlaç Hatırlatıcısı';
    final body = '${medicine.name} ilacını alma zamanı!';

    const androidDetails = AndroidNotificationDetails(
      'medication_channel_id',
      'İlaç Hatırlatma',
      channelDescription: 'İlaç hatırlatma bildirimleri',
      importance: Importance.max,
      priority: Priority.high,

      sound: RawResourceAndroidNotificationSound('alarm_sound'),

      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'alarm_sound.mp3',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    for (var timeString in medicine.intakeTimes) {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      tz.TZDateTime scheduledTime;
      String payload;
      int notificationId;

      if (medicine.repeatCycle == RepeatCycle.daily) {
        payload = '${medicine.id}:${medicine.repeatCycle.name}:$hour:$minute';
        notificationId = _getDeterministicId(payload);

        scheduledTime = _nextInstanceOfDaily(hour, minute);

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: payload,
        );
        await _pendingManager.addPendingNotification(
          payload,
          scheduledTime,
          notificationId: notificationId,
        );
      } else if (medicine.repeatCycle == RepeatCycle.weekly) {
        for (var day in medicine.intakeDays) {
          payload =
              '${medicine.id}:${medicine.repeatCycle.name}:$day:$hour:$minute';
          notificationId = _getDeterministicId(payload);

          scheduledTime = _nextInstanceOfWeekday(day, hour, minute);

          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            title,
            body,
            scheduledTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            payload: payload,
          );
          await _pendingManager.addPendingNotification(
            payload,
            scheduledTime,
            notificationId: notificationId,
          );
        }
      } else if (medicine.repeatCycle == RepeatCycle.monthly) {
        for (var day in medicine.intakeDays) {
          payload =
              '${medicine.id}:${medicine.repeatCycle.name}:$day:$hour:$minute';
          notificationId = _getDeterministicId(payload);

          scheduledTime = _nextInstanceOfMonthDay(day, hour, minute);

          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            title,
            body,
            scheduledTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
            payload: payload,
          );
          await _pendingManager.addPendingNotification(
            payload,
            scheduledTime,
            notificationId: notificationId,
          );
        }
      }
    }
  }

  Future<void> cancelNotificationsForMedicine(String medicineId) async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var notification in pendingNotifications) {
      if (notification.payload?.contains(medicineId) ?? false) {
        await _flutterLocalNotificationsPlugin.cancel(notification.id);
        if (notification.payload != null) {
          await _pendingManager.removePendingNotification(
            notification.payload!,
          );
        }
      }
    }
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

    if (scheduledDate.isBefore(now)) {
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
}
