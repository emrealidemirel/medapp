import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_state.dart';
import 'package:medicine_app/components/app_action_button.dart';
import 'package:medicine_app/components/medicine_details_section.dart';
import 'package:medicine_app/components/repeat_cycle_selector_section.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';

class AddMedicinePage extends StatefulWidget {
  final Medicine? medicine;
  const AddMedicinePage({super.key, this.medicine});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();

  void _showPermissionDialog({required String title, required String content}) {
    final dialogTitleStyle = Theme.of(
      context,
    ).textTheme.headlineSmallPrimaryBold;
    final dialogContentStyle = Theme.of(context).textTheme.bodyLarge;
    final primaryButtonTextStyle = Theme.of(
      context,
    ).textTheme.bodyMediumPrimaryBold;

    showDialog(
      context: context,
      builder: (dialogContext) => Theme(
        data: Theme.of(context).copyWith(
          dialogTheme: Theme.of(context).dialogTheme.copyWith(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: AlertDialog(
          title: Text(title, style: dialogTitleStyle),
          content: Text(content, style: dialogContentStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await openAppSettings();
              },
              child: Text("Ayarlara Git", style: primaryButtonTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicineCubit = context.read<MedicineCubit>();

    return BlocConsumer<MedicineCubit, MedicineState>(
      listener: (context, state) {
        if (state is MedicineLoaded) {
          final targetTab = state.targetTab ?? AppTab.list;
          context.read<NavigationCubit>().selectTab(
            AppTab.values.indexOf(targetTab),
          );
        }
      },
      builder: (context, state) {
        if (state is! MedicineFormState) {
          return const Center(child: CircularProgressIndicator());
        }

        final formState = state;
        final maxIntakeTimes = formState.isUnlimited
            ? null
            : formState.remainingCount;

        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
            children: [
              MedicineDetailsSection(formState: formState),
              RepeatCycleSelectorSection(
                formState: formState,
                maxIntakeTimes: maxIntakeTimes,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 50.w),
                    child: AppActionButton(
                      text: widget.medicine == null
                          ? "İlacı Kaydet"
                          : "Değişiklikleri Kaydet",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // 🔹 Bildirim iznini kontrol et
                          var notificationStatus =
                              await Permission.notification.status;

                          if (!mounted) return; // ✅ async güvenliği

                          if (notificationStatus.isDenied ||
                              notificationStatus.isPermanentlyDenied) {
                            _showPermissionDialog(
                              title: "Bildirim İzni Gerekli",
                              content:
                                  "İlaç hatırlatıcısı bildirimlerini alabilmek için bildirim izni gereklidir. Lütfen ayarlar sayfanızdan bu izni verin.",
                            );
                            return;
                          }

                          var exactAlarmStatus =
                              await Permission.scheduleExactAlarm.status;

                          if (!mounted) return; // ✅ async güvenliği

                          if (exactAlarmStatus.isDenied ||
                              exactAlarmStatus.isPermanentlyDenied) {
                            _showPermissionDialog(
                              title: "Alarm ve Planlama İzni Gerekli",
                              content:
                                  "İlaç hatırlatıcı bildirimlerini doğru zamanda alabilmek için alarm ve planlama izni gereklidir. Lütfen ayarlar sayfanızdan bu izni verin.",
                            );
                            return;
                          }

                          try {
                            medicineCubit.saveMedicine();
                          } catch (e) {
                            if (kDebugMode) {
                              debugPrint(
                                'Hata: İlaç kaydetme veya bildirim planlama başarısız oldu: $e',
                              );
                            }
                          }
                        }
                      },
                      horizontalPadding: 8.0,
                      verticalPadding: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
