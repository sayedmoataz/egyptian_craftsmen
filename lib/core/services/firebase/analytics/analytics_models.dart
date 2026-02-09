/// User context model for analytics
class UserContext {
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;

  const UserContext({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  /// Convert to Firebase Analytics parameters
  Map<String, Object> toParameters() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
    };
  }

  @override
  String toString() => 'UserContext(userId: $userId, userName: $userName)';
}

/// Generic analytics event model
class AnalyticsEvent {
  final String name;
  final Map<String, Object>? parameters;
  final bool includeUserContext;

  const AnalyticsEvent({
    required this.name,
    this.parameters,
    this.includeUserContext = true,
  });

  @override
  String toString() => 'AnalyticsEvent(name: $name, params: $parameters)';
}

/// Screen view specific event
class ScreenViewEvent {
  final String screenName;
  final String? screenClass;
  final Map<String, Object>? parameters;

  const ScreenViewEvent({
    required this.screenName,
    this.screenClass,
    this.parameters,
  });

  @override
  String toString() => 'ScreenViewEvent(screen: $screenName, class: $screenClass)';
}
