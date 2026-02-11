import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/routes.dart';
import 'core/services/general/performance_service.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/utils/force_upgrade/force_update_wrapper.dart';
import 'core/widgets/utils/offline/connectivity_wrapper.dart';
import 'flavors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    // Initialize routes registry
    NavigationService.instance.initRoutes(routes);

    // Initialize remaining services after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await di.initRemainingServices();

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
        title: F.title,

        navigatorKey: NavigationService.instance.navigationKey,
        navigatorObservers: [NavigationService.instance.routeObserver],
        onGenerateRoute: RouteGenerator(routes: routes).onGenerateRoute,
        onGenerateTitle: (context) => F.title,

        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: Routes.login,

        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) {
          Widget widget = child ?? const SizedBox.shrink();

          widget = ForceUpdateWrapper(child: widget);

          widget = ConnectivityWrapper(child: widget);

          if (F.appFlavor == Flavor.dev) {
            widget = _flavorBanner(
              child: widget,
              message: F.name.toUpperCase(),
            );
          }

          return widget;
        },
      ),
    );
  }

  Widget _flavorBanner({required Widget child, required String message}) {
    return Banner(
      location: BannerLocation.topStart,
      message: message,
      color: Colors.red.withOpacity(0.6),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
        color: Colors.white,
      ),
      textDirection: ui.TextDirection.ltr,
      child: child,
    );
  }
}
