import 'dart:math' as math;

/// User roles
enum UserRole { investor, broker, developer }

/// Notification topics
enum NotificationTopic { system, investor, broker, developer }

/// priority levels
enum NotificationPriority { low, normal, high, max }

enum NotificationErrorType {
  permissionDenied,
  fcmFailure,
  networkError,
  initializationError,
  topicSubscriptionError,
  unknown,
}

enum NotificationStatus { enabled, disabled, permissionDenied, fcmUnavailable, offline }

class NotificationError {
  final NotificationErrorType type;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  NotificationError({required this.type, required this.message, DateTime? timestamp, this.additionalData})
    : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  factory NotificationError.fromJson(Map<String, dynamic> json) {
    return NotificationError(
      type: NotificationErrorType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => NotificationErrorType.unknown,
      ),
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }
}

class NotificationRetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;

  const NotificationRetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
  });

  Duration getDelayForAttempt(int attempt) {
    final delay = initialDelay * (math.pow(backoffMultiplier, attempt - 1));
    return delay > maxDelay ? maxDelay : delay;
  }
}

/// topic configuration (user data in pref  manager)
class NotificationTopicConfig {
  final String userId;
  final UserRole userRole;
  final bool enableGeneralNotifications;
  final bool enableRoleSpecificNotifications;
  final List<NotificationTopic> subscribedTopics;
  final DateTime createdAt;
  final NotificationStatus status;
  final List<NotificationError> recentErrors;

  NotificationTopicConfig({
    required this.userId,
    required this.userRole,
    required this.enableGeneralNotifications,
    required this.enableRoleSpecificNotifications,
    required this.subscribedTopics,
    DateTime? createdAt,
    this.status = NotificationStatus.enabled,
    this.recentErrors = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  NotificationTopicConfig copyWith({
    String? userId,
    UserRole? userRole,
    bool? enableGeneralNotifications,
    bool? enableRoleSpecificNotifications,
    List<NotificationTopic>? subscribedTopics,
    DateTime? createdAt,
    NotificationStatus? status,
    List<NotificationError>? recentErrors,
  }) {
    return NotificationTopicConfig(
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      enableGeneralNotifications: enableGeneralNotifications ?? this.enableGeneralNotifications,
      enableRoleSpecificNotifications: enableRoleSpecificNotifications ?? this.enableRoleSpecificNotifications,
      subscribedTopics: subscribedTopics ?? this.subscribedTopics,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      recentErrors: recentErrors ?? this.recentErrors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userRole': userRole.name,
      'enableGeneralNotifications': enableGeneralNotifications,
      'enableRoleSpecificNotifications': enableRoleSpecificNotifications,
      'subscribedTopics': subscribedTopics.map((topic) => topic.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'recentErrors': recentErrors.map((error) => error.toJson()).toList(),
    };
  }

  factory NotificationTopicConfig.fromJson(Map<String, dynamic> json) {
    return NotificationTopicConfig(
      userId: json['userId'] as String,
      userRole: UserRole.values.firstWhere((role) => role.name == json['userRole'], orElse: () => UserRole.investor),
      enableGeneralNotifications: json['enableGeneralNotifications'] as bool,
      enableRoleSpecificNotifications: json['enableRoleSpecificNotifications'] as bool,
      subscribedTopics:
          (json['subscribedTopics'] as List<dynamic>)
              .map(
                (topicName) => NotificationTopic.values.firstWhere(
                  (topic) => topic.name == topicName,
                  orElse: () => NotificationTopic.system,
                ),
              )
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: NotificationStatus.values.firstWhere(
        (status) => status.name == (json['status'] as String? ?? 'enabled'),
        orElse: () => NotificationStatus.enabled,
      ),
      recentErrors:
          (json['recentErrors'] as List<dynamic>?)
              ?.map((errorJson) => NotificationError.fromJson(errorJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Helper class for notification channel information
class NotificationChannelInfo {
  final String channelId;
  final String channelName;

  NotificationChannelInfo(this.channelId, this.channelName);
}

/// Extension methods for UserRole
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.investor:
        return 'investor';
      case UserRole.broker:
        return 'broker';
      case UserRole.developer:
        return 'developer';
    }
  }

  String get description {
    switch (this) {
      case UserRole.investor:
        return 'Receives investment updates, market alerts, and portfolio notifications';
      case UserRole.broker:
        return 'Receives broker activities, client updates, and transaction alerts';
      case UserRole.developer:
        return 'Receives system alerts, maintenance notifications, and technical updates';
    }
  }
}

/// Extension methods for NotificationTopic
extension NotificationTopicExtension on NotificationTopic {
  String get displayName {
    switch (this) {
      case NotificationTopic.system:
        return 'system';
      case NotificationTopic.investor:
        return 'investor';
      case NotificationTopic.broker:
        return 'broker';
      case NotificationTopic.developer:
        return 'developer';
    }
  }

  bool isRoleSpecific(UserRole role) {
    switch (this) {
      case NotificationTopic.system:
        return false;
      case NotificationTopic.investor:
        return role == UserRole.investor;
      case NotificationTopic.broker:
        return role == UserRole.broker;
      case NotificationTopic.developer:
        return role == UserRole.developer;
    }
  }
}

extension DurationExtension on Duration {
  Duration operator *(double multiplier) {
    return Duration(milliseconds: (inMilliseconds * multiplier).round());
  }
}
