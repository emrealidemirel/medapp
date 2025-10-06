part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  final bool permissionsGranted;

  final int activeCount;

  const NotificationState({
    this.permissionsGranted = false,
    this.activeCount = 0,
  });

  @override
  List<Object> get props => [permissionsGranted, activeCount];

  NotificationState copyWith({bool? permissionsGranted, int? activeCount});
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();

  @override
  NotificationInitial copyWith({bool? permissionsGranted, int? activeCount}) {
    return const NotificationInitial();
  }
}

class NotificationStatus extends NotificationState {
  const NotificationStatus({
    required super.permissionsGranted,
    super.activeCount = 0,
  });

  @override
  NotificationStatus copyWith({bool? permissionsGranted, int? activeCount}) {
    return NotificationStatus(
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      activeCount: activeCount ?? this.activeCount,
    );
  }
}
