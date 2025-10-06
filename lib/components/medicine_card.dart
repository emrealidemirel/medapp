import 'package:flutter/material.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final Widget titleWidget;
  final Widget bodyWidget;
  final int? remainingAmount;
  final bool isUnlimited;
  final bool showRemainingInTitle;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.titleWidget,
    required this.bodyWidget,
    this.remainingAmount,
    required this.isUnlimited,
    this.showRemainingInTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    String remainingText = '';
    bool shouldShowTag = false;

    if (isUnlimited) {
      remainingText = "(Sınırsız)";
      shouldShowTag = true;
    } else if (remainingAmount != null) {
      remainingText = "(Kalan: $remainingAmount)";
      shouldShowTag = true;
    }

    final tagStyle = Theme.of(context).textTheme.cardTagWhiteItalic;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Container(
        color: AppColors.primary,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: showRemainingInTitle && shouldShowTag ? 7 : 10,
                  child: titleWidget,
                ),

                if (showRemainingInTitle && shouldShowTag)
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(left: 2.w),
                      alignment: Alignment.centerRight,
                      child: Text(
                        remainingText,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,

                        style: tagStyle,
                      ),
                    ),
                  ),
              ],
            ),

            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: bodyWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
