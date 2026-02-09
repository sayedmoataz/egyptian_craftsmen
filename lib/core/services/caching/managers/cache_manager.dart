import '../contract/cache_consumer.dart';

class CacheManager {
  final CacheConsumer secureStorage;
  final CacheConsumer sharedPrefs;

  CacheManager({
    required this.secureStorage,
    required this.sharedPrefs,
  });

  // ========== SECURE STORAGE OPERATIONS ==========

  /// Write sensitive data (tokens, passwords, etc.)
  Future<void> writeSecure(String key, String value) async {
    await secureStorage.write(key, value);
  }

  /// Read sensitive data
  Future<String?> readSecure(String key) async {
    return await secureStorage.read<String>(key);
  }

  /// Delete sensitive data
  Future<void> deleteSecure(String key) async {
    await secureStorage.delete(key);
  }

  // ========== SHARED PREFERENCES OPERATIONS ==========

  /// Write non-sensitive data
  Future<void> write<T>(String key, T value) async {
    await sharedPrefs.write(key, value);
  }

  /// Read non-sensitive data
  Future<T?> read<T>(String key) async {
    return await sharedPrefs.read<T>(key);
  }

  /// Read non-sensitive data synchronously
  T? readSync<T>(String key) {
    return sharedPrefs.readSync<T>(key);
  }

  /// Check if key exists
  Future<bool> contains(String key) async {
    return await sharedPrefs.contains(key);
  }

  /// Delete non-sensitive data
  Future<void> delete(String key) async {
    await sharedPrefs.delete(key);
  }

  /// Get all keys from shared preferences
  Set<String> getKeys() {
    return sharedPrefs.getKeys();
  }

  // ========== BULK OPERATIONS ==========

  /// Clear all non-sensitive data
  Future<void> clearSharedPrefs() async {
    await sharedPrefs.clear();
  }

  /// Clear all sensitive data
  Future<void> clearSecureStorage() async {
    await secureStorage.clear();
  }

  /// Clear everything (both secure and non-secure)
  Future<void> clearAll() async {
    await Future.wait([sharedPrefs.clear(), secureStorage.clear()]);
  }

  /// Clear all except specified keys (useful for logout while preserving settings)
  Future<void> clearAllExcept(List<String> keysToRetain) async {
    await sharedPrefs.clearExcept(keysToRetain);
  }

  /// Clear all except specific keys AND patterns (e.g., 'showcase_*')
  Future<void> clearAllExceptWithPatterns({
    required List<String> keysToRetain,
    List<String> patternPrefixes = const [],
  }) async {
    final allKeys = sharedPrefs.getKeys();
    final keysToDelete = allKeys.where((key) {
      // Keep if in retain list
      if (keysToRetain.contains(key)) return false;

      // Keep if matches any pattern prefix
      for (var prefix in patternPrefixes) {
        if (key.startsWith(prefix)) return false;
      }

      return true;
    }).toList();

    await sharedPrefs.deleteAll(keysToDelete);
  }
}
