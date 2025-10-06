import 'package:flutter/material.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MedicineTextField extends StatelessWidget {
  final String? initialValue;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;

  const MedicineTextField({
    super.key,
    this.initialValue,
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.textCapitalization = TextCapitalization.words,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        errorStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: AppColors.danger),
      ),
      style: Theme.of(
        context,
      ).textTheme.bodyLarge!.copyWith(color: AppColors.textDark),
    );
  }
}
