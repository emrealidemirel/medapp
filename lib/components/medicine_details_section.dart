import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/components/medicine_text_field.dart';
import 'package:medicine_app/theme/app_theme.dart';

class MedicineDetailsSection extends StatelessWidget {
  final MedicineFormState formState;

  const MedicineDetailsSection({super.key, required this.formState});

  @override
  Widget build(BuildContext context) {
    final medicineCubit = context.read<MedicineCubit>();
    final formTitleStyle = Theme.of(context).textTheme.headlineSmallBold;
    final bodyMediumSemiBoldStyle = Theme.of(
      context,
    ).textTheme.bodyMediumSemiBold;
    final tooltipStyle = Theme.of(context).textTheme.tooltipTextWhite;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Text(
              formState.medicineToEdit != null
                  ? "İlacı Düzenle"
                  : "Yeni İlaç Ekle",

              style: formTitleStyle,
            ),
          ),

          MedicineTextField(
            initialValue: formState.name,
            label: "İlaç Adı",
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => medicineCubit.updateForm(name: value),
            validator: (value) =>
                value == null || value.isEmpty ? "İlaç adı boş olamaz" : null,
          ),
          SizedBox(height: 2.h),

          if (!formState.isUnlimited)
            MedicineTextField(
              initialValue: formState.remainingCount?.toString(),
              label: "Toplam İlaç Adeti",
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  medicineCubit.updateForm(remainingCount: int.tryParse(value)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "İlaç adeti boş olamaz";
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return "Geçerli bir sayı giriniz";
                }
                return null;
              },
            ),

          Row(
            children: [
              Checkbox(
                value: formState.isUnlimited,
                onChanged: (bool? value) {
                  medicineCubit.updateForm(isUnlimited: value ?? false);
                },
              ),

              Text("Sürekli Alınacak İlaç", style: bodyMediumSemiBoldStyle),
              SizedBox(width: 2.w),
              Tooltip(
                textStyle: tooltipStyle,
                message:
                    "Bu seçeneği, ilacın belirli bir adetle sınırlı olmadığı durumlarda kullanın. Örneğin, vitaminler veya ömür boyu kullanılması gereken ilaçlar için uygundur.",
                preferBelow: false,
                child: Icon(
                  Icons.info_outline,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          MedicineTextField(
            initialValue: formState.note,
            label: "Not",
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) => medicineCubit.updateForm(note: value),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }
}
