import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';

class EmptyHistoryIndicator extends StatelessWidget {
  const EmptyHistoryIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.headlineSmallPrimaryBold;
    final bodyStyle = Theme.of(context).textTheme.bodyLargeGreyItalic;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await context.read<MedicineCubit>().loadMedicines();
      },
      child: Stack(
        children: [
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [SizedBox(height: 10.h)],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 25.w,

                    color: AppColors.primaryOpacity50,
                  ),
                  SizedBox(height: 3.h),

                  Text(
                    "Henüz Geçmiş Kaydı Yok",
                    textAlign: TextAlign.center,

                    style: headlineStyle,
                  ),
                  SizedBox(height: 1.h),

                  Text(
                    "Aldığınız veya atladığınız ilaçların geçmiş listesi bu sayfada görünecektir. Aktif ilaç bilgilerinizi İlaçlarım sayfasında bulabilirsiniz. Bildirimlerinizi kontrol etmeyi unutmayın.",
                    textAlign: TextAlign.center,

                    style: bodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
