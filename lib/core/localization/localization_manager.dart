import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../services/navigation/navigation_service.dart';

class LocalizationManager {
  LocalizationManager._();
  static final LocalizationManager _instance = LocalizationManager._();
  factory LocalizationManager() => _instance;

  static const String translationsPath = 'assets/lang';
  static const Locale fallbackLocale = Locale('en');
  static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];

  Locale _currentLocale = fallbackLocale;
  Locale get currentLocale => _currentLocale;

  // ignore: use_setters_to_change_properties
  void updateLocale(Locale locale) {
    _currentLocale = locale;
  }

  String translate(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    // Use NavigationService singleton directly (not via GetIt)
    final context = NavigationService.instance.navigationKey.currentContext;
    return tr(key, context: context, args: args, namedArgs: namedArgs);
  }
}
