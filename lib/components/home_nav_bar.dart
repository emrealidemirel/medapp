import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';
import 'package:medicine_app/theme/app_theme.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navState = context.watch<NavigationCubit>().state;
    if (navState.currentTab == AppTab.notifications) {
      return const SizedBox.shrink();
    }

    final navBarLabelStyle = Theme.of(context).textTheme.navBarLabelWhiteBold;

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final medicineState = context.watch<MedicineCubit>().state;
        final isFormOpen = medicineState is MedicineFormState;

        int activeIndex;
        if (isFormOpen) {
          activeIndex = 2;
        } else if (state.currentTab == AppTab.history) {
          activeIndex = 0;
        } else {
          activeIndex = 1;
        }

        return SafeArea(
          bottom: true,
          child: CircleNavBar(
            activeIcons: [
              Icon(Icons.history, color: Colors.white, size: 6.w),
              Icon(Icons.home, color: Colors.white, size: 6.w),
              Icon(Icons.add, color: Colors.white, size: 6.w),
            ],
            inactiveIcons: [
              Text("Geçmiş", style: navBarLabelStyle),
              Text("İlaçlarım", style: navBarLabelStyle),
              Text("İlaç Ekle", style: navBarLabelStyle),
            ],
            color: AppColors.primary,
            gradient: AppColors.primaryGradient,
            height: 7.h,
            circleWidth: 14.w,
            activeIndex: activeIndex,
            onTap: (navBarIndex) {
              final targetTab = navBarIndex == 0
                  ? AppTab.history
                  : (navBarIndex == 1 ? AppTab.list : AppTab.add);

              final medicineCubit = context.read<MedicineCubit>();
              final navCubit = context.read<NavigationCubit>();

              if (medicineCubit.state is MedicineFormState &&
                  targetTab != AppTab.add) {
                medicineCubit.resetForm(targetTab: targetTab);
                return;
              }

              if (targetTab == AppTab.add) {
                medicineCubit.showForm();
              }

              navCubit.selectTab(AppTab.values.indexOf(targetTab));
            },

            shadowColor: AppColors.shadowDarkOpacity50,
            circleColor: AppColors.primary,
          ),
        );
      },
    );
  }
}
