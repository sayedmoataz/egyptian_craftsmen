import '../../../di/injection_container.dart';
import '../../caching/managers/app_prefs_manager.dart';
import '../crashlytics_logger.dart';
import 'analytics_models.dart';

/// Helper class to create pre-configured analytics events
class AnalyticsHelper {
  final AppPrefsManager _prefManager = sl<AppPrefsManager>();

  /// Get current user context from cache
  Future<UserContext?> getUserContext() async {
    try {
      final userId = await _prefManager.getUserId();
      final userName = await _prefManager.getUserName();
      final userEmail = await _prefManager.getUserEmail();
      final userPhone = await _prefManager.getUserPhone();

      // Return null if user not logged in
      if (userId == null || userId.isEmpty) return null;

      return UserContext(
        userId: userId,
        userName: userName ?? 'Unknown',
        userEmail: userEmail ?? 'Unknown',
        userPhone: userPhone ?? 'Unknown',
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        feature: 'Error getting user context',
      );
      return null;
    }
  }

  // ============== Authentication Events ==============

  AnalyticsEvent createLoginEvent({String? method}) {
    return AnalyticsEvent(
      name: 'user_login',
      parameters: {
        'login_method': ?method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  AnalyticsEvent createLogoutEvent() {
    return AnalyticsEvent(
      name: 'user_logout',
      parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  AnalyticsEvent createSignUpEvent({
    required String method,
    required String userId,
    required String userEmail,
    String? userName,
    String? userPhone,
  }) {
    return AnalyticsEvent(
      name: 'user_sign_up',
      includeUserContext: false, // Don't include - we're setting it now
      parameters: {
        'signup_method': method,
        'user_id': userId,
        'user_email': userEmail,
        'user_name': ?userName,
        'user_phone': ?userPhone,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // ============== E-commerce Events ==============

  AnalyticsEvent createPurchaseEvent({
    required String transactionId,
    required double value,
    required String currency,
    List<Map<String, Object>>? items,
  }) {
    return AnalyticsEvent(
      name: 'purchase',
      parameters: {
        'transaction_id': transactionId,
        'value': value,
        'currency': currency,
        'items': ?items,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  AnalyticsEvent createAddToCartEvent({
    required String itemId,
    required String itemName,
    required double price,
  }) {
    return AnalyticsEvent(
      name: 'add_to_cart',
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
        'price': price,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // ============== Generic Events ==============

  AnalyticsEvent createCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
    bool includeUserContext = true,
  }) {
    return AnalyticsEvent(
      name: eventName,
      includeUserContext: includeUserContext,
      parameters: {
        ...?parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  ScreenViewEvent createScreenViewEvent({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) {
    return ScreenViewEvent(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
      parameters: {
        ...?parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // ============== Feature-specific Events ==============

  /// Example: Search event
  AnalyticsEvent createSearchEvent({
    required String searchTerm,
    int? resultCount,
  }) {
    return AnalyticsEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        'result_count': ?resultCount,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  /// Example: Share event
  AnalyticsEvent createShareEvent({
    required String contentType,
    required String contentId,
    String? method,
  }) {
    return AnalyticsEvent(
      name: 'share',
      parameters: {
        'content_type': contentType,
        'content_id': contentId,
        'method': ?method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
