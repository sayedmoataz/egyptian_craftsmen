abstract class CacheConsumer {
  // Generic read/write operations
  Future<void> write<T>(String key, T value);
  Future<T?> read<T>(String key);
  T? readSync<T>(String key);
  Future<bool> contains(String key);
  Future<void> delete(String key);
  Future<void> clear();

  // Bulk operations
  Future<void> writeAll(Map<String, dynamic> data);
  Future<Map<String, dynamic>> readAll(List<String> keys);
  Future<void> deleteAll(List<String> keys);
  Future<void> clearExcept(List<String> keysToRetain);

  // Get all keys
  Set<String> getKeys();
}
