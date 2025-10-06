import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/theme/app_theme.dart';

class MedicineListDetailRow extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? contentColor;

  const MedicineListDetailRow({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyleBold = Theme.of(context).textTheme.labelMediumBold;

    const double iconSize = 14.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Icon(
                      icon,

                      size: iconSize,
                      color: AppColors.textDark,
                    ),
                  ),
                Text("$title:", style: textStyleBold),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: Text(
              content,
              textAlign: TextAlign.right,

              style: textStyleBold.copyWith(
                color: contentColor ?? AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
