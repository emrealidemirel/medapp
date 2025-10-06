import 'package:hive/hive.dart';
part 'pending_notification.g.dart';

@HiveType(typeId: 3)
class PendingNotification extends HiveObject {
  @HiveField(0)
  final String payload;

  @HiveField(1)
  final DateTime scheduledTime;

  @HiveField(2)
  final DateTime notificationShownTime;

  @HiveField(3)
  final int notificationId;

  PendingNotification({
    required this.payload,
    required this.scheduledTime,
    required this.notificationShownTime,
    required this.notificationId,
  });
}
