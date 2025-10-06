import 'package:equatable/equatable.dart';

enum AppTab { history, list, add, notifications }

class NavigationState extends Equatable {
  final AppTab currentTab;
  final String? selectedNotificationPayload;
  final AppTab? lastPageViewTab;

  const NavigationState({
    this.currentTab = AppTab.list,
    this.selectedNotificationPayload,
    this.lastPageViewTab = AppTab.list,
  });

  @override
  List<Object?> get props => [
    currentTab,
    selectedNotificationPayload,
    lastPageViewTab,
  ];

  NavigationState copyWith({
    AppTab? currentTab,
    String? selectedNotificationPayload,
    AppTab? lastPageViewTab,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      selectedNotificationPayload: selectedNotificationPayload,
      lastPageViewTab: lastPageViewTab ?? this.lastPageViewTab,
    );
  }
}
