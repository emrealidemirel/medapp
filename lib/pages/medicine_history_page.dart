import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/models/medicine_log.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:medicine_app/components/history_list_content.dart';
import 'package:medicine_app/components/empty_history_indicator.dart';

class MedicineHistoryPage extends StatelessWidget {
  const MedicineHistoryPage({super.key});

  void _showClearHistoryDialog(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final contentStyle = Theme.of(context).textTheme.bodyMedium;
    final dangerButtonTextStyle = Theme.of(
      context,
    ).textTheme.bodyMediumDangerBold;

    showDialog(
      context: context,
      builder: (dialogContext) => Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: Theme.of(context).dialogTheme.copyWith(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: AlertDialog(
          title: Text("İlaç Geçmişini Temizle", style: titleStyle),
          content: Text(
            "Tüm ilaç geçmişiniz silinecektir, devam etmek istediğinize emin misiniz?",
            style: contentStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                context.read<MedicineCubit>().clearLogs();
                // Bu metot senkron olduğu için mounted kontrolü gerekmez.
                Navigator.pop(dialogContext);
              },
              child: Text("Temizle", style: dangerButtonTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateLogDialog(
    BuildContext context,
    MedicineLog log,
    String medicineName,
  ) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final contentStyle = Theme.of(context).textTheme.bodyMedium;
    final primaryButtonTextStyle = Theme.of(
      context,
    ).textTheme.bodyMediumPrimaryBold;
    final dangerButtonTextStyle = Theme.of(
      context,
    ).textTheme.bodyMediumDangerBold;

    showDialog(
      context: context,
      builder: (dialogContext) => Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: Theme.of(context).dialogTheme.copyWith(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: AlertDialog(
          title: Text("Geçmişi Güncelle", style: titleStyle),
          content: Text(
            "'$medicineName' ilacının bu kaydını değiştirmek istediğine emin misin?",
            style: contentStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                await context.read<MedicineCubit>().updateLogStatus(
                  log.id,
                  !log.isTaken,
                );
                
                // DÜZELTME: Asenkron işlem bittikten sonra context kontrolü.
                if (!dialogContext.mounted) return; 
                
                Navigator.pop(dialogContext);
              },
              child: Text(
                log.isTaken
                    ? "Atlandı Olarak İşaretle"
                    : "Alındı Olarak İşaretle",
                style: log.isTaken
                    ? dangerButtonTextStyle
                    : primaryButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w).copyWith(top: 0),
      child: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (blocContext, state) {
          if (state is MedicineLoaded) {
            final completedMedicinesIds = state.completedMedicines
                .map((m) => m.id)
                .toSet();

            final medicinesWithLogs = state.medicines
                .where(
                  (med) => state.allLogs.any((log) => log.medicineId == med.id),
                )
                .toList();

            final allLogs = state.allLogs.reversed.toList();

            if (allLogs.isEmpty) {
              return const EmptyHistoryIndicator();
            }

            return HistoryListContent(
              medicinesWithLogs: medicinesWithLogs,
              completedMedicinesIds: completedMedicinesIds,
              allLogs: allLogs,
              onClearHistoryTap: () => _showClearHistoryDialog(blocContext),
              onUpdateLogTap: (log, name) =>
                  _showUpdateLogDialog(blocContext, log, name),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}