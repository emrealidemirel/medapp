import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:medicine_app/components/notification_pending_card.dart';
import 'package:medicine_app/components/empty_notification_indicator.dart';
import 'package:medicine_app/theme/app_theme.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Medicine? _getMedicineFromPayload(List<Medicine> medicines, String payload) {
    if (payload.isEmpty) return null;
    final medicineId = payload.split(':').first;

    try {
      return medicines.firstWhere((m) => m.id == medicineId);
    } on StateError {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineCubit, MedicineState>(
      builder: (context, medState) {
        if (medState is! MedicineLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final allPending = context
            .read<MedicineCubit>()
            .getPendingNotifications();

        final navState = context.read<NavigationCubit>().state;
        final String? activePayload = navState.selectedNotificationPayload;

        PendingNotification? activePending;
        final List<PendingNotification> pendingNotifications = List.from(
          allPending,
        );

        if (activePayload != null) {
          pendingNotifications.removeWhere((p) {
            if (p.payload == activePayload) {
              activePending = p;
              return true;
            }
            return false;
          });
        }
        if (activePending != null) {
          pendingNotifications.insert(0, activePending!);
        }

        if (pendingNotifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async =>
                await context.read<MedicineCubit>().loadMedicines(),
            child: const EmptyNotificationIndicator(
              icon: Icons.notifications_off_rounded,
              title: "Bildirim Kutusu Boş",
              message:
                  "Şu anda bekleyen herhangi bir ilaç bildiriminiz bulunmamaktadır.",
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<MedicineCubit>().loadMedicines();
          },
          child: ListView(
            padding: EdgeInsets.all(4.w),
            children: [
              Text(
                "Bekleyen Bildirimler:",

                style: Theme.of(context).textTheme.headlineSmallBold,
              ),
              SizedBox(height: 1.h),

              ...pendingNotifications.map((pending) {
                final medicine = _getMedicineFromPayload(
                  medState.medicines,
                  pending.payload,
                );

                if (medicine == null) return const SizedBox.shrink();

                return NotificationPendingCard(
                  pending: pending,
                  medicine: medicine,
                  isSelected: pending.payload == activePayload,
                );
              }),
              SizedBox(height: 7.h),
            ],
          ),
        );
      },
    );
  }
}
