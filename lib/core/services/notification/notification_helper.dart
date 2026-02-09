import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../network/network_info.dart';
import '../caching/managers/app_prefs_manager.dart';
import 'local_notification_services.dart';
import 'notification_models.dart';

abstract class INotificationHelper {
  Future<bool> initialize({
    Function(String error)? errorCallback,
    Function(NotificationResponse)? onNotificationTap,
  });

  Future<bool> configureUserTopics({
    required UserRole userRole,
    required String userId,
    bool enableGeneralNotifications,
    bool enableRoleSpecificNotifications,
  });

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Future<void> saveUserTopicConfig(NotificationTopicConfig config);

  Future<NotificationTopicConfig?> loadUserTopicConfig();

  Future<bool> handleRoleChange(UserRole newRole, String userId);

  Future<bool> handleLogout();

  Future<bool> handleDeleteAccount();

  Future<bool> retryFailedOperations();

  Future<NotificationStatus> getNotificationStatus();

  Future<List<NotificationError>> getRecentErrors();
}

class NotificationHelper implements INotificationHelper {
  final FirebaseMessaging _firebaseMessaging;
  final AppPrefsManager _prefManager;
  final NetworkInfo _networkInfo;

  static const NotificationRetryConfig _retryConfig = NotificationRetryConfig();

  final List<Map<String, dynamic>> _pendingOperations = [];
  static const String _pendingOperationsKey = 'pending_notification_operations';

  final List<NotificationError> _recentErrors = [];
  static const int _maxErrorHistory = 10;

  NotificationHelper(
    this._firebaseMessaging,
    this._prefManager,
    this._networkInfo,
  );

  @override
  Future<bool> initialize({
    Function(String error)? errorCallback,
    Function(NotificationResponse)? onNotificationTap,
  }) async {
    try {
      final bool initialized = await LocalNotificationService.initialize(
        errorCallback: errorCallback,
        onNotificationTap: onNotificationTap,
      );

      if (initialized) {
        await _loadPendingOperations();
        if (await _networkInfo.isConnected) {
          await retryFailedOperations();
        }
        return true;
      } else {
        _addError(
          NotificationErrorType.initializationError,
          'Failed to initialize local notifications',
        );
        return false;
      }
    } catch (e) {
      _addError(
        NotificationErrorType.initializationError,
        'Initialization error: $e',
      );
      return false;
    }
  }

  @override
  Future<bool> configureUserTopics({
    required UserRole userRole,
    required String userId,
    bool enableGeneralNotifications = true,
    bool enableRoleSpecificNotifications = true,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        _addError(
          NotificationErrorType.networkError,
          'No internet connection for topic configuration',
        );
        return await _queueOperation('configureUserTopics', {
          'userRole': userRole.name,
          'userId': userId,
          'enableGeneralNotifications': enableGeneralNotifications,
          'enableRoleSpecificNotifications': enableRoleSpecificNotifications,
        });
      }

      final topics = LocalNotificationService.getTopicsForRole(userRole);
      dev.log('topics is: $topics');
      dev.log('userRole is: $userRole');
      final List<String> failedTopics = [];

      for (final topic in topics) {
        try {
          await _subscribeToTopicWithRetry(topic.name);
        } catch (e) {
          failedTopics.add(topic.name);
          _addError(
            NotificationErrorType.topicSubscriptionError,
            'Failed to subscribe to topic ${topic.name}: $e',
          );
        }
      }

      final config = NotificationTopicConfig(
        userId: userId,
        userRole: userRole,
        enableGeneralNotifications: enableGeneralNotifications,
        enableRoleSpecificNotifications: enableRoleSpecificNotifications,
        subscribedTopics: topics
            .where((topic) => !failedTopics.contains(topic.name))
            .toList(),
        status: failedTopics.isEmpty
            ? NotificationStatus.enabled
            : NotificationStatus.fcmUnavailable,
        recentErrors: _recentErrors.take(_maxErrorHistory).toList(),
      );

      await saveUserTopicConfig(config);

      if (failedTopics.isNotEmpty) {
        dev.log('Some topics failed to subscribe: $failedTopics');
        return false;
      }

      return true;
    } catch (e) {
      _addError(NotificationErrorType.unknown, 'Topic configuration error: $e');
      return false;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _subscribeToTopicWithRetry(topic);
  }

