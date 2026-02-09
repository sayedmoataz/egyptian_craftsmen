import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aelanji/core/di/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../caching/managers/app_prefs_manager.dart';
import 'notification_models.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification channels
  static const String _systemChannelId = 'system_channel';
  static const String _systemChannelName = 'System Notifications';

  static const String _investorChannelId = 'investor_channel';
  static const String _investorChannelName = 'Investor Notifications';

  static const String _brokerChannelId = 'broker_channel';
  static const String _brokerChannelName = 'Broker Notifications';

  static const String _developerChannelId = 'developer_channel';
  static const String _developerChannelName = 'Developer Notifications';

  static Function(String error)? onError;

  /// Initialize the notification plugin with comprehensive setup
  static Future<bool> initialize({
    Function(String error)? errorCallback,
    Function(NotificationResponse)? onNotificationTap,
  }) async {
    try {
      onError = errorCallback;

      // request  permissions
      final bool permissionGranted = await _requestPermissions();
      if (!permissionGranted) {
        _handleError('Notification permissions not granted');
        return false;
      }

      // Initialize timezone data
      tz.initializeTimeZones();

      // Android initialization settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/launcher_icon',
      );

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings();

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
      );

      if (initialized ?? false) {
        await _createNotificationChannels();
        return true;
      }
      return false;
    } catch (e) {
      _handleError('Failed to initialize notifications: $e');
      return false;
    }
  }

  // request notification permissions
  static Future<bool> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Android 13+ permission
        final status = await Permission.notification.status;

        if (status.isDenied) {
          final PermissionStatus requestStatus = await Permission.notification
              .request();
          if (requestStatus != PermissionStatus.granted) {
            return false;
          }
        }

        // Schedule exact alarms permission for Android 12+
        if (await Permission.scheduleExactAlarm.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }
      } else if (Platform.isIOS) {
        // iOS permissions are handled in initialization
        final bool? granted = await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        return granted ?? false;
      }
      return true;
    } catch (e) {
      _handleError('Failed to request permissions: $e');
      return false;
    }
  }

  /// Create notification channels for Android
  static Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      try {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        // System channel
        await androidImplementation?.createNotificationChannel(
          const AndroidNotificationChannel(
            _systemChannelId,
            _systemChannelName,
            description: 'System notifications',
            importance: Importance.high,
          ),
        );

        // Investor channel
        await androidImplementation?.createNotificationChannel(
          const AndroidNotificationChannel(
            _investorChannelId,
            _investorChannelName,
            description: 'Investor notifications',
            importance: Importance.high,
          ),
        );

        // Broker channel
        await androidImplementation?.createNotificationChannel(
          const AndroidNotificationChannel(
            _brokerChannelId,
            _brokerChannelName,
            description: 'Broker notifications',
            importance: Importance.high,
          ),
        );

        // Developer channel
        await androidImplementation?.createNotificationChannel(
          const AndroidNotificationChannel(
            _developerChannelId,
            _developerChannelName,
            description: 'Developer notifications',
            importance: Importance.high,
          ),
        );
      } catch (e) {
        _handleError('Failed to create notification channels: $e');
      }
    }
  }

  /// Configure notification topics based on user role during login
  static Future<bool> configureUserTopics({
    required UserRole userRole,
    required String userId,
    bool enableGeneralNotifications = true,
    bool enableRoleSpecificNotifications = true,
  }) async {
    try {
      final topicConfig = NotificationTopicConfig(
        userId: userId,
        userRole: userRole,
        enableGeneralNotifications: enableGeneralNotifications,
        enableRoleSpecificNotifications: enableRoleSpecificNotifications,
        subscribedTopics: getTopicsForRole(userRole),
      );
      await _saveUserTopicConfig(topicConfig);
      return true;
    } catch (e) {
      _handleError('Failed to configure user topics: $e');
      return false;
    }
  }

  static List<NotificationTopic> getTopicsForRole(UserRole role) {
    switch (role) {
      case UserRole.investor:
        return [NotificationTopic.system, NotificationTopic.investor];
      case UserRole.broker:
        return [NotificationTopic.system, NotificationTopic.broker];
      case UserRole.developer:
        return [NotificationTopic.system, NotificationTopic.developer];
    }
  }

  /// Send role-specific notification
  static Future<bool> sendRoleBasedNotification({
    required int id,
    required String title,
    required String body,
    required UserRole targetRole,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    try {
      String channelId;
      String channelName;

      switch (targetRole) {
        case UserRole.investor:
          channelId = _investorChannelId;
          channelName = _investorChannelName;
          break;
        case UserRole.broker:
          channelId = _brokerChannelId;
          channelName = _brokerChannelName;
          break;
        case UserRole.developer:
          channelId = _developerChannelId;
          channelName = _developerChannelName;
          break;
      }

      final notificationDetails = _buildRoleBasedNotificationDetails(
        channelId: channelId,
        channelName: channelName,
        priority: priority,
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to send role-based notification: $e');
      return false;
    }
  }

  /// Send topic-specific notification
  static Future<bool> sendTopicNotification({
    required int id,
    required String title,
    required String body,
    required NotificationTopic topic,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    try {
      final channelInfo = _getChannelInfoForTopic(topic);

      final notificationDetails = _buildRoleBasedNotificationDetails(
        channelId: channelInfo.channelId,
        channelName: channelInfo.channelName,
        priority: priority,
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to send topic notification: $e');
      return false;
    }
  }

  static NotificationChannelInfo _getChannelInfoForTopic(
    NotificationTopic topic,
  ) {
    switch (topic) {
      case NotificationTopic.system:
        return NotificationChannelInfo(_systemChannelId, _systemChannelName);
      case NotificationTopic.investor:
        return NotificationChannelInfo(
          _investorChannelId,
          _investorChannelName,
        );
      case NotificationTopic.broker:
        return NotificationChannelInfo(_brokerChannelId, _brokerChannelName);
      case NotificationTopic.developer:
        return NotificationChannelInfo(
          _developerChannelId,
          _developerChannelName,
        );
    }
  }

  static Future<void> _saveUserTopicConfig(
    NotificationTopicConfig config,
  ) async {
    final AppPrefsManager _prefManager = sl<AppPrefsManager>();
    await _prefManager.setUserData(jsonEncode(config.toJson()));
    log('Saved topic configuration: \\${config.toJson()}');
  }

  static Future<NotificationTopicConfig?> loadUserTopicConfig() async {
    try {
      final AppPrefsManager _prefManager = sl<AppPrefsManager>();
      final configJson = await _prefManager.getUserData();
      if (configJson != null && configJson.isNotEmpty) {
        final jsonMap = jsonDecode(configJson);
        return NotificationTopicConfig.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      _handleError('Failed to load user topic configuration: $e');
      return null;
    }
  }

  /// Show an immediate notification
  static Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
    String? largeIcon,
    String? bigPicture,
  }) async {
    try {
      final notificationDetails = _buildNotificationDetails(
        priority: priority,
        largeIcon: largeIcon,
        bigPicture: bigPicture,
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to show notification: $e');
      return false;
    }
  }

  /// Schedule a notification for a specific time
  static Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
    String? largeIcon,
    String? bigPicture,
  }) async {
    try {
      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
        _handleError('Cannot schedule notification in the past');
        return false;
      }

      final notificationDetails = _buildNotificationDetails(
        priority: priority,
        largeIcon: largeIcon,
        bigPicture: bigPicture,
      );

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to schedule notification: $e');
      return false;
    }
  }

  /// Schedule a daily recurring notification
  static Future<bool> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    try {
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        _handleError('Invalid time: hour must be 0-23, minute must be 0-59');
        return false;
      }

      final now = tz.TZDateTime.now(tz.local);
      var scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the time is in the past today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      final notificationDetails = _buildNotificationDetails(priority: priority);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to schedule daily notification: $e');
      return false;
    }
  }

  /// Schedule a weekly recurring notification
  static Future<bool> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday, // 1 = Monday, 7 = Sunday
    required int hour,
    required int minute,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    try {
      if (weekday < 1 || weekday > 7) {
        _handleError('Invalid weekday: must be 1-7 (1=Monday, 7=Sunday)');
        return false;
      }

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        _handleError('Invalid time: hour must be 0-23, minute must be 0-59');
        return false;
      }

      final scheduledTime = _nextInstanceOfWeekday(weekday, hour, minute);

      final notificationDetails = _buildNotificationDetails(priority: priority);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to schedule weekly notification: $e');
      return false;
    }
  }

  /// Show a notification with action buttons
  static Future<bool> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
    required List<AndroidNotificationAction> actions,
    String? payload,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        _systemChannelId,
        _systemChannelName,
        channelDescription: 'Notifications with actions',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        actions: actions,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      return true;
    } catch (e) {
      _handleError('Failed to show notification with actions: $e');
      return false;
    }
  }

  /// Cancel a specific notification
  static Future<bool> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      return true;
    } catch (e) {
      _handleError('Failed to cancel notification: $e');
      return false;
    }
  }

  /// Cancel all notifications
  static Future<bool> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      return true;
    } catch (e) {
      _handleError('Failed to cancel all notifications: $e');
      return false;
    }
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      _handleError('Failed to get pending notifications: $e');
      return [];
    }
  }

  /// Get active notifications (Android only)
  static Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await androidImplementation?.getActiveNotifications() ?? [];
      }
      return [];
    } catch (e) {
      _handleError('Failed to get active notifications: $e');
      return [];
    }
  }

  /// Build notification details based on priority and features
  static NotificationDetails _buildNotificationDetails({
    required NotificationPriority priority,
    String? largeIcon,
    String? bigPicture,
  }) {
    String channelId;
    String channelName;
    Importance importance;
    Priority androidPriority;

    switch (priority) {
      case NotificationPriority.low:
        channelId = _systemChannelId;
        channelName = _systemChannelName;
        importance = Importance.low;
        androidPriority = Priority.low;
        break;
      case NotificationPriority.normal:
        channelId = _systemChannelId;
        channelName = _systemChannelName;
        importance = Importance.defaultImportance;
        androidPriority = Priority.defaultPriority;
        break;
      case NotificationPriority.high:
        channelId = _systemChannelId;
        channelName = _systemChannelName;
        importance = Importance.high;
        androidPriority = Priority.high;
        break;
      case NotificationPriority.max:
        channelId = _systemChannelId;
        channelName = _systemChannelName;
        importance = Importance.max;
        androidPriority = Priority.max;
        break;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: importance,
      priority: androidPriority,
      icon: '@mipmap/launcher_icon',
      largeIcon: largeIcon != null ? FilePathAndroidBitmap(largeIcon) : null,
      styleInformation: bigPicture != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicture),
              hideExpandedLargeIcon: true,
            )
          : null,
      enableVibration: priority.index >= NotificationPriority.high.index,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  /// Build role-based notification details
  static NotificationDetails _buildRoleBasedNotificationDetails({
    required String channelId,
    required String channelName,
    required NotificationPriority priority,
  }) {
    Importance importance;
    Priority androidPriority;

    switch (priority) {
      case NotificationPriority.low:
        importance = Importance.low;
        androidPriority = Priority.low;
        break;
      case NotificationPriority.normal:
        importance = Importance.defaultImportance;
        androidPriority = Priority.defaultPriority;
        break;
      case NotificationPriority.high:
        importance = Importance.high;
        androidPriority = Priority.high;
        break;
      case NotificationPriority.max:
        importance = Importance.max;
        androidPriority = Priority.max;
        break;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: importance,
      priority: androidPriority,
      icon: '@mipmap/launcher_icon',
      enableVibration: priority.index >= NotificationPriority.high.index,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  /// Calculate next instance of a specific weekday and time
  static tz.TZDateTime _nextInstanceOfWeekday(
    int weekday,
    int hour,
    int minute,
  ) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Handle errors consistently
  static void _handleError(String error) {
    log('LocalNotificationService Error: $error');
    onError?.call(error);
  }

  static Future<void> initializeFCM({
    Function(RemoteMessage message)? onTap,
    Function(RemoteMessage message)? onForegroundMessage,
  }) async {
    await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null) {
        await LocalNotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: notification.title ?? 'Notification',
          body: notification.body ?? '',
          payload: message.data.isNotEmpty ? message.data.toString() : null,
        );

        // Call the foreground message callback to refresh data
        if (onForegroundMessage != null) {
          onForegroundMessage(message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (onTap != null) {
        onTap(message);
      } else {
        log('Notification tapped (background): ${message.data}');
      }
    });
  }

  static Future<void> handleInitialMessage({
    Function(RemoteMessage message)? onTap,
  }) async {
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      if (onTap != null) {
        onTap(initialMessage);
      } else {
        log('Notification tapped (terminated): ${initialMessage.data}');
      }
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null) {
    await LocalNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title ?? 'Notification',
      body: notification.body ?? '',
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }
}
