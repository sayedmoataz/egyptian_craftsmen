import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../config/app_config.dart';
import '../../services/services.dart';
import '../injection_container.dart';

Future<void> initFirebase() async {
  PerformanceService.instance.startOperation('Firebase Services');

  if (AppConfig.isProduction) {
    sl.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
    sl.registerLazySingleton<AnalyticsHelper>(AnalyticsHelper.new);
    sl.registerLazySingleton<IAnalyticsService>(FirebaseAnalyticsService.new);
    sl.registerLazySingleton<RemoteConfigService>(RemoteConfigService.new);
  } else {
    sl.registerLazySingleton<AnalyticsHelper>(AnalyticsHelper.new);
    sl.registerLazySingleton<IAnalyticsService>(MockAnalyticsService.new);
  }

  PerformanceService.instance.endOperation('Firebase Services');
}
