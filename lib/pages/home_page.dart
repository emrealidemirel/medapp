import 'package:flutter/material.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_app/components/home_app_bar_content.dart';
import 'package:medicine_app/components/home_nav_bar.dart';
import 'medicine_list_page.dart';
import 'medicine_history_page.dart';
import 'add_medicine_page.dart';
import 'notification_page.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';

class HomePage extends StatefulWidget {
  final String? initialPayload;
  const HomePage({super.key, this.initialPayload});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController(initialPage: 1);
  final String appLogoPath = 'assets/app_icon/app_icon.png';

  bool get isPageControllerAttached =>
      pageController.hasClients && pageController.position.hasContentDimensions;

  @override
  void initState() {
    super.initState();
    if (widget.initialPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<NavigationCubit>().navigateToNotifications(
          payload: widget.initialPayload,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listener: (context, state) {
        final medicineState = context.read<MedicineCubit>().state;

        if (state.currentTab != AppTab.notifications &&
            isPageControllerAttached) {
          int targetIndex = 1;

          if (medicineState is MedicineFormState) {
            targetIndex = 2;
          } else if (state.currentTab == AppTab.history) {
            targetIndex = 0;
          }

          if (pageController.page?.round() != targetIndex) {
            pageController.jumpToPage(targetIndex);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,

          title: HomeAppBarContent(appLogoPath: appLogoPath),

          actions: [
            if (context.watch<NavigationCubit>().state.currentTab !=
                AppTab.notifications)
              const AppNotificationAction(),
          ],

          leading:
              context.watch<NavigationCubit>().state.currentTab ==
                  AppTab.notifications
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    final medicineCubit = context.read<MedicineCubit>();
                    medicineCubit.resetForm();
                    context.read<NavigationCubit>().clearNotificationPayload();
                  },
                )
              : null,
        ),
        body: BlocBuilder<MedicineCubit, MedicineState>(
          builder: (context, medicineState) {
            final navState = context.watch<NavigationCubit>().state;

            if (navState.currentTab == AppTab.notifications) {
              return NotificationPage(
                key: ValueKey(navState.selectedNotificationPayload),
              );
            }

            return PageView(
              controller: pageController,
              physics: medicineState is MedicineFormState
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),

              onPageChanged: (index) {
                final medicineCubit = context.read<MedicineCubit>();

                final targetTab = index == 0
                    ? AppTab.history
                    : (index == 1 ? AppTab.list : AppTab.add);

                if (targetTab == AppTab.add &&
                    medicineCubit.state is! MedicineFormState) {
                  medicineCubit.showForm();
                }

                if (medicineCubit.state is MedicineFormState &&
                    targetTab != AppTab.add) {
                  medicineCubit.resetForm(targetTab: targetTab);
                }

                context.read<NavigationCubit>().selectTab(
                  AppTab.values.indexOf(targetTab),
                );
              },
              children: [
                const MedicineHistoryPage(),
                const MedicineListPage(),
                const AddMedicinePage(),
              ],
            );
          },
        ),

        bottomNavigationBar: const HomeNavBar(),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
