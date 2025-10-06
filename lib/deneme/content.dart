/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/components/medicine_card.dart';
import 'package:medicine_app/components/medicine_action_buttons.dart';
import 'package:medicine_app/components/medicine_list_detail_row.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:medicine_app/utils/day_utils.dart';
import 'package:medicine_app/models/medicine.dart';

class MedicineListContent extends StatelessWidget {
  final List<Medicine> activeMedicines;
  final Function(String, String) onDeleteTap;

  const MedicineListContent({
    super.key,
    required this.activeMedicines,
    required this.onDeleteTap,
  });

  Widget _buildMedicineCard(BuildContext context, Medicine medicine) {
    final formattedDate = DateFormat("dd.MM.yyyy").format(medicine.createdAt);

    final totalCount = medicine.totalCount;
    final remainingCount = medicine.remainingCount;

    final remainingCountText = medicine.isUnlimited
        ? "Sınırsız"
        : "${remainingCount ?? 0}";

    String repeatText;
    if (medicine.repeatCycle == RepeatCycle.monthly) {
      final now = DateTime.now();
      repeatText = medicine.intakeDays
          .map((dayOfMonth) {
            return DateFormat(
              "dd.MM",
            ).format(DateTime(now.year, now.month, dayOfMonth));
          })
          .join(", ");
    } else {
      repeatText = DayUtils.formatDays(medicine.intakeDays);
    }

    final cardTitleStyle = Theme.of(context).textTheme.cardTitlePrimary;
    final dividerColor = AppColors.dividerGrey;

    return MedicineCard(
      medicine: medicine,
      remainingAmount: remainingCount,
      isUnlimited: medicine.isUnlimited,
      showRemainingInTitle: true,
      titleWidget: Text(
        medicine.name,
        softWrap: false,
        overflow: TextOverflow.ellipsis,

        style: cardTitleStyle,
      ),
      bodyWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!medicine.isUnlimited && totalCount != null)
            MedicineListDetailRow(
              title: "Toplam İlaç Adeti",
              content: totalCount.toString(),
              icon: Icons.inventory_2_outlined,
            ),

          if (!medicine.isUnlimited && remainingCount != null)
            Column(
              children: [
                Divider(color: dividerColor, height: 1.5.h),
                MedicineListDetailRow(
                  title: "Kalan İlaç Adeti",
                  content: remainingCountText,
                  icon: Icons.filter_9_plus_outlined,

                  contentColor: remainingCount <= 5
                      ? AppColors.danger
                      : AppColors.textDark,
                ),
              ],
            ),

          Divider(color: dividerColor, height: 1.5.h),

          MedicineListDetailRow(
            title: medicine.repeatCycle == RepeatCycle.monthly
                ? "Tekrar Tarihleri"
                : "Tekrar Günleri",
            content: repeatText,
            icon: Icons.repeat,
          ),
          Divider(color: dividerColor, height: 1.5.h),

          MedicineListDetailRow(
            title: "Saatler",
            content: medicine.intakeTimes.join(", "),
            icon: Icons.schedule,
          ),
          Divider(color: dividerColor, height: 1.5.h),

          MedicineListDetailRow(
            title: "Eklendiği Tarih",
            content: formattedDate,
            icon: Icons.calendar_today_outlined,
          ),

          if (medicine.note != null && medicine.note!.isNotEmpty)
            Column(
              children: [
                Divider(color: dividerColor, height: 1.5.h),
                MedicineListDetailRow(
                  title: "Not",
                  content: medicine.note!,
                  icon: Icons.notes,
                ),
              ],
            ),

          SizedBox(height: 2.h),

          MedicineActionButtons(
            isIcon: false,
            onEdit: () {
              context.read<MedicineCubit>().showForm(medicine: medicine);

              context.read<NavigationCubit>().selectTab(1);
            },
            onDelete: () => onDeleteTap(medicine.id, medicine.name),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listHeaderStyle = Theme.of(context).textTheme.listHeaderTitle;

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MedicineCubit>().loadMedicines();
      },
      child: ListView.builder(
        padding: EdgeInsets.only(top: 1.h),
        itemCount: activeMedicines.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text(
                "Aktif İlaçlar (${activeMedicines.length})",

                style: listHeaderStyle,
              ),
            );
          }

          final medicine = activeMedicines[index - 1];
          return _buildMedicineCard(context, medicine);
        },
      ),
    );
  }
}
 */