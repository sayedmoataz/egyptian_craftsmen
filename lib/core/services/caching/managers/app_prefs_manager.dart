import 'dart:convert';

import '../cache_keys.dart';
import 'cache_manager.dart';

class AppPrefsManager {
  final CacheManager _cache;

  AppPrefsManager(this._cache);

  // ========== AUTHENTICATION (Secure) ==========

  Future<void> setToken(String token) =>
      _cache.writeSecure(CacheKeys.token, token);
  Future<String?> getToken() => _cache.readSecure(CacheKeys.token);

  Future<void> setRefreshToken(String token) =>
      _cache.writeSecure(CacheKeys.refreshToken, token);
  Future<String?> getRefreshToken() =>
      _cache.readSecure(CacheKeys.refreshToken);

  // Only store password if "Remember Me" is enabled
  Future<void> setPassword(String password) =>
      _cache.writeSecure(CacheKeys.password, password);
  Future<String?> getPassword() => _cache.readSecure(CacheKeys.password);

  // ========== USER INFO ==========

  Future<void> setUserId(String id) => _cache.write(CacheKeys.userId, id);
  Future<String?> getUserId() async =>
      await _cache.read<String>(CacheKeys.userId);
  String? get userId => _cache.readSync<String>(CacheKeys.userId);

  Future<void> setUserName(String name) =>
      _cache.write(CacheKeys.userName, name);
  Future<String?> getUserName() async =>
      await _cache.read<String>(CacheKeys.userName);

  Future<void> setUserEmail(String email) =>
      _cache.write(CacheKeys.userEmail, email);
  Future<String?> getUserEmail() async =>
      await _cache.read<String>(CacheKeys.userEmail);

  Future<void> setUserPhone(String phone) =>
      _cache.write(CacheKeys.userPhone, phone);
  Future<String?> getUserPhone() async =>
      await _cache.read<String>(CacheKeys.userPhone);

  Future<void> setUserWhatsapp(String phone) =>
      _cache.write(CacheKeys.userWhatsapp, phone);
  Future<String?> getUserWhatsapp() async =>
      await _cache.read<String>(CacheKeys.userWhatsapp);

  // ========== NOTIFICATION ==========

  Future<void> setUserData(String userData) =>
      _cache.write(CacheKeys.userData, userData);
  Future<String?> getUserData() async =>
      await _cache.read<String>(CacheKeys.userData);
  Future<void> removeUserData() => _cache.delete(CacheKeys.userData);

  Future<void> setPendingOperations(List<dynamic> operations) =>
      _cache.write(CacheKeys.pendingOperations, jsonEncode(operations));
  Future<List<dynamic>?> getPendingOperations() async =>
      await _cache.read<List<dynamic>>(CacheKeys.pendingOperations);
  Future<void> removePendingOperations() =>
      _cache.delete(CacheKeys.pendingOperations);

  Future<void> setLastNotificationOpenedTime(DateTime time) => _cache.write(
    CacheKeys.lastNotificationOpenedTime,
    time.toIso8601String(),
  );

  Future<DateTime?> getLastNotificationOpenedTime() async {
    final timeStr = await _cache.read<String>(
      CacheKeys.lastNotificationOpenedTime,
    );
    if (timeStr == null) return null;
    return DateTime.tryParse(timeStr);
  }

  // ========== APP SETTINGS ==========

  Future<void> setLanguage(String lang) =>
      _cache.write(CacheKeys.language, lang);
  Future<String> getLanguage() async =>
      await _cache.read<String>(CacheKeys.language) ?? 'en';

  Future<void> setFirstLaunch(bool value) =>
      _cache.write(CacheKeys.firstLaunch, value);
  Future<bool> getFirstLaunch() async =>
      await _cache.read<bool>(CacheKeys.firstLaunch) ?? false;
  Future<bool> isLaunched() async => await getFirstLaunch();

  Future<void> setOnboardingCompleted(bool value) =>
      _cache.write(CacheKeys.onboardingCompleted, value);
  Future<bool> isOnboardingCompleted() async =>
      await _cache.read<bool>(CacheKeys.onboardingCompleted) ?? false;

  // ========== REMEMBER ME ==========

  Future<void> setRememberMe(bool value) async {
    await _cache.write(CacheKeys.rememberMe, value);
    if (!value) {
      await _cache.write(CacheKeys.username, '');
      await _cache.deleteSecure(CacheKeys.password);
    }
  }

  Future<bool> getRememberMe() async =>
      await _cache.read<bool>(CacheKeys.rememberMe) ?? false;

  Future<void> saveLoginCredentials(String username, String password) async {
    await _cache.write(CacheKeys.username, username);
    await _cache.writeSecure(CacheKeys.password, password);
  }

  Future<Map<String, String?>> getLoginCredentials() async {
    return {
      'username': await _cache.read<String>(CacheKeys.username),
      'password': await _cache.readSecure(CacheKeys.password),
    };
  }

  // ========== APP UPDATE ==========

  Future<void> setAppNeedUpdate(bool value) =>
      _cache.write(CacheKeys.appNeedUpdate, value);
  Future<bool> isAppNeedUpdate() async =>
      await _cache.read<bool>(CacheKeys.appNeedUpdate) ?? false;

