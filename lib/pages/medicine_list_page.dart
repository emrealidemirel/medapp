import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';
import 'package:medicine_app/components/medicine_list_content.dart';
import 'package:medicine_app/components/empty_medicine_list_indicator.dart';

class MedicineListPage extends StatelessWidget {
  const MedicineListPage({super.key});

  void _showDeleteDialog(
    BuildContext context,
    String medicineId,
    String medicineName,
  ) {
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
          title: Text("İlacı Sil", style: titleStyle),

          content: Text("$medicineName silinsin mi?", style: contentStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),

              child: const Text("İptal"),
            ),

            TextButton(
              onPressed: () {
                context.read<MedicineCubit>().deleteMedicine(medicineId);
                Navigator.pop(dialogContext);
              },

              child: Text("Sil", style: dangerButtonTextStyle),
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
        builder: (context, state) {
          if (state is MedicineLoaded) {
            final activeMedicines = state.activeMedicines;

            if (activeMedicines.isEmpty) {
              return const EmptyMedicineListIndicator();
            }

            return MedicineListContent(
              activeMedicines: activeMedicines,
              onDeleteTap: (id, name) => _showDeleteDialog(context, id, name),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
