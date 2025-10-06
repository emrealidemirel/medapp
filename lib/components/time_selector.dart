import 'package:flutter/material.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TimeSelector extends StatefulWidget {
  final List<String> selectedTimes;
  final ValueChanged<List<String>> onChanged;
  final int? maxTimes;

  const TimeSelector({
    super.key,
    required this.selectedTimes,
    required this.onChanged,
    this.maxTimes,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  Future<void> _editTime(
    BuildContext context,
    String current,
    int index,
  ) async {
    final parts = current.split(':').map(int.parse).toList();
    final initialTime = TimeOfDay(hour: parts[0], minute: parts[1]);

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (time != null) {
      final newTimes = List<String>.from(widget.selectedTimes);
      newTimes[index] =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
      widget.onChanged(newTimes);
    }
  }

  Future<void> _addTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (time != null) {
      final newTimes = List<String>.from(widget.selectedTimes)
        ..add(
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
        );
      widget.onChanged(newTimes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAdd =
        widget.maxTimes == null ||
        widget.selectedTimes.length < widget.maxTimes!;

    final bodyMediumPrimary = Theme.of(context).textTheme.bodyMediumPrimary;
    final chipLabelSelected = Theme.of(context).textTheme.chipLabelSelected;
    final textDisabled = AppColors.textDisabled;

    TextStyle getDisabledTextStyle() {
      return Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(color: textDisabled);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Saat Seçiniz:",
          style: Theme.of(context).textTheme.titleLargeBold,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            ...widget.selectedTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final t = entry.value;
              return GestureDetector(
                onTap: () => _editTime(context, t, index),
                child: Chip(
                  backgroundColor: AppColors.primary,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  label: Text(t, style: chipLabelSelected),

                  deleteIconColor: AppColors.background,
                  onDeleted: () {
                    final newTimes = List<String>.from(widget.selectedTimes);
                    newTimes.removeAt(index);
                    widget.onChanged(newTimes);
                  },
                ),
              );
            }),

            ActionChip(
              backgroundColor: canAdd
                  ? AppColors.background
                  : AppColors.borderLight,

              side: canAdd
                  ? const BorderSide(color: AppColors.primary, width: 1.5)
                  : BorderSide.none,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),

              avatar: Icon(
                Icons.add,
                size: 18.sp,

                color: canAdd ? AppColors.primary : AppColors.textDisabled,
              ),
              label: Text(
                "Saat Ekle",

                style: canAdd ? bodyMediumPrimary : getDisabledTextStyle(),
              ),
              onPressed: canAdd ? () => _addTime(context) : null,
              tooltip: canAdd
                  ? null
                  : "Toplam ilaç adeti ${widget.maxTimes} olduğu için daha fazla saat eklenemez.",
            ),
          ],
        ),
      ],
    );
  }
}
