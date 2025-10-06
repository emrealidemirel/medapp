import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/models/medicine_log.dart';
import 'package:medicine_app/theme/app_theme.dart';

class HistoryLogItem extends StatelessWidget {
  final MedicineLog log;
  final String medicineName;
  final void Function(MedicineLog, String) onUpdateLogTap;

  const HistoryLogItem({
    super.key,
    required this.log,
    required this.medicineName,
    required this.onUpdateLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final logDate = log.isTaken ? log.actualTakenTime! : log.createdAt;

    final formattedTime = DateFormat('HH:mm').format(logDate);
    final formattedDate = DateFormat('dd.MM.yyyy').format(logDate);

    final bool isTaken = log.isTaken;
    final Color statusColor = isTaken ? AppColors.primary : AppColors.danger;
    final IconData statusIcon = isTaken
        ? Icons.check_circle
        : Icons.do_not_disturb_alt;
    final String statusText = isTaken ? "Alındı" : "Atlandı";

    final titleStyle = Theme.of(context).textTheme.logItemTitle;
    final dateTimeStyle = Theme.of(context).textTheme.logItemDateTime;

    final statusBaseStyle = Theme.of(context).textTheme.bodyMediumSemiBold;

    return ListTile(
      tileColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),

      leading: Icon(statusIcon, color: statusColor, size: 24.sp),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicineName,

            style: titleStyle,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),

          Row(
            children: [
              Text(
                statusText,

                style: statusBaseStyle.copyWith(color: statusColor),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: Text(
                  "•",

                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: AppColors.textGrey),
                ),
              ),
              Text('$formattedDate, $formattedTime', style: dateTimeStyle),
            ],
          ),
        ],
      ),

      trailing: IconButton(
        icon: Icon(Icons.edit_outlined, size: 22.sp),
        color: AppColors.primary,
        onPressed: () => onUpdateLogTap(log, medicineName),
      ),
    );
  }
}
