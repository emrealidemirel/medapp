import 'package:flutter/material.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DaySelector extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;
  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar",
    ];

    final selectedTextStyle = Theme.of(context).textTheme.filterChipSelected;

    final unselectedTextStyle = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: AppColors.textDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Günleri Seçiniz:",
          style: Theme.of(context).textTheme.titleLargeBold,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          children: List.generate(7, (index) {
            final day = index + 1;
            final isSelected = selectedDays.contains(day);

            return FilterChip(
              showCheckmark: false,

              label: Text(
                dayNames[index],
                style: isSelected ? selectedTextStyle : unselectedTextStyle,
              ),

              selected: isSelected,
              onSelected: (selected) {
                final newDays = List<int>.from(selectedDays);
                if (selected) {
                  newDays.add(day);
                } else {
                  newDays.remove(day);
                }
                onChanged(newDays);
              },

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
