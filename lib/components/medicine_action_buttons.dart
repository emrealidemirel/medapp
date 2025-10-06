import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/theme/app_theme.dart';

class MedicineActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTake;
  final VoidCallback? onSkip;
  final bool isIcon;

  const MedicineActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onTake,
    this.onSkip,
    this.isIcon = true,
  });

  Widget _buildButton(
    BuildContext context,
    IconData? icon,
    String text,
    VoidCallback? onPressed,
    Color color,
  ) {
    final textStyleBase = Theme.of(context).textTheme.actionButtonTextBase;

    if (isIcon) {
      return IconButton(
        icon: Icon(icon, size: 20.sp),
        onPressed: onPressed,
        color: color,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        child: Text(text, style: textStyleBase.copyWith(color: color)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onTake != null)
          _buildButton(
            context,
            Icons.check_circle_outline,
            'Alındı',
            onTake,
            AppColors.primary,
          ),
        if (onSkip != null)
          _buildButton(
            context,
            Icons.cancel_outlined,
            'Atlandı',
            onSkip,
            AppColors.danger,
          ),
        if (onEdit != null)
          _buildButton(
            context,
            Icons.edit,
            'Düzenle',
            onEdit,
            AppColors.primary,
          ),
        if (onDelete != null)
          _buildButton(
            context,
            Icons.delete,
            'Sil',
            onDelete,
            AppColors.danger,
          ),
      ],
    );
  }
}
