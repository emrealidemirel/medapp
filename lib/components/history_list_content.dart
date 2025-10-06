import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/components/medicine_card.dart';
import 'package:medicine_app/components/history_log_item.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/models/medicine_log.dart';
import 'package:medicine_app/theme/app_theme.dart';

class HistoryListContent extends StatelessWidget {
  final List<Medicine> medicinesWithLogs;
  final Set<String> completedMedicinesIds;
  final List<MedicineLog> allLogs;
  final void Function() onClearHistoryTap;
  final void Function(MedicineLog, String) onUpdateLogTap;

  const HistoryListContent({
    super.key,
    required this.medicinesWithLogs,
    required this.completedMedicinesIds,
    required this.allLogs,
    required this.onClearHistoryTap,
    required this.onUpdateLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final listHeaderStyle = Theme.of(context).textTheme.listHeaderTitle;
    final cardTagStyle = Theme.of(context).textTheme.cardTagWhiteItalic;

    final cardTitleStyle = Theme.of(context).textTheme.cardTitlePrimary;

    final smallWhiteTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.normal,
    );

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await context.read<MedicineCubit>().loadMedicines();
      },
      child: ListView.builder(
        itemCount: medicinesWithLogs.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("İlaç Geçmişi", style: listHeaderStyle),
                  IconButton(
                    icon: Icon(Icons.delete_sweep, color: AppColors.danger),
                    onPressed: onClearHistoryTap,
                  ),
                ],
              ),
            );
          }

          final medicine = medicinesWithLogs[index - 1];
          final medicineLogs = allLogs
              .where((log) => log.medicineId == medicine.id)
              .toList();
          final isCompleted = completedMedicinesIds.contains(medicine.id);

          return MedicineCard(
            medicine: medicine,
            isUnlimited: true,
            showRemainingInTitle: false,

            titleWidget: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          medicine.name,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,

                          style: cardTitleStyle,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 1.w),
                        child: Text(
                          " İlaç Geçmişi",

                          style: smallWhiteTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isCompleted)
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(
                      "(Tamamlandı)",
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: cardTagStyle,
                    ),
                  ),
              ],
            ),
            bodyWidget: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medicineLogs.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.dividerGrey,
                height: 1,
                indent: 4.w,
                endIndent: 4.w,
              ),
              itemBuilder: (context, logIndex) {
                final log = medicineLogs[logIndex];
                return HistoryLogItem(
                  log: log,
                  medicineName: medicine.name,
                  onUpdateLogTap: onUpdateLogTap,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
