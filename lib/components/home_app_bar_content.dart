import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/notification/notification_cubit.dart';
import 'package:medicine_app/theme/app_theme.dart';

class HomeAppBarContent extends StatelessWidget {
  final String appLogoPath;

  const HomeAppBarContent({super.key, required this.appLogoPath});

  @override
  Widget build(BuildContext context) {
    final navState = context.watch<NavigationCubit>().state;
    final isNotificationPage = navState.currentTab == AppTab.notifications;

    final notificationTitleStyle = Theme.of(
      context,
    ).textTheme.headlineSmallBold;

    if (isNotificationPage) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text("Bildirimler", style: notificationTitleStyle),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(appLogoPath, height: 38, width: 38),
        ),

        Text('MedApp', style: Theme.of(context).appBarTheme.titleTextStyle),
      ],
    );
  }
}

class AppNotificationAction extends StatelessWidget {
  const AppNotificationAction({super.key});

  @override
  Widget build(BuildContext context) {
    final navCubit = context.read<NavigationCubit>();
    final medicineCubit = context.read<MedicineCubit>();

    final badgeTextStyle = Theme.of(context).textTheme.notificationBadge;

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final notificationCount = state.activeCount;

        return Padding(
          padding: EdgeInsets.only(right: 3.w),
          child: Center(
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 30),
                  onPressed: () {
                    if (medicineCubit.state is MedicineFormState) {
                      medicineCubit.resetForm();
                    }
                    navCubit.navigateToNotifications(payload: null);
                  },
                ),

                if (notificationCount > 0)
                  Positioned(
                    right: 2,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        notificationCount > 99
                            ? '99+'
                            : notificationCount.toString(),
                        style: badgeTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
