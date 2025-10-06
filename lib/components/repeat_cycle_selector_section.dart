import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/components/day_selector.dart';
import 'package:medicine_app/components/date_selector.dart';
import 'package:medicine_app/components/time_selector.dart';
import 'package:medicine_app/theme/app_theme.dart';

class RepeatCycleSelectorSection extends StatelessWidget {
  final MedicineFormState formState;
  final int? maxIntakeTimes;

  const RepeatCycleSelectorSection({
    super.key,
    required this.formState,
    required this.maxIntakeTimes,
  });

  @override
  Widget build(BuildContext context) {
    final medicineCubit = context.read<MedicineCubit>();
    final buttonTextStyle = Theme.of(context).textTheme.bodyMedium;
    final sectionTitleStyle = Theme.of(context).textTheme.titleLargeBold;
    final errorTextStyle = Theme.of(context).textTheme.errorStyle;
    final tooltipStyle = Theme.of(context).textTheme.tooltipTextWhite;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Kullanım Tipi:", style: sectionTitleStyle),
              SizedBox(width: 2.w),
              Tooltip(
                textStyle: tooltipStyle,
                message:
                    "Günlük Kullanım: Her gün alınacak ilaçlar için uygundur.\nHaftalık Kullanım: Haftanın belirli günlerinde alınacak ilaçlar için uygundur.\nAylık Kullanım: Belirli bir tarihte alınacak ilaçlar için uygundur.",
                preferBelow: false,
                triggerMode: TooltipTriggerMode.tap,
                decoration: BoxDecoration(
                  color: AppColors.textDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          ToggleButtons(
            isSelected: [
              formState.repeatCycle == RepeatCycle.daily,
              formState.repeatCycle == RepeatCycle.weekly,
              formState.repeatCycle == RepeatCycle.monthly,
            ],
            onPressed: (index) {
              final newCycle = [
                RepeatCycle.daily,
                RepeatCycle.weekly,
                RepeatCycle.monthly,
              ][index];
              medicineCubit.updateForm(repeatCycle: newCycle);
            },
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Text(
                  "Günlük",

                  style: formState.repeatCycle == RepeatCycle.daily
                      ? Theme.of(
                          context,
                        ).textTheme.toggleButtonSelectedWhiteBold
                      : buttonTextStyle!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Text(
                  "Haftalık",

                  style: formState.repeatCycle == RepeatCycle.weekly
                      ? Theme.of(
                          context,
                        ).textTheme.toggleButtonSelectedWhiteBold
                      : buttonTextStyle,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Text(
                  "Aylık",

                  style: formState.repeatCycle == RepeatCycle.monthly
                      ? Theme.of(
                          context,
                        ).textTheme.toggleButtonSelectedWhiteBold
                      : buttonTextStyle,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          if (formState.repeatCycle == RepeatCycle.weekly)
            DaySelector(
              selectedDays: formState.intakeDays,
              onChanged: (days) => medicineCubit.updateForm(intakeDays: days),
            )
          else if (formState.repeatCycle == RepeatCycle.monthly)
            FormField<List<DateTime>>(
              initialValue: formState.intakeDates,
              validator: (dates) {
                if (dates == null || dates.isEmpty) {
                  return "Lütfen bir tarih seçiniz";
                }
                return null;
              },
              builder: (fieldState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateSelector(
                      selectedDates: formState.intakeDates,
                      onChanged: (dates) {
                        medicineCubit.updateForm(intakeDates: dates);
                        fieldState.didChange(dates);
                      },
                    ),
                    if (fieldState.hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: Text(
                          fieldState.errorText!,

                          style: errorTextStyle,
                        ),
                      ),
                  ],
                );
              },
            ),
          SizedBox(height: 3.h),
          FormField<List<String>>(
            initialValue: formState.intakeTimes,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Lütfen en az bir saat seçiniz";
              }
              if (maxIntakeTimes != null && value.length > maxIntakeTimes!) {
                return "Toplam ilaç adeti ($maxIntakeTimes) kadar saat ekleyebilirsiniz.";
              }
              return null;
            },
            builder: (fieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimeSelector(
                    selectedTimes: formState.intakeTimes,
                    maxTimes: maxIntakeTimes,
                    onChanged: (times) {
                      medicineCubit.updateForm(intakeTimes: times);
                      fieldState.didChange(times);
                      fieldState.validate();
                    },
                  ),
                  if (fieldState.hasError)
                    Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(fieldState.errorText!, style: errorTextStyle),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }
}
