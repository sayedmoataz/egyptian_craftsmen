import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../contract/cache_consumer.dart';

class SharedPrefsConsumer implements CacheConsumer {
  final SharedPreferences _prefs;

  SharedPrefsConsumer(this._prefs);

  @override
  Future<void> write<T>(String key, T value) async {
    if (value == null) {
      await delete(key);
      return;
    }

    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // For complex objects, serialize to JSON
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  @override
  Future<T?> read<T>(String key) async {
    if (!_prefs.containsKey(key)) return null;

    final value = _prefs.get(key);

    if (value == null) return null;

    // Handle type conversion
    if (T == String) return value as T?;
    if (T == int) return value as T?;
    if (T == double) return value as T?;
    if (T == bool) return value as T?;
    if (T == List<String>) return value as T?;

    // For complex objects, deserialize from JSON
    if (value is String) {
      try {
        return jsonDecode(value) as T;
      } catch (e) {
        return value as T?;
      }
    }

    return value as T?;
  }

  @override
  T? readSync<T>(String key) {
    if (!_prefs.containsKey(key)) return null;

    final value = _prefs.get(key);

    if (value == null) return null;

    // Handle type conversion
    if (T == String) return value as T?;
    if (T == int) return value as T?;
    if (T == double) return value as T?;
    if (T == bool) return value as T?;
    if (T == List<String>) return value as T?;

    // For complex objects, deserialize from JSON
    if (value is String) {
      try {
        return jsonDecode(value) as T;
      } catch (e) {
        return value as T?;
      }
    }

    return value as T?;
  }

  @override
  Future<bool> contains(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
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
    final allKeys = _prefs.getKeys();
    for (var key in allKeys) {
      if (!keysToRetain.contains(key)) {
        await delete(key);
      }
    }
  }

  @override
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
