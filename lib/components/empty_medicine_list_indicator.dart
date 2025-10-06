import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_app/components/app_action_button.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';

class EmptyMedicineListIndicator extends StatelessWidget {
  const EmptyMedicineListIndicator({super.key});

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
                    Icons.medication_liquid_outlined,
                    size: 25.w,
                    color: AppColors.primaryOpacity50,
                  ),
                  SizedBox(height: 3.h),

                  Text(
                    "Aktif İlaç Listeniz Boş",
                    textAlign: TextAlign.center,
                    style: headlineStyle,
                  ),
                  SizedBox(height: 1.h),

                  Text(
                    "Başlamak için 'İlaç Ekle' sekmesini kullanarak yeni bir ilaç tanımlayın. Takip ettiğiniz ilaçlar bu sayfada görünecektir.",
                    textAlign: TextAlign.center,
                    style: bodyStyle,
                  ),
                  SizedBox(height: 4.h),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 50.w),
                        child: AppActionButton(
                          text: "İlk İlacımı Ekle",
                          icon: Icons.add_circle_outline,
                          onPressed: () {
                            context.read<MedicineCubit>().showForm();
                            context.read<NavigationCubit>().selectTab(
                              AppTab.add.index,
                            );
                          },
                          horizontalPadding: 8.0,
                          verticalPadding: 2.0,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
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
