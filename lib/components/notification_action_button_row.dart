import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:medicine_app/components/app_action_button.dart';

class NotificationActionButtonRow extends StatelessWidget {
  final PendingNotification pending;
  final bool isPayloadActive;

  const NotificationActionButtonRow({
    super.key,
    required this.pending,
    required this.isPayloadActive,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MedicineCubit>();
    final navCubit = context.read<NavigationCubit>();

    void onAction(bool isTaken) {
      cubit.processNotificationAction(
        payload: pending.payload,
        isTaken: isTaken,
        scheduledTime: pending.scheduledTime,
      );
      if (isPayloadActive) {
        navCubit.clearNotificationPayload();
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppActionButton(
          text: "Aldım",
          onPressed: () => onAction(true),

          verticalPadding: 0.1.h,
          horizontalPadding: 1.4.w,
          fontSize: 15.sp,
        ),
        SizedBox(width: 2.w),
        AppActionButton(
          text: "Atladım",
          onPressed: () => onAction(false),
          backgroundColor: AppColors.danger,

          verticalPadding: 0.1.h,
          horizontalPadding: 1.4.w,
          fontSize: 15.sp,
        ),
      ],
    );
  }
}
