import 'package:firebase_messaging/firebase_messaging.dart';

import '../../network/network_info.dart';
import '../../services/notification/foreground_notification_handler.dart';
import '../../services/services.dart';
import '../injection_container.dart';

Future<void> initNotification() async {
  PerformanceService.instance.startOperation('Notification Services');

  sl.registerSingleton<LocalNotificationService>(LocalNotificationService());
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<NotificationHelper>(
    () => NotificationHelper(
      sl<FirebaseMessaging>(),
      sl<AppPrefsManager>(),
      sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<NotificationStatusService>(
    () => NotificationStatusService(
      sl<NotificationHelper>(),
      sl<NetworkInfo>(),
      sl<AppPrefsManager>(),
    ),
  );

  // Register the foreground notification handler as a singleton
  sl.registerSingleton<ForegroundNotificationHandler>(
    ForegroundNotificationHandler(),
  );

  // Initialize Notification Services
  await LocalNotificationService.initialize();

  // Initialize FCM with foreground notification handler
  final handler = sl<ForegroundNotificationHandler>();
  await LocalNotificationService.initializeFCM(
    onForegroundMessage: handler.handleForegroundNotification,
  );

  PerformanceService.instance.endOperation('Notification Services');
}
