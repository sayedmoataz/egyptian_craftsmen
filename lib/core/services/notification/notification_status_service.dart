import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';


import '../../network/network_info.dart';
import '../caching/managers/app_prefs_manager.dart';
import 'notification_helper.dart';
import 'notification_models.dart';

class NotificationStatusService extends ChangeNotifier {
  final NotificationHelper _notificationHelper;
  final NetworkInfo _networkInfo;
  final AppPrefsManager _prefManager;

  NotificationStatus _currentStatus = NotificationStatus.disabled;
  List<NotificationError> _recentErrors = [];
  bool _isMonitoring = false;
  Timer? _statusCheckTimer;
  Timer? _errorCheckTimer;

  NotificationStatusService(this._notificationHelper, this._networkInfo, this._prefManager);

  NotificationStatus get currentStatus => _currentStatus;
  List<NotificationError> get recentErrors => List.unmodifiable(_recentErrors);
  bool get isMonitoring => _isMonitoring;

  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    log('Starting notification status monitoring');

    await _checkStatus();

    _statusCheckTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _checkStatus();
    });

    _errorCheckTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkErrors();
    });

    _networkInfo.onStatusChange.listen((_) {
      _checkStatus();
    });

    notifyListeners();
  }

  void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _statusCheckTimer?.cancel();
    _errorCheckTimer?.cancel();
    _statusCheckTimer = null;
    _errorCheckTimer = null;

    log('Stopped notification status monitoring');
    notifyListeners();
  }

  Future<void> _checkStatus() async {
    try {
      final newStatus = await _notificationHelper.getNotificationStatus();

      if (newStatus != _currentStatus) {
        log('Notification status changed: ${_currentStatus.name} -> ${newStatus.name}');
        _currentStatus = newStatus;
        notifyListeners();
      }
    } catch (e) {
      log('Error checking notification status: $e');
      _currentStatus = NotificationStatus.disabled;
      notifyListeners();
    }
  }

  Future<void> _checkErrors() async {
    try {
      final errors = await _notificationHelper.getRecentErrors();

      if (_hasNewErrors(errors)) {
        _recentErrors = errors;
        notifyListeners();

        final newErrors =
            errors
                .where(
                  (error) =>
                      !_recentErrors.any(
                        (existing) => existing.timestamp == error.timestamp && existing.message == error.message,
                      ),
                )
                .toList();

        for (final error in newErrors) {
          log('New notification error: ${error.type.name} - ${error.message}');
        }
      }
    } catch (e) {
      log('Error checking notification errors: $e');
    }
  }

  bool _hasNewErrors(List<NotificationError> errors) {
    if (errors.length != _recentErrors.length) return true;

    for (int i = 0; i < errors.length; i++) {
      if (errors[i].timestamp != _recentErrors[i].timestamp || errors[i].message != _recentErrors[i].message) {
        return true;
      }
    }
    return false;
  }

  String getStatusDescription() {
    switch (_currentStatus) {
      case NotificationStatus.enabled:
        return 'Notifications are working properly';
      case NotificationStatus.disabled:
        return 'Notifications are disabled';
      case NotificationStatus.permissionDenied:
        return 'Notification permissions are required';
      case NotificationStatus.fcmUnavailable:
        return 'Firebase Cloud Messaging is unavailable';
      case NotificationStatus.offline:
        return 'No internet connection for notifications';
    }
  }

  String getStatusIcon() {
    switch (_currentStatus) {
      case NotificationStatus.enabled:
        return '✅';
      case NotificationStatus.disabled:
        return '❌';
      case NotificationStatus.permissionDenied:
        return '🔒';
      case NotificationStatus.fcmUnavailable:
        return '🔥';
      case NotificationStatus.offline:
        return '📡';
    }
  }

  bool get isWorking => _currentStatus == NotificationStatus.enabled;

  bool get hasErrors => _recentErrors.isNotEmpty;

  NotificationError? get latestError => _recentErrors.isNotEmpty ? _recentErrors.last : null;

  List<NotificationError> getErrorsByType(NotificationErrorType type) {
    return _recentErrors.where((error) => error.type == type).toList();
  }

  void clearErrors() {
    _recentErrors.clear();
    notifyListeners();
  }

  Future<void> forceStatusCheck() async {
    await _checkStatus();
  }

  Future<bool> retryFailedOperations() async {
    try {
      final success = await _notificationHelper.retryFailedOperations();
      if (success) {
        await _checkStatus();
      }
      return success;
    } catch (e) {
      log('Error retrying failed operations: $e');
      return false;
    }
  }

  Map<String, dynamic> getHealthSummary() {
    return {
      'status': _currentStatus.name,
      'isWorking': isWorking,
      'hasErrors': hasErrors,
      'errorCount': _recentErrors.length,
      'latestError': latestError?.toJson(),
      'isMonitoring': _isMonitoring,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
