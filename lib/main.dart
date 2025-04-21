import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';
import 'package:recordatorios_app/presentation/providers/theme_provider.dart';
import 'package:recordatorios_app/presentation/screens/home/home_screen.dart';
import 'package:recordatorios_app/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.init();

  await initializeNotifications();
  await requestPermissionByVersion();

  runApp(const MyApp());
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> requestPermissionByVersion() async {
  if (!Platform.isAndroid) return;

  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  if (sdkInt >= 13) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  if (sdkInt >= 12) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        requestExactAlarmPermission(context);
      }
    });
  }
}

Future<void> requestExactAlarmPermission(BuildContext context) async {
  final intent = AndroidIntent(
    action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  await intent.launch();

  if (context.mounted) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Permiso requerido'),
            content: const Text(
              'Para que las notificaciones funcionen correctamente, necesitas permitir alarmas exactas en la configuración del sistema.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido'),
              ),
            ],
          ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CasesProvider()..loadCases()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider themeProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            theme: ThemeData(
              colorSchemeSeed: themeProvider.primaryColor,
              brightness: themeProvider.brightness,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
