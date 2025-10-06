import 'package:bloc/bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
    : super(
        const NavigationState(
          currentTab: AppTab.list,
          lastPageViewTab: AppTab.list,
        ),
      );

  void selectTab(int index) {
    final newTab = AppTab.values[index];

    if (state.currentTab == AppTab.notifications &&
        newTab != AppTab.notifications) {
      emit(
        state.copyWith(currentTab: newTab, selectedNotificationPayload: null),
      );
    } else {
      final AppTab? lastTab =
          (newTab == AppTab.list ||
              newTab == AppTab.history ||
              newTab == AppTab.add)
          ? newTab
          : state.lastPageViewTab;

      emit(state.copyWith(currentTab: newTab, lastPageViewTab: lastTab));
    }
  }

  void navigateToList() {
    emit(
      state.copyWith(
        currentTab: AppTab.list,
        selectedNotificationPayload: null,
        lastPageViewTab: AppTab.list,
      ),
    );
  }

  void navigateToAdd() {
    emit(state.copyWith(currentTab: AppTab.add, lastPageViewTab: AppTab.add));
  }

  void navigateToNotifications({String? payload}) {
    final AppTab lastTab =
        (state.currentTab == AppTab.list ||
            state.currentTab == AppTab.history ||
            state.currentTab == AppTab.add)
        ? state.currentTab
        : state.lastPageViewTab ?? AppTab.list;

    emit(
      state.copyWith(
        currentTab: AppTab.notifications,
        selectedNotificationPayload: payload,
        lastPageViewTab: lastTab,
      ),
    );
  }

  void clearNotificationPayload() {
    emit(
      state.copyWith(
        currentTab: AppTab.list,
        selectedNotificationPayload: null,
        lastPageViewTab: AppTab.list,
      ),
    );
  }
}
