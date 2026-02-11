import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;
import 'core/localization/localization_manager.dart';
import 'core/services/general/performance_service.dart';
import 'core/theme/colors.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start app startup timing
  PerformanceService.instance.startOperation('App Startup');

  await EasyLocalization.ensureInitialized();

  // Set preferred orientations
  await PerformanceService.instance.measureAsync(
    'Set Orientations',
    () => SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize essential services before app render
  await di.initEssentialServices();

  // End essential startup timing
  PerformanceService.instance.endOperation('App Startup');

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      startLocale: LocalizationManager.fallbackLocale,
      child: const App(),
    ),
  );
}