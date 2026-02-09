import 'dart:async';
import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';

/// Event types for foreground notifications
enum ForegroundNotificationEventType {
  /// A notification was received in the foreground
  notificationReceived,
}

/// Event data for foreground notifications
class ForegroundNotificationEvent {
  final ForegroundNotificationEventType type;
  final RemoteMessage message;
  final DateTime timestamp;

  ForegroundNotificationEvent({required this.type, required this.message})
    : timestamp = DateTime.now();
}

/// Service to handle foreground notification callbacks
/// This service broadcasts events when notifications are received while the app is open
/// Screens can listen to these events and refresh their data accordingly
class ForegroundNotificationHandler {
  static final ForegroundNotificationHandler _instance =
      ForegroundNotificationHandler._internal();

  factory ForegroundNotificationHandler() => _instance;

  ForegroundNotificationHandler._internal();

  final StreamController<ForegroundNotificationEvent> _controller =
      StreamController<ForegroundNotificationEvent>.broadcast();

  /// Stream of foreground notification events
  Stream<ForegroundNotificationEvent> get notificationStream =>
      _controller.stream;

  /// Handle notification received in foreground
  void handleForegroundNotification(RemoteMessage message) {
    dev.log('Foreground notification received: ${message.notification?.title}');

    // Broadcast the event to all listeners
    _controller.add(
      ForegroundNotificationEvent(
        type: ForegroundNotificationEventType.notificationReceived,
        message: message,
      ),
    );
  }

  /// Dispose the stream controller
  void dispose() {
    _controller.close();
  }
}
