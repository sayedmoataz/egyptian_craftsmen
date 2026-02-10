import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/routes.dart';
import 'core/services/general/performance_service.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'core/widgets/utils/force_upgrade/force_update_wrapper.dart';
import 'core/widgets/utils/offline/connectivity_wrapper.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize routes registry for guard checking
    NavigationService.instance.initRoutes(routes);

    // Initialize remaining services after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await di.initRemainingServices();

      // Print performance report in debug mode
      if (kDebugMode) {
        PerformanceService.instance.printReport();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isAndroid ? true : false,
      child: MaterialApp(
        navigatorKey: NavigationService.instance.navigationKey,
        navigatorObservers: [NavigationService.instance.routeObserver],
        onGenerateRoute: RouteGenerator(routes: routes).onGenerateRoute,
        onGenerateTitle: (context) => AppStrings.of(context).appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        initialRoute: Routes.login,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) {
          return ConnectivityWrapper(
            child: ForceUpdateWrapper(child: child ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}