  Future<void> setAppOldVersion(String version) =>
      _cache.write(CacheKeys.appOldVersion, version);
  Future<String> getAppOldVersion() async =>
      await _cache.read<String>(CacheKeys.appOldVersion) ?? '';

  Future<void> setLastForceUpdateMilliSeconds(int ms) =>
      _cache.write(CacheKeys.lastForceUpdateMilliSeconds, ms);
  Future<int> getLastForceUpdateMilliSeconds() async =>
      await _cache.read<int>(CacheKeys.lastForceUpdateMilliSeconds) ?? 0;

  // ========== SHOWCASE/TUTORIALS ==========

  Future<void> setShowcaseShown(String showcaseKey, bool value) async {
    await _cache.write('${CacheKeys.showcasePrefix}$showcaseKey', value);
  }

  Future<bool> getShowcaseShown(String showcaseKey) async {
    return await _cache.read<bool>('${CacheKeys.showcasePrefix}$showcaseKey') ??
        false;
  }

  // ========== CACHE WITH TTL ==========

  Future<void> setCachedData<T>({
    required String cacheKey,
    required String timestampKey,
    required T data,
  }) async {
    await _cache.write(cacheKey, jsonEncode(data));
    await _cache.write(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<T?> getCachedData<T>({
    required String cacheKey,
    required String timestampKey,
    required T Function(dynamic) fromJson,
    Duration cacheDuration = const Duration(hours: 24),
  }) async {
    final timestamp = await _cache.read<int>(timestampKey);
    if (timestamp == null) return null;

    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > cacheDuration.inMilliseconds) {
      // Cache expired
      await _cache.delete(cacheKey);
      await _cache.delete(timestampKey);
      return null;
    }

    final jsonString = await _cache.read<String>(cacheKey);
    if (jsonString == null) return null;

    try {
      return fromJson(jsonDecode(jsonString));
    } catch (e) {
      return null;
    }
  }

  // ========== BULK OPERATIONS ==========

  /// Clear user data on logout (keeps app settings and language)
  Future<void> clearUserData() async {
    await _cache.deleteSecure(CacheKeys.token);
    await _cache.deleteSecure(CacheKeys.refreshToken);
    await _cache.delete(CacheKeys.userId);
    await _cache.delete(CacheKeys.userName);
    await _cache.delete(CacheKeys.userEmail);
    await _cache.delete(CacheKeys.userPhone);
    await _cache.delete(CacheKeys.userWhatsapp);
    await _cache.delete(CacheKeys.userData);
    await _cache.delete(CacheKeys.pendingOperations);
    await _cache.delete(CacheKeys.favoriteProductIds);
    await _cache.delete(CacheKeys.reportedProductIds);
    await _cache.delete(CacheKeys.recentlyViewedProducts);
    await _cache.delete(CacheKeys.recentlyViewedCommercial);
    // Clear remember me credentials if logout is triggered
    await _cache.write(CacheKeys.rememberMe, false);
    await _cache.write(CacheKeys.username, '');
    await _cache.deleteSecure(CacheKeys.password);
  }

  /// Clear all data (for complete logout)
  Future<void> clearAll() => _cache.clearAll();

  /// Clear all except specified keys (for logout but preserve settings)
  Future<void> clearAllExcept(List<String> keysToRetain) =>
      _cache.clearAllExcept(keysToRetain);

  /// Clear all except tutorials and specific keys
  Future<void> clearAllExceptTutorials(List<String> keysToRetain) async {
    await _cache.clearAllExceptWithPatterns(
      keysToRetain: keysToRetain,
      patternPrefixes: [CacheKeys.showcasePrefix],
    );
  }

  // ========== COUNTRIES ==========

  /// Set the selected country ID
  Future<void> setSelectedCountryId(int id) =>
      _cache.write(CacheKeys.selectedCountryId, id);

  Future<void> setDialCode(String dialCode) =>
      _cache.write(CacheKeys.dialCode, dialCode);

  Future<void> setIsoCode(String isoCode) =>
      _cache.write(CacheKeys.isoCode, isoCode);

  Future<void> setCurrency(String currency) =>
      _cache.write(CacheKeys.currency, currency);

  /// Get the selected country ID
  Future<int?> getSelectedCountryId() async =>
      await _cache.read<int>(CacheKeys.selectedCountryId);

  /// Get the selected country dial code
  Future<String?> getDialCode() async =>
      await _cache.read<String>(CacheKeys.dialCode);

  /// Get the selected country ISO code
  Future<String?> getIsoCode() async =>
      await _cache.read<String>(CacheKeys.isoCode);

  /// Get the selected country currency
  Future<String?> getCurrency() async =>
      await _cache.read<String>(CacheKeys.currency);

  /// Cache the countries list with timestamp
  Future<void> cacheCountries(String countriesJson) async {
    await _cache.write(CacheKeys.countriesData, countriesJson);
    await _cache.write(
      CacheKeys.countriesTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get cached countries list if not expired
  /// Returns null if cache is expired or doesn't exist
  Future<String?> getCachedCountries({
    Duration cacheDuration = const Duration(hours: 24),
  }) async {
    final timestamp = await _cache.read<int>(CacheKeys.countriesTimestamp);
    if (timestamp == null) return null;

    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > cacheDuration.inMilliseconds) {
      // Cache expired
      await _cache.delete(CacheKeys.countriesData);
      await _cache.delete(CacheKeys.countriesTimestamp);
      return null;
    }

    return await _cache.read<String>(CacheKeys.countriesData);
  }

  /// Clear countries cache
  Future<void> clearCountriesCache() async {
    await _cache.delete(CacheKeys.countriesData);
    await _cache.delete(CacheKeys.countriesTimestamp);
  }

  // ========== RECENTLY VIEWED ==========

  /// Add a product ID to recently viewed products list
  /// Maintains a maximum of 50 items, newest first
  Future<void> addRecentlyViewedProduct(int productId) async {
    final List<int> recentProducts = await getRecentlyViewedProducts();

    // Remove if already exists to avoid duplicates
    recentProducts.remove(productId);

    // Add to the beginning
    recentProducts.insert(0, productId);

    // Keep only the last 50 items
    if (recentProducts.length > 50) {
      recentProducts.removeRange(50, recentProducts.length);
    }

    await _cache.write(
      CacheKeys.recentlyViewedProducts,
      jsonEncode(recentProducts),
    );
  }

  /// Get recently viewed products list
  Future<List<int>> getRecentlyViewedProducts() async {
    final String? jsonString = await _cache.read<String>(
      CacheKeys.recentlyViewedProducts,
    );

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as int).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear recently viewed products
  Future<void> clearRecentlyViewedProducts() async {
    await _cache.delete(CacheKeys.recentlyViewedProducts);
  }

  /// Add a commercial ID to recently viewed commercial list
  /// Maintains a maximum of 50 items, newest first
  Future<void> addRecentlyViewedCommercial(int commercialId) async {
    final List<int> recentCommercial = await getRecentlyViewedCommercial();

    // Remove if already exists to avoid duplicates
    recentCommercial.remove(commercialId);

    // Add to the beginning
    recentCommercial.insert(0, commercialId);

    // Keep only the last 50 items
    if (recentCommercial.length > 50) {
      recentCommercial.removeRange(50, recentCommercial.length);
    }

    await _cache.write(
      CacheKeys.recentlyViewedCommercial,
      jsonEncode(recentCommercial),
    );
  }

  /// Get recently viewed commercial list
  Future<List<int>> getRecentlyViewedCommercial() async {
    final String? jsonString = await _cache.read<String>(
      CacheKeys.recentlyViewedCommercial,
    );

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as int).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear recently viewed commercial
  Future<void> clearRecentlyViewedCommercial() async {
    await _cache.delete(CacheKeys.recentlyViewedCommercial);
  }

  // ========== FAVORITE IDS ==========

  /// Set the list of favorite product IDs
  Future<void> setFavoriteProductIds(List<int> ids) async {
    await _cache.write(CacheKeys.favoriteProductIds, jsonEncode(ids));
  }

  /// Get the cached list of favorite product IDs
  Future<List<int>> getFavoriteProductIds() async {
    final String? jsonString = await _cache.read<String>(
      CacheKeys.favoriteProductIds,
    );

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as int).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a product ID to favorites cache
  Future<void> addFavoriteProductId(int productId) async {
    final List<int> favorites = await getFavoriteProductIds();
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await setFavoriteProductIds(favorites);
    }
  }

  /// Remove a product ID from favorites cache
  Future<void> removeFavoriteProductId(int productId) async {
    final List<int> favorites = await getFavoriteProductIds();
    favorites.remove(productId);
    await setFavoriteProductIds(favorites);
  }

  /// Check if a product is in favorites cache
  Future<bool> isProductFavorite(int productId) async {
    final List<int> favorites = await getFavoriteProductIds();
    return favorites.contains(productId);
  }

  /// Clear favorites cache
  Future<void> clearFavoriteProductIds() async {
    await _cache.delete(CacheKeys.favoriteProductIds);
  }

  // ========== REPORTED IDS ==========

  /// Set the list of reported product IDs
  Future<void> setReportedProductIds(List<int> ids) async {
    await _cache.write(CacheKeys.reportedProductIds, jsonEncode(ids));
  }

  /// Get the cached list of reported product IDs
  Future<List<int>> getReportedProductIds() async {
    final String? jsonString = await _cache.read<String>(
      CacheKeys.reportedProductIds,
    );

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as int).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a product ID to reported cache
  Future<void> addReportedProductId(int productId) async {
    final List<int> reported = await getReportedProductIds();
    if (!reported.contains(productId)) {
      reported.add(productId);
      await setReportedProductIds(reported);
    }
  }

  /// Check if a product is in reported cache
  Future<bool> isProductReported(int productId) async {
    final List<int> reported = await getReportedProductIds();
    return reported.contains(productId);
  }

  /// Clear reported cache
  Future<void> clearReportedProductIds() async {
    await _cache.delete(CacheKeys.reportedProductIds);
  }
}
