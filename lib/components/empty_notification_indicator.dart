import 'package:flutter/material.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmptyNotificationIndicator extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyNotificationIndicator({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.headlineSmallPrimaryBold;
    final bodyStyle = Theme.of(context).textTheme.bodyLargeGreyItalic;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15.w, color: AppColors.primaryOpacity50),
              SizedBox(height: 3.h),
              Text(title, textAlign: TextAlign.center, style: headlineStyle),
              SizedBox(height: 1.h),
              Text(message, textAlign: TextAlign.center, style: bodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}
