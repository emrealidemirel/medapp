import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine_app/blocs/medicine/medicine_cubit.dart';
import 'package:medicine_app/blocs/navigation/navigation_cubit.dart';
import 'package:medicine_app/blocs/notification/notification_cubit.dart';
import 'package:medicine_app/models/medicine.dart';
import 'package:medicine_app/models/medicine_log.dart';
import 'package:medicine_app/pages/home_page.dart';
import 'package:medicine_app/services/notifications/notification_service.dart';
import 'package:medicine_app/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:medicine_app/services/medicine_log_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicine_app/models/pending_notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(MedicineAdapter());
  Hive.registerAdapter(MedicineLogAdapter());
  Hive.registerAdapter(RepeatCycleAdapter());
  Hive.registerAdapter(PendingNotificationAdapter());

  final medicineBox = await Hive.openBox<Medicine>('medicines');
  final logBox = await Hive.openBox<MedicineLog>('medicineLogs');
  final pendingBox = await Hive.openBox<PendingNotification>(
    'pendingNotifications',
  );

  final notificationService = NotificationService();
  await notificationService.initNotifications(pendingBox);

  await notificationService.requestAllPermissionsIfNeeded();

  final navigationCubit = NavigationCubit();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await notificationService.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

  String? initialPayload;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    initialPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
  }

  notificationService.onNotificationTapped = (payload) {
    navigationCubit.navigateToNotifications(payload: payload);
  };

  runApp(
    MyApp(
      medicineBox: medicineBox,
      logBox: logBox,
      notificationService: notificationService,
      navigationCubit: navigationCubit,
      initialPayload: initialPayload,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Box<Medicine> medicineBox;
  final Box<MedicineLog> logBox;
  final NotificationService notificationService;
  final NavigationCubit navigationCubit;
  final String? initialPayload;

  const MyApp({
    super.key,
    required this.medicineBox,
    required this.logBox,
    required this.notificationService,
    required this.navigationCubit,
    this.initialPayload,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: navigationCubit),
            BlocProvider(create: (_) => NotificationCubit(notificationService)),
            BlocProvider(
              create: (context) => MedicineCubit(
                medicineBox: medicineBox,
                logService: MedicineLogService(logBox),
                notificationService: notificationService,
              ),
            ),
          ],
          child: MaterialApp(
            title: 'MedApp',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: HomePage(initialPayload: initialPayload),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
          ),
        );
      },
    );
  }
}
