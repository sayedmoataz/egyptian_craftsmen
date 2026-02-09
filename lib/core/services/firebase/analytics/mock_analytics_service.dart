import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_models.dart';
import 'analytics_services.dart';

class MockAnalyticsService implements IAnalyticsService {
  @override
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    log('[STAGING] Analytics Event: ${event.name}', name: 'analytics');
    if (event.parameters != null) {
      log('[STAGING] Event Parameters: ${event.parameters}', name: 'analytics');
    }
  }

  @override
  Future<void> logScreenView(ScreenViewEvent event) async {
    log('[STAGING] Screen View: ${event.screenName}, name: analytics');
    if (event.screenClass != null) {
      log('[STAGING] Screen Class: ${event.screenClass}', name: 'analytics');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    log('[STAGING] Set User ID: $userId', name: 'analytics');
  }

  @override
  Future<void> setUserProperty({required String name, required String value}) async {
    log('[STAGING] Set User Property: $name = $value', name: 'analytics');
  }

  @override
  Future<void> setUserContext(UserContext context) async {
    log('[STAGING] Set User Context: ${context.userName}', name: 'analytics');
  }

  @override
  Future<void> resetAnalytics() async {
    log('[STAGING] Reset Analytics Data', name: 'analytics');
  }
}
