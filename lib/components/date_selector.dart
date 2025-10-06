import 'package:flutter/material.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final List<DateTime> selectedDates;
  final ValueChanged<List<DateTime>> onChanged;
  const DateSelector({
    super.key,
    required this.selectedDates,
    required this.onChanged,
  });

  Future<DateTime?> _pickDate(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
  }

  Future<void> _editDate(
    BuildContext context,
    DateTime current,
    int index,
  ) async {
    final picked = await _pickDate(context, initialDate: current);

    if (picked != null) {
      final newDates = List<DateTime>.from(selectedDates);
      newDates[index] = picked;
      onChanged(newDates);
    }
  }

  Future<void> _addDate(BuildContext context) async {
    final picked = await _pickDate(context);

    if (picked != null) {
      final newDates = List<DateTime>.from(selectedDates)..add(picked);
      onChanged(newDates);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tarih Seçiniz:",
          style: Theme.of(context).textTheme.titleLargeBold,
        ),

        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          children: [
            ...selectedDates.asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;
              return GestureDetector(
                onTap: () => _editDate(context, d, index),
                child: Chip(
                  backgroundColor: AppColors.background,
                  label: Text(
                    formatter.format(d),

                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onDeleted: () {
                    final newDates = List<DateTime>.from(selectedDates)
                      ..removeAt(index);
                    onChanged(newDates);
                  },
                ),
              );
            }),
            ActionChip(
              backgroundColor: AppColors.background,

              side: const BorderSide(color: AppColors.primary, width: 1.5),

              avatar: Icon(Icons.add, size: 18.sp, color: AppColors.primary),
              label: Text(
                "Tarih Ekle",

                style: Theme.of(context).textTheme.bodyMediumPrimary,
              ),
              onPressed: () => _addDate(context),
            ),
          ],
        ),
      ],
    );
  }
}
