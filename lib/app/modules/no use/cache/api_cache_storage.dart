// lib/core/services/storage/api_cache_storage.dart

import 'package:get/get.dart';
import '../../../core/services/cache_service.dart';

class ApiCacheStorage extends GetxService {
  final CacheService _cache = Get.find<CacheService>();

  // Cache durations
  static const Duration cacheDuration = Duration(hours: 1);

  // Cache keys
  static const String _usersListKey = 'api_users_list';
  static const String _usersCacheTimestampKey = 'api_users_timestamp';

  // ==========================================
  // USERS CACHE
  // ==========================================

  /// Save users list with timestamp
  Future<bool> cacheUsers(List<Map<String, dynamic>> users) async {
    try {
      // Save users
      final success = await _cache.write(_usersListKey, users);

      if (success) {
        // Save cache timestamp
        await _cache.write(
          _usersCacheTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      }

      return success;
    } catch (e) {
      print('❌ Cache users failed: $e');
      return false;
    }
  }

  /// Get cached users with expiry check
  List<Map<String, dynamic>>? getCachedUsers({Duration? maxAge}) {
    try {
      // Check if cache exists
      if (!_cache.hasKey(_usersListKey)) {
        print('⚠️ No cached users found');
        return null;
      }

      // Check cache age if maxAge provided
      if (maxAge != null) {
        final timestamp = _cache.read<int>(_usersCacheTimestampKey);

        if (timestamp != null) {
          final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
          final maxAgeMs = maxAge.inMilliseconds;

          if (cacheAge > maxAgeMs) {
            print('⏰ Users cache expired (age: ${Duration(milliseconds: cacheAge).inMinutes} min)');
            return null;
          }
        }
      }

      // Get cached data
      final cachedData = _cache.read<List>(_usersListKey);

      if (cachedData == null || cachedData.isEmpty) {
        return null;
      }

      // Convert to List<Map<String, dynamic>>
      return cachedData
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

    } catch (e) {
      print('⚠️ Get cached users failed: $e');
      return null;
    }
  }

  /// Check if users cache is fresh
  bool isUsersCacheFresh({Duration maxAge = cacheDuration}) {
    try {
      if (!_cache.hasKey(_usersListKey)) return false;

      final timestamp = _cache.read<int>(_usersCacheTimestampKey);
      if (timestamp == null) return false;

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      return cacheAge <= maxAge.inMilliseconds;
    } catch (e) {
      return false;
    }
  }

  /// Clear users cache
  Future<bool> clearUsersCache() async {
    try {
      await _cache.remove(_usersListKey);
      await _cache.remove(_usersCacheTimestampKey);
      print('✅ Users cache cleared');
      return true;
    } catch (e) {
      print('❌ Clear users cache failed: $e');
      return false;
    }
  }

  /// Get cache info
  Map<String, dynamic> getUsersCacheInfo() {
    try {
      final timestamp = _cache.read<int>(_usersCacheTimestampKey);
      final hasCachedData = _cache.hasKey(_usersListKey);

      if (timestamp != null && hasCachedData) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
        final cachedUsers = _cache.read<List>(_usersListKey);

        return {
          'has_cache': true,
          'cache_age_minutes': Duration(milliseconds: cacheAge).inMinutes,
          'cached_at': DateTime.fromMillisecondsSinceEpoch(timestamp).toString(),
          'users_count': cachedUsers?.length ?? 0,
          'is_fresh': isUsersCacheFresh(),
        };
      }

      return {
        'has_cache': false,
        'cache_age_minutes': 0,
        'users_count': 0,
        'is_fresh': false,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}