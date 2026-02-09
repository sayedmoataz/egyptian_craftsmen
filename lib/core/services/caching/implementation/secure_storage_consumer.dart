import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../contract/cache_consumer.dart';

class SecureStorageConsumer implements CacheConsumer {
  final FlutterSecureStorage _storage;

  SecureStorageConsumer(this._storage);

  @override
  Future<void> write<T>(String key, T value) async {
    if (value == null) {
      await delete(key);
      return;
    }

    // All values stored as strings (encrypted by the platform)
    final stringValue = value is String ? value : jsonEncode(value);
    await _storage.write(key: key, value: stringValue);
  }

  @override
  Future<T?> read<T>(String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;

    // Handle type conversion
    if (T == String) return value as T;

    // For other types, deserialize from JSON
    try {
      final decoded = jsonDecode(value);
      return decoded as T;
    } catch (e) {
      // If JSON parsing fails, return raw string
      return value as T?;
    }
  }

  @override
  T? readSync<T>(String key) {
    throw UnimplementedError(
      'SecureStorage does not support synchronous read. Use read() instead.',
    );
  }

  @override
  Future<bool> contains(String key) async {
    return await _storage.containsKey(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  @override
  Future<void> writeAll(Map<String, dynamic> data) async {
    for (var entry in data.entries) {
      await write(entry.key, entry.value);
    }
  }

  @override
  Future<Map<String, dynamic>> readAll(List<String> keys) async {
    final result = <String, dynamic>{};
    for (var key in keys) {
      final value = await read<dynamic>(key);
      if (value != null) result[key] = value;
    }
    return result;
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (var key in keys) {
      await delete(key);
    }
  }

  @override
  Future<void> clearExcept(List<String> keysToRetain) async {
    final allData = await _storage.readAll();
    for (var key in allData.keys) {
      if (!keysToRetain.contains(key)) {
        await delete(key);
      }
    }
  }

  @override
  Set<String> getKeys() {
    // Note: SecureStorage doesn't provide synchronous key access
    // You'll need to call readAll() asynchronously
    throw UnimplementedError(
      'SecureStorage does not support synchronous key retrieval. Use readAll() instead.',
    );
  }
}
