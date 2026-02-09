import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../di/injection_container.dart';
import '../crashlytics_logger.dart';
import 'analytics_helper.dart';
import 'analytics_models.dart';

/// Abstract interface for analytics operations
abstract class IAnalyticsService {
  /// Log a custom event
  Future<void> logEvent(AnalyticsEvent event);

  /// Log screen view
  Future<void> logScreenView(ScreenViewEvent event);

  /// Set current user ID
  Future<void> setUserId(String? userId);

  /// Set user property (e.g., subscription_status, user_tier)
  Future<void> setUserProperty({required String name, required String value});

  /// Set complete user context (ID + properties)
  Future<void> setUserContext(UserContext context);

  /// Reset all analytics data (on logout)
  Future<void> resetAnalytics();

  /// Firebase observer for navigation tracking
  FirebaseAnalyticsObserver get observer;
}

/// Firebase Analytics implementation
class FirebaseAnalyticsService implements IAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final AnalyticsHelper _helper = sl<AnalyticsHelper>();

  UserContext? _currentUserContext;

  @override
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    try {
      final parameters = <String, Object>{};

      // Add event parameters
      if (event.parameters != null) {
        event.parameters!.forEach((key, value) {
          parameters[key] = _normalizeValue(value);
        });
      }

      // Optionally include user context
      if (event.includeUserContext) {
        final userContext = await _helper.getUserContext();
        if (userContext != null) {
          userContext.toParameters().forEach((key, value) {
            parameters[key] = _normalizeValue(value);
          });
        }
      }

      log('📊 Event: ${event.name}', name: 'Analytics');
      log('📦 Parameters: $parameters', name: 'Analytics');

      await _analytics.logEvent(
        name: event.name,
        parameters: parameters.isNotEmpty ? parameters : null,
      );

      log('✅ Event recorded successfully', name: 'Analytics');
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Analytics event error',
      );
    }
  }

  @override
  Future<void> logScreenView(ScreenViewEvent event) async {
    try {
      // Log to Firebase Analytics native method
      await _analytics.logScreenView(
        screenName: event.screenName,
        screenClass: event.screenClass,
      );

      // Also log as custom event for better tracking
      await logEvent(
        AnalyticsEvent(
          name: 'screen_view_${_sanitizeEventName(event.screenName)}',
          parameters: {
            'screen_name': event.screenName,
            if (event.screenClass != null) 'screen_class': event.screenClass!,
            ...?event.parameters,
          },
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'Screen view error');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      _currentUserContext = await _helper.getUserContext();
      log('👤 User ID set: $userId', name: 'Analytics');
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'Set user ID error');
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      log('🏷️ User property set: $name = $value', name: 'Analytics');
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Set user property error',
      );
    }
  }

  @override
  Future<void> setUserContext(UserContext context) async {
    try {
      _currentUserContext = context;
      await _analytics.setUserId(id: context.userId);

      // Set all user properties
      final properties = {
        'user_name': context.userName,
        'user_email': context.userEmail,
        'user_phone': context.userPhone,
      };

      for (final entry in properties.entries) {
        await _analytics.setUserProperty(name: entry.key, value: entry.value);
      }

      log('✅ User context set: ${context.userName}', name: 'Analytics');
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Set user context error',
      );
    }
  }

  @override
  Future<void> resetAnalytics() async {
    try {
      await _analytics.resetAnalyticsData();
      _currentUserContext = null;
      log('🔄 Analytics reset', name: 'Analytics');
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Reset analytics error',
      );
    }
  }

  // Helper: Normalize bool to 0/1 for Firebase
  Object _normalizeValue(Object value) {
    if (value is bool) return value ? 1 : 0;
    return value;
  }

  // Helper: Sanitize event names (remove spaces, special chars)
  String _sanitizeEventName(String name) {
    return name.toLowerCase().replaceAll(RegExp('[^a-z0-9_]'), '_');
  }
}
