class CacheKeys {
  // ========== SECURE KEYS (Sensitive Data) ==========
  static const String token = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String password = 'user_password'; // Only if "Remember Me"

  // ========== NON-SECURE KEYS (General Data) ==========
  // Auth & User
  static const String userData = 'userData';
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userWhatsapp = 'user_whatsapp';
  static const String username = 'username';

  // App Settings
  static const String language = 'app_language';
  static const String firstLaunch = 'first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String rememberMe = 'remember_me';

  // App Update
  static const String appNeedUpdate = 'app_need_update';
  static const String appOldVersion = 'app_old_version';
  static const String lastForceUpdateMilliSeconds = 'last_force_update_ms';

  // Patterns
  static const String showcasePrefix = 'showcase_';

  // Notification
  static const String pendingOperations = 'pending_operations';
  static const String lastNotificationOpenedTime =
      'last_notification_opened_time';

  // Countries
  static const String countriesData = 'countries_data';
  static const String countriesTimestamp = 'countries_timestamp';
  static const String selectedCountryId = 'selected_country_id';
  static const String dialCode = 'dial_code';
  static const String isoCode = 'iso_code';
  static const String currency = 'currency';

  // Recently Viewed
  static const String recentlyViewedProducts = 'recently_viewed_products';
  static const String recentlyViewedCommercial = 'recently_viewed_commercial';

  // Favorites
  static const String favoriteProductIds = 'favorite_product_ids';

  // Reports
  static const String reportedProductIds = 'reported_product_ids';
}
