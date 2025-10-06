import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_app/services/notifications/notification_service.dart';
import 'dart:io' show Platform;

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;

  NotificationCubit(this._notificationService)
    : super(const NotificationInitial()) {
    _notificationService.onPendingNotificationsChanged = updateActiveCount;
    loadNotificationStatus();
  }

  Future<void> loadNotificationStatus() async {
    bool areNotificationsEnabled = false;
    final FlutterLocalNotificationsPlugin plugin =
        _notificationService.flutterLocalNotificationsPlugin;

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      if (androidImplementation != null) {
        final bool? result = await androidImplementation
            .areNotificationsEnabled();
        areNotificationsEnabled = result ?? false;
      }
    } else if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iosImplementation = plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosImplementation != null) {
        final bool? result = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        areNotificationsEnabled = result ?? false;
      }
    }

    final activeCount = _notificationService
        .getActivePendingNotifications()
        .length;

    emit(
      NotificationStatus(
        permissionsGranted: areNotificationsEnabled,
        activeCount: activeCount,
      ),
    );
  }

  void updateActiveCount() {
    final activeCount = _notificationService
        .getActivePendingNotifications()
        .length;

    if (state.activeCount != activeCount) {
      emit(state.copyWith(activeCount: activeCount));
    }
  }

  Future<void> requestPermissions() async {
    await _notificationService.requestAllPermissionsIfNeeded();
    await loadNotificationStatus();
  }

  @override
  Future<void> close() {
    _notificationService.onPendingNotificationsChanged = null;
    return super.close();
  }
}
