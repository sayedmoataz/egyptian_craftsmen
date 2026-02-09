import 'dart:io';

import 'package:aelanji/core/routes/routes.dart';
import 'package:aelanji/core/widgets/utils/force_upgrade/force_update_wrapper.dart';
import 'package:aelanji/core/widgets/utils/offline/connectivity_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';
import 'core/services/general/performance_service.dart';
import 'core/services/navigation/navigation_service.dart';
import 'core/services/navigation/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<FavoritesBloc>()..add(const GetFavoriteIdsEvent()),
        ),
      ],
      child: SafeArea(
        top: false,
        bottom: Platform.isAndroid ? true : false,
        child: MaterialApp(
          navigatorKey: NavigationService.instance.navigationKey,
          navigatorObservers: [NavigationService.instance.routeObserver],
          onGenerateRoute: RouteGenerator(routes: routes).onGenerateRoute,
          title: 'Aelanji - إعلانجي',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme,
          initialRoute: Routes.splash,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return ForceUpdateWrapper(
              child: ConnectivityWrapper(
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }
}
