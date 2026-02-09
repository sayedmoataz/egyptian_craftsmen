import 'package:aelanji/core/di/injection_container.dart';
import 'package:aelanji/core/services/firebase/analytics/mock_analytics_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../config/app_config.dart';
import '../../services/firebase/analytics/analytics_helper.dart';
import '../../services/firebase/analytics/analytics_services.dart';
import '../../services/firebase/remote_config_service.dart';
import '../../services/general/performance_service.dart';

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
