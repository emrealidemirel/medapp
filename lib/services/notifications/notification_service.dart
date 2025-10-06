import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show Platform;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medicine_app/services/notifications/notification_scheduler.dart';
import 'package:medicine_app/services/notifications/pending_notification_manager.dart';
import 'package:medicine_app/models/medicine.dart';

@pragma('vm:entry-point')
void backgroundTapHandler(NotificationResponse response) async {}

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late PendingNotificationManager pendingManager;
  late NotificationScheduler scheduler;

  Function(String? payload)? onNotificationTapped;

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  VoidCallback? get onPendingNotificationsChanged =>
      pendingManager.onPendingNotificationsChanged;
  set onPendingNotificationsChanged(VoidCallback? callback) {
    pendingManager.onPendingNotificationsChanged = callback;
  }

  Future<void> initNotifications(Box<PendingNotification> pendingBox) async {
    pendingManager = PendingNotificationManager(pendingBox);
    scheduler = NotificationScheduler(
      _flutterLocalNotificationsPlugin,
      pendingManager,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: backgroundTapHandler,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    if (response.payload != null && onNotificationTapped != null) {
      onNotificationTapped!(response.payload);
    }
  }

  Future<void> removePendingNotification(String payload) async {
    return pendingManager.removePendingNotification(payload);
  }

  List<PendingNotification> getActivePendingNotifications() {
    return pendingManager.getActivePendingNotifications();
  }

  Future<void> scheduleMedicineNotifications(Medicine medicine) async {
    return scheduler.scheduleMedicineNotifications(medicine);
  }

  Future<void> cancelNotificationsForMedicine(String medicineId) async {
    return scheduler.cancelNotificationsForMedicine(medicineId);
  }

  Future<void> requestAllPermissionsIfNeeded() async {
    if (Platform.isAndroid) {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } else if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    await Permission.scheduleExactAlarm.request();
  }

  Future<void> advancePendingNotificationTime(String payload) async {
    return pendingManager.advancePendingNotificationTime(payload);
  }
}
