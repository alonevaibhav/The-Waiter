// lib/core/services/cache_service.dart

import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CacheService extends GetxService {

  late GetStorage _storage;
  static const String _cacheVersionKey = 'cache_version';
  static const int _currentCacheVersion = 1;
  static const String _logName = 'CacheService';

  // ==========================================
  // INITIALIZATION
  // ==========================================
  Future<CacheService> init() async {
    try {
      await GetStorage.init();
      _storage = GetStorage();
      await _handleCacheVersioning();

      developer.log(
        '✅ CacheService initialized successfully',
        name: _logName,
      );
      return this;
    } catch (e, stackTrace) {
      developer.log(
        '❌ CRITICAL: CacheService initialization failed',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _handleCacheVersioning() async {
    try {
      final savedVersion = _storage.read<int>(_cacheVersionKey);

      if (savedVersion == null) {
        await _storage.write(_cacheVersionKey, _currentCacheVersion);
      } else if (savedVersion < _currentCacheVersion) {
        developer.log(
          '⚠️ Cache version changed: $savedVersion → $_currentCacheVersion',
          name: _logName,
        );

        await clearAll();
        await _storage.write(_cacheVersionKey, _currentCacheVersion);

        developer.log(
          '✅ Cache cleared and updated',
          name: _logName,
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Cache versioning check failed',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================
  // GENERIC READ OPERATIONS
  // ==========================================

  T? read<T>(String key, {T? defaultValue}) {
    try {
      final value = _storage.read<T>(key);
      return value ?? defaultValue;
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Cache read error for key "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  T? readWithValidation<T>(
      String key, {
        T? defaultValue,
        bool Function(dynamic value)? validator,
      }) {
    try {
      final value = _storage.read<T>(key);
      if (value == null) return defaultValue;

      if (validator != null && !validator(value)) {
        developer.log(
          '⚠️ Validation failed for key "$key"',
          name: _logName,
        );
        return defaultValue;
      }

      return value;
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Cache read error for key "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  // ==========================================
  // GENERIC WRITE OPERATIONS
  // ==========================================

  Future<bool> write(String key, dynamic value) async {
    try {
      if (key.isEmpty) {
        developer.log(
          '❌ Cannot write: empty key',
          name: _logName,
        );
        return false;
      }

      if (value is String && value.length > 1000000) {
        developer.log(
          '❌ Value too large for key "$key" (${value.length} chars)',
          name: _logName,
        );
        return false;
      }

      await _storage.write(key, value);
      return true;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Cache write error for key "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> writeWithExpiry(
      String key,
      dynamic value,
      Duration expiry,
      ) async {
    try {
      final expiryTime =
          DateTime.now().add(expiry).millisecondsSinceEpoch;

      await _storage.write(key, value);
      await _storage.write('${key}_expiry', expiryTime);
      return true;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Cache write with expiry failed for "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  T? readWithExpiry<T>(String key, {T? defaultValue}) {
    try {
      final expiryTime = _storage.read<int>('${key}_expiry');

      if (expiryTime == null) {
        return read<T>(key, defaultValue: defaultValue);
      }

      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        developer.log(
          '⏰ Cache expired for key "$key"',
          name: _logName,
        );
        remove(key);
        remove('${key}_expiry');
        return defaultValue;
      }

      return read<T>(key, defaultValue: defaultValue);
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Cache expiry read error for "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  // ==========================================
  // DELETE OPERATIONS
  // ==========================================

  Future<bool> remove(String key) async {
    try {
      await _storage.remove(key);
      return true;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Cache remove error for key "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      await _storage.erase();
      developer.log(
        '✅ Cache cleared successfully',
        name: _logName,
      );
      return true;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Cache clear error',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // ==========================================
  // LIST OPERATIONS
  // ==========================================

  Future<bool> saveList<T>(
      String key,
      List<T> items,
      Map<String, dynamic> Function(T) toJson,
      ) async {
    try {
      if (items.isEmpty) {
        developer.log(
          '⚠️ Saving empty list for key "$key"',
          name: _logName,
        );
      }

      final jsonList = items.map((item) => toJson(item)).toList();

      if (jsonList.length > 10000) {
        developer.log(
          '❌ List too large for key "$key": ${jsonList.length} items',
          name: _logName,
        );
        return false;
      }

      return await write(key, jsonList);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Save list failed for "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  List<T> readList<T>(
      String key,
      T Function(Map<String, dynamic>) fromJson, {
        List<T>? defaultValue,
      }) {
    try {
      final jsonList = read<List>(key);

      if (jsonList == null || jsonList.isEmpty) {
        return defaultValue ?? [];
      }

      final result = <T>[];
      for (var i = 0; i < jsonList.length; i++) {
        try {
          final json = jsonList[i] as Map<String, dynamic>;
          result.add(fromJson(json));
        } catch (e) {
          developer.log(
            '⚠️ Failed to parse item $i in list "$key"',
            name: _logName,
            error: e,
          );
        }
      }

      return result;
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Read list failed for "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue ?? [];
    }
  }

  // ==========================================
  // UTILITY METHODS
  // ==========================================

  bool hasKey(String key) {
    try {
      return _storage.hasData(key);
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Check key existence failed for "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  List<String> getAllKeys() {
    try {
      return _storage.getKeys().toList();
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Get all keys failed',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  int getCacheSize() {
    try {
      return getAllKeys().length;
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Get cache size failed',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }

  void listenToKey(String key, Function(dynamic) callback) {
    try {
      _storage.listenKey(key, callback);
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Listen to key failed for "$key"',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ==========================================
  // DEBUG METHODS
  // ==========================================

  void debugPrintCache() {
    try {
      final keys = getAllKeys();
      developer.log(
        '📦 Cache Contents (${keys.length} keys)',
        name: _logName,
      );

      for (final key in keys) {
        final value = read(key);
        developer.log(
          '  $key: $value',
          name: _logName,
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Debug print failed',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Map<String, dynamic> getCacheInfo() {
    try {
      return {
        'total_keys': getCacheSize(),
        'cache_version': read<int>(_cacheVersionKey),
        'keys': getAllKeys(),
      };
    } catch (e, stackTrace) {
      developer.log(
        '⚠️ Get cache info failed',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
      return {'error': e.toString()};
    }
  }
}
