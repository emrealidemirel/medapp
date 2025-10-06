import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/components/notification_action_button_row.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/models/pending_notification.dart';
import 'package:medicine_app/theme/app_theme.dart';

class NotificationPendingCard extends StatelessWidget {
  final PendingNotification pending;
  final Medicine medicine;
  final bool isSelected;

  const NotificationPendingCard({
    super.key,
    required this.pending,
    required this.medicine,
    required this.isSelected,
  });

  String _getPlannedTime() {
    final payloadParts = pending.payload.split(':');

    if (payloadParts.length >= 4) {
      final hour = payloadParts[payloadParts.length - 2].padLeft(2, '0');
      final minute = payloadParts[payloadParts.length - 1].padLeft(2, '0');

      return "$hour:$minute";
    }
    return 'Bilinmiyor';
  }

  String _getPlannedDate(DateTime scheduledTime) {
    final dateFormatter = DateFormat('dd.MM.yyyy', 'tr_TR');
    return dateFormatter.format(scheduledTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final plannedTime = _getPlannedTime();
    final plannedDate = _getPlannedDate(pending.scheduledTime);
    final cardTitleStyle = Theme.of(context).textTheme.cardNotificationTitle;
    final dateTimeStyle = Theme.of(context).textTheme.logItemDateTime;
    final infoTextStyle = Theme.of(context).textTheme.notificationInfoText;
    final boldDateTimeStyle = dateTimeStyle.copyWith(
      fontWeight: FontWeight.bold,
    );

    const double borderThickness = 5.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.shadowDarkOpacity20
                  : AppColors.shadowDarkOpacity05,
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: borderThickness,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w).copyWith(left: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine.name, style: cardTitleStyle),
                      SizedBox(height: 0.5.h),

                      Text.rich(
                        TextSpan(
                          text: "Planlanan Saat: $plannedTime",
                          style: boldDateTimeStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: ", $plannedDate",
                              style: dateTimeStyle,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      Text(
                        "Lütfen ilacı alıp almadığınızı seçin, seçiminiz ilaç geçmişinize kaydedilecektir.",
                        style: infoTextStyle,
                      ),

                      SizedBox(height: 1.5.h),

                      NotificationActionButtonRow(
                        pending: pending,
                        isPayloadActive: isSelected,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
