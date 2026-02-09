import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';

class CrashlyticsLogger {
  static final FirebaseCrashlytics _crashlytics = GetIt.I<FirebaseCrashlytics>();

  /// Logs an error to Crashlytics with contextual information.
  /// - [error]: The error or exception to log.
  /// - [stackTrace]: The stack trace associated with the error (optional).
  /// - [reason]: A brief description of why the error occurred.
  /// - [feature]: The feature or module name (e.g., 'book_unit').
  /// - [context]: Additional context (e.g., endpoint, event name).
  /// - [fatal]: Whether the error is fatal (defaults to false).
  static void logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    String? feature,
    List<String> context = const [],
    bool fatal = true,
  }) {
    debugPrint('Attempting to log error: $error');

    if (kDebugMode) {
      print('Debug mode - error logging skipped');
      return;
    }

    try {
      _crashlytics.recordError(
        error,
        stackTrace ?? StackTrace.current,
        reason: reason,
        fatal: fatal,
        information: [if (feature != null) 'Feature: $feature', ...context],
      );
      debugPrint('Error successfully logged to Crashlytics'); // Confirmation print
    } catch (e) {
      debugPrint('Failed to log error to Crashlytics: $e');
    }
  }

  /// Logs a message to Crashlytics for tracking events or context.
  /// - [message]: The message to log.
  /// - [feature]: The feature or module name (optional).
  static void logMessage(String message, {String? feature}) {
    if (kDebugMode) return;
    _crashlytics.log('${feature != null ? "[$feature] " : ""}$message');
    if (feature != null) {
      _crashlytics.setCustomKey('feature', feature);
    }
  }

  static void setUserIdentifier(String userId) {
    if (kDebugMode) return;
    _crashlytics.setUserIdentifier(userId);
  }
}