  Future<void> _subscribeToTopicWithRetry(String topic) async {
    int attempt = 1;
    Exception? lastException;

    while (attempt <= _retryConfig.maxRetries) {
      try {
        await _firebaseMessaging.subscribeToTopic(topic);
        dev.log('Successfully subscribed to FCM topic: $topic');
        return;
      } catch (e) {
        lastException = e as Exception;
        dev.log('Attempt $attempt failed to subscribe to topic $topic: $e');

        if (attempt < _retryConfig.maxRetries) {
          final delay = _retryConfig.getDelayForAttempt(attempt);
          await Future.delayed(delay);
        }
        attempt++;
      }
    }

    final error = NotificationError(
      type: NotificationErrorType.topicSubscriptionError,
      message:
          'Failed to subscribe to topic $topic after ${_retryConfig.maxRetries} attempts: $lastException',
      additionalData: {'topic': topic, 'attempts': _retryConfig.maxRetries},
    );
    _addErrorObject(error);
    throw lastException ?? Exception('Failed to subscribe to topic $topic');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      dev.log('Successfully unsubscribed from FCM topic: $topic');
    } catch (e) {
      _addError(
        NotificationErrorType.topicSubscriptionError,
        'Failed to unsubscribe from topic $topic: $e',
      );
    }
  }

  @override
  Future<void> saveUserTopicConfig(NotificationTopicConfig config) async {
    try {
      await _prefManager.setUserData(jsonEncode(config.toJson()));
      dev.log('Saved user topic config to SharedPreferences');
    } catch (e) {
      _addError(
        NotificationErrorType.unknown,
        'Failed to save topic config: $e',
      );
    }
  }

  @override
  Future<NotificationTopicConfig?> loadUserTopicConfig() async {
    try {
      final jsonString = await _prefManager.getUserData();
      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonMap = jsonDecode(jsonString);
        return NotificationTopicConfig.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      _addError(
        NotificationErrorType.unknown,
        'Failed to load topic config: $e',
      );
      return null;
    }
  }

  @override
  Future<bool> handleRoleChange(UserRole newRole, String userId) async {
    try {
      dev.log('Handling role change to: ${newRole.name}');

      final currentConfig = await loadUserTopicConfig();
      if (currentConfig == null) {
        return await configureUserTopics(userRole: newRole, userId: userId);
      }

      final oldTopics = currentConfig.subscribedTopics
          .where((topic) => topic.isRoleSpecific(currentConfig.userRole))
          .toList();

      for (final topic in oldTopics) {
        await unsubscribeFromTopic(topic.name);
      }

      final newTopics = LocalNotificationService.getTopicsForRole(
        newRole,
      ).where((topic) => topic.isRoleSpecific(newRole)).toList();

      for (final topic in newTopics) {
        await subscribeToTopic(topic.name);
      }

      final updatedConfig = currentConfig.copyWith(
        userRole: newRole,
        subscribedTopics: [
          ...currentConfig.subscribedTopics.where(
            (topic) => !topic.isRoleSpecific(currentConfig.userRole),
          ),
          ...newTopics,
        ],
        status: NotificationStatus.enabled,
      );

      await saveUserTopicConfig(updatedConfig);
      return true;
    } catch (e) {
      _addError(NotificationErrorType.unknown, 'Role change error: $e');
      return false;
    }
  }

  @override
  Future<bool> handleLogout() async {
    try {
      dev.log('Handling logout - unsubscribing from all topics');
      debugTopicSubscriptions();

      final config = await loadUserTopicConfig();
      if (config != null) {
        for (final topic in config.subscribedTopics) {
          await unsubscribeFromTopic(topic.name);
        }

        await _prefManager.removeUserData();

        _pendingOperations.clear();
        await _savePendingOperations();
      }

      await LocalNotificationService.cancelAllNotifications();

      return true;
    } catch (e) {
      _addError(NotificationErrorType.unknown, 'Logout error: $e');
      return false;
    }
  }

  @override
  Future<bool> handleDeleteAccount() async {
    try {
      dev.log('Handling account deletion - cleaning up notifications');

      final success = await handleLogout();

      await _clearAllNotificationData();

      return success;
    } catch (e) {
      _addError(NotificationErrorType.unknown, 'Account deletion error: $e');
      return false;
    }
  }

  @override
  Future<bool> retryFailedOperations() async {
    if (_pendingOperations.isEmpty) return true;

    dev.log('Retrying ${_pendingOperations.length} pending operations');

    final List<Map<String, dynamic>> successfulOperations = [];
    final List<Map<String, dynamic>> failedOperations = [];

    for (final operation in _pendingOperations) {
      try {
        final success = await _executeOperation(operation);
        if (success) {
          successfulOperations.add(operation);
        } else {
          failedOperations.add(operation);
        }
      } catch (e) {
        failedOperations.add(operation);
        _addError(NotificationErrorType.unknown, 'Retry operation failed: $e');
      }
    }

    _pendingOperations.clear();
    _pendingOperations.addAll(failedOperations);
    await _savePendingOperations();

    dev.log(
      'Retry completed: ${successfulOperations.length} successful, ${failedOperations.length} failed',
    );
    return failedOperations.isEmpty;
  }

  @override
  Future<NotificationStatus> getNotificationStatus() async {
    try {
      if (!await _networkInfo.isConnected) {
        return NotificationStatus.offline;
      }

      try {
        final token = await _firebaseMessaging.getToken();
        if (token == null) {
          return NotificationStatus.fcmUnavailable;
        }
      } catch (e) {
        return NotificationStatus.fcmUnavailable;
      }

      final permissionStatus = await _checkNotificationPermission();
      if (!permissionStatus) {
        return NotificationStatus.permissionDenied;
      }

      final config = await loadUserTopicConfig();
      if (config != null) {
        return config.status;
      }

      return NotificationStatus.enabled;
    } catch (e) {
      _addError(NotificationErrorType.unknown, 'Status check error: $e');
      return NotificationStatus.disabled;
    }
  }

  @override
  Future<List<NotificationError>> getRecentErrors() async {
    return List.unmodifiable(_recentErrors);
  }

  Future<Map<String, dynamic>> debugTopicSubscriptions() async {
    try {
      final config = await loadUserTopicConfig();
      final currentTopics =
          config?.subscribedTopics.map((t) => t.name).toList() ?? [];

      final token = await _firebaseMessaging.getToken();

      return {
        'userId': config?.userId,
        'userRole': config?.userRole.name,
        'subscribedTopics': currentTopics,
        'fcmToken': token,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  Future<bool> validateAndFixTopicSubscriptions() async {
    try {
      dev.log('Validating topic subscriptions...');

      final config = await loadUserTopicConfig();
      if (config == null) {
        dev.log('No topic configuration found');
        return false;
      }

      final expectedTopics = LocalNotificationService.getTopicsForRole(
        config.userRole,
      );
      final currentTopics = config.subscribedTopics;

      dev.log(
        'Expected topics for ${config.userRole.name}: ${expectedTopics.map((t) => t.name)}',
      );
      dev.log('Current topics: ${currentTopics.map((t) => t.name)}');

      final missingTopics = expectedTopics
          .where((topic) => !currentTopics.contains(topic))
          .toList();
      final extraTopics = currentTopics
          .where((topic) => !expectedTopics.contains(topic))
          .toList();

      if (missingTopics.isNotEmpty || extraTopics.isNotEmpty) {
        dev.log('Topic mismatch detected. Fixing...');

        for (final topic in extraTopics) {
          await unsubscribeFromTopic(topic.name);
          dev.log('Unsubscribed from extra topic: ${topic.name}');
        }

        for (final topic in missingTopics) {
          await subscribeToTopic(topic.name);
          dev.log('Subscribed to missing topic: ${topic.name}');
        }

        final fixedConfig = config.copyWith(
          subscribedTopics: expectedTopics,
          status: NotificationStatus.enabled,
        );
        await saveUserTopicConfig(fixedConfig);

        dev.log('Topic subscriptions fixed successfully');
        return true;
      } else {
        dev.log('Topic subscriptions are correct');
        return true;
      }
    } catch (e) {
      dev.log('Error validating topic subscriptions: $e');
      _addError(
        NotificationErrorType.topicSubscriptionError,
        'Validation failed: $e',
      );
      return false;
    }
  }

  Future<bool> resetTopicSubscriptions() async {
    try {
      dev.log('Resetting all topic subscriptions...');

      final config = await loadUserTopicConfig();
      if (config != null) {
        for (final topic in config.subscribedTopics) {
          await unsubscribeFromTopic(topic.name);
          dev.log('Unsubscribed from: ${topic.name}');
        }
      }

      await Future.delayed(const Duration(seconds: 2));

      if (config != null) {
        final success = await configureUserTopics(
          userRole: config.userRole,
          userId: config.userId,
          enableGeneralNotifications: config.enableGeneralNotifications,
          enableRoleSpecificNotifications:
              config.enableRoleSpecificNotifications,
        );

        dev.log('Topic reset completed. Success: $success');
        return success;
      }

      return false;
    } catch (e) {
      dev.log('Error resetting topic subscriptions: $e');
      _addError(
        NotificationErrorType.topicSubscriptionError,
        'Reset failed: $e',
      );
      return false;
    }
  }

  Future<bool> _queueOperation(
    String operationType,
    Map<String, dynamic> data,
  ) async {
    final operation = {
      'type': operationType,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _pendingOperations.add(operation);
    await _savePendingOperations();

    dev.log('Queued operation: $operationType');
    return false;
  }

  Future<bool> _executeOperation(Map<String, dynamic> operation) async {
    final operationType = operation['type'] as String;
    final data = operation['data'] as Map<String, dynamic>;

    switch (operationType) {
      case 'configureUserTopics':
        return await configureUserTopics(
          userRole: UserRole.values.firstWhere(
            (role) => role.name == data['userRole'],
          ),
          userId: data['userId'],
          enableGeneralNotifications: data['enableGeneralNotifications'],
          enableRoleSpecificNotifications:
              data['enableRoleSpecificNotifications'],
        );
      case 'subscribeToTopic':
        await subscribeToTopic(data['topic']);
        return true;
      case 'unsubscribeFromTopic':
        await unsubscribeFromTopic(data['topic']);
        return true;
      default:
        dev.log('Unknown operation type: $operationType');
        return false;
    }
  }

  Future<void> _loadPendingOperations() async {
    try {
      final operations = await _prefManager.getPendingOperations();
      if (operations != null && operations.isNotEmpty) {
        _pendingOperations.clear();
        _pendingOperations.addAll(operations.cast<Map<String, dynamic>>());
        dev.log('Loaded ${_pendingOperations.length} pending operations');
      }
    } catch (e) {
      dev.log('Failed to load pending operations: $e');
    }
  }

  Future<void> _savePendingOperations() async {
    try {
      await _prefManager.setPendingOperations(_pendingOperations);
    } catch (e) {
      dev.log('Failed to save pending operations: $e');
    }
  }

  Future<void> _clearAllNotificationData() async {
    try {
      await _prefManager.removeUserData();
      await _prefManager.removePendingOperations();

      _recentErrors.clear();

      _pendingOperations.clear();
    } catch (e) {
      dev.log('Failed to clear notification data: $e');
    }
  }

  Future<bool> _checkNotificationPermission() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.notification.status;
        return status.isGranted;
      } else if (Platform.isIOS) {
        return true;
      }
      return false;
    } catch (e) {
      dev.log('Permission check error: $e');
      return false;
    }
  }

  void _addError(
    NotificationErrorType type,
    String message, [
    Map<String, dynamic>? additionalData,
  ]) {
    final error = NotificationError(
      type: type,
      message: message,
      additionalData: additionalData,
    );
    _addErrorObject(error);
  }

  void _addErrorObject(NotificationError error) {
    _recentErrors.add(error);

    if (_recentErrors.length > _maxErrorHistory) {
      _recentErrors.removeAt(0);
    }

    dev.log('Notification error: ${error.type.name} - ${error.message}');
  }

  static Future<String?> getAssetImagePath(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = assetPath.split('/').last;
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      dev.log('Error converting asset to file: $e');
      return null;
    }
  }
}
