import 'package:flutter/material.dart';
import 'package:medicine_app/theme/app_contants.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  final Color backgroundColor;
  final Color foregroundColor;

  final double horizontalPadding;
  final double verticalPadding;
  final double? fontSize;

  const AppActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.background,

    this.horizontalPadding = 8.0,
    this.verticalPadding = 2.0,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final finalHorizontalPadding = horizontalPadding.w;
    final finalVerticalPadding = verticalPadding.h;

    final Widget button;

    final buttonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: finalHorizontalPadding,
        vertical: finalVerticalPadding,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      ),
      backgroundColor: backgroundColor,

      elevation: AppConstants.buttonElevation,
    );

    final baseTextStyle = Theme.of(context).textTheme.chipLabelSelected
        .copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.bold,

          fontSize: fontSize?.sp,
        );

    final textWidget = Text(text, style: baseTextStyle);

    if (icon != null) {
      button = ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foregroundColor),
        label: textWidget,
        style: buttonStyle,
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: textWidget,
      );
    }

    return button;
  }
}
