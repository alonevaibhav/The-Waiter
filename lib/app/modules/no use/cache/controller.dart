// screens/users_screen.dart

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Utils/snakbar_util.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../route/app_routes.dart';
import 'api_cache_storage.dart';

/// ==========================================
/// USER MODEL
/// ==========================================

class UserModel {
  final String id;
  final String createdAt;
  final String name;
  final String avatar;
  final String location;
  final bool isRegister;
  final String price;
  final String car;
  final String dob;
  final String profilePic;
  final String gender;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.location,
    required this.isRegister,
    required this.price,
    required this.car,
    required this.dob,
    required this.profilePic,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      location: json['location'] ?? '',
      isRegister: json['isregister'] ?? false,
      price: json['price'] ?? '0',
      car: json['car'] ?? '',
      dob: json['dob'] ?? '',
      profilePic: json['profile_pic'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'avatar': avatar,
      'location': location,
      'isregister': isRegister,
      'price': price,
      'car': car,
      'dob': dob,
      'profile_pic': profilePic,
      'gender': gender,
    };
  }
}

/// ==========================================
/// USERS RESPONSE
/// ==========================================

class UsersResponse {
  final List<UserModel> users;

  UsersResponse({required this.users});

  factory UsersResponse.fromJson(dynamic json) {
    if (json is List) {
      return UsersResponse(
        users: json.map((e) => UserModel.fromJson(e)).toList(),
      );
    }
    return UsersResponse(users: []);
  }
}

/// ==========================================
/// API CALL
/// ==========================================




Future<ApiResponse<UsersResponse>> getUsers() async {
  try {
    return await ApiService.get<UsersResponse>(
      endpoint: '/position',
      fromJson: (json) => UsersResponse.fromJson(json),
      includeToken: false,
    );
  } catch (e) {
    return ApiResponse(
      success: false,
      errorMessage: e.toString(),
      statusCode: -1,
    );
  }
}

/// ==========================================
/// USERS CONTROLLER
/// ==========================================

class UsersController extends GetxController {
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isFromCache = false.obs;
  final RxString errorMessage = ''.obs;

  ApiCacheStorage get _apiCache => Get.find<ApiCacheStorage>();
  ConnectivityController get _connectivity => Get.find<ConnectivityController>();

  static const Duration cacheMaxAge = Duration(minutes: 15);
  static const String _logName = 'UsersController';

  BuildContext? get _context => AppRoutes.navigatorKey.currentContext;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// ==========================================
  /// FETCH USERS (CACHE FIRST)
  /// ==========================================

  Future<void> fetchUsers({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;
      isFromCache.value = false;
      errorMessage.value = '';

      if (!forceRefresh) {
        final cachedUsers = await _loadFromCache();
        if (cachedUsers != null && cachedUsers.isNotEmpty) {
          users.value = cachedUsers;
          isFromCache.value = true;

          developer.log(
            'Loaded ${cachedUsers.length} users from cache',
            name: _logName,
          );

          if (!_apiCache.isUsersCacheFresh(maxAge: cacheMaxAge)) {
            _fetchFromApiInBackground();
          }
          return;
        }
      }

      await _fetchFromApi();
    } catch (e, st) {
      developer.log(
        'Fetch users failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ==========================================
  /// LOAD FROM CACHE
  /// ==========================================

  Future<List<UserModel>?> _loadFromCache() async {
    try {
      final cached = _apiCache.getCachedUsers(maxAge: cacheMaxAge);
      if (cached == null || cached.isEmpty) return null;

      return cached.map(UserModel.fromJson).toList();
    } catch (e, st) {
      developer.log(
        'Load cache error',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// ==========================================
  /// FETCH FROM API
  /// ==========================================

  Future<void> _fetchFromApi() async {
    try {
      if (!_connectivity.isConnected) {
        final cached = _apiCache.getCachedUsers();
        if (cached != null) {
          users.value = cached.map(UserModel.fromJson).toList();
          isFromCache.value = true;

          _showInfo('Offline mode – showing cached data');
        }
        return;
      }

      final response = await getUsers();

      if (response.success && response.data != null) {
        users.value = response.data!.users;
        isFromCache.value = false;

        await _saveToCache(users);

        developer.log(
          'Loaded ${users.length} users from API',
          name: _logName,
        );

        _showSuccess('Users loaded successfully');
      } else {
        _showInfo('Showing cached data due to API error');
      }
    } catch (e, st) {
      developer.log(
        'API fetch error',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }


  // ==========================================
// GET CACHE INFO
// ==========================================

  Map<String, dynamic> getCacheInfo() {
    try {
      return _apiCache.getUsersCacheInfo();
    } catch (e, st) {
      developer.log(
        'Get cache info failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      return {
        'error': e.toString(),
      };
    }
  }


  /// ==========================================
  /// BACKGROUND REFRESH
  /// ==========================================

  Future<void> _fetchFromApiInBackground() async {
    try {
      if (!_connectivity.isConnected) return;

      final response = await getUsers();
      if (response.success && response.data != null) {
        users.value = response.data!.users;
        await _saveToCache(users);

        developer.log(
          'Background refresh completed',
          name: _logName,
        );

        _showSuccess('User data refreshed');
      }
    } catch (e, st) {
      developer.log(
        'Background refresh failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// ==========================================
  /// SAVE TO CACHE
  /// ==========================================

  Future<void> _saveToCache(List<UserModel> list) async {
    try {
      await _apiCache.cacheUsers(
        list.map((e) => e.toJson()).toList(),
      );

      developer.log(
        'Cached ${list.length} users',
        name: _logName,
      );
    } catch (e, st) {
      developer.log(
        'Save cache error',
        name: _logName,
        error: e,
        stackTrace: st,
      );
    }
  }

  /// ==========================================
  /// REFRESH
  /// ==========================================

  Future<void> refreshUsers() async {
    isRefreshing.value = true;
    await fetchUsers(forceRefresh: true);
    isRefreshing.value = false;
  }

  /// ==========================================
  /// CLEAR CACHE
  /// ==========================================

  Future<void> clearCache() async {
    await _apiCache.clearUsersCache();
    _showSuccess('User cache cleared');
    await fetchUsers(forceRefresh: true);
  }

  /// ==========================================
  /// SNACKBAR HELPERS
  /// ==========================================

  void _showSuccess(String message) {
    final ctx = _context;
    if (ctx != null) {
      SnackBarUtil.showSuccess(ctx, message);
    }
  }

  void _showInfo(String message) {
    final ctx = _context;
    if (ctx != null) {
      SnackBarUtil.showInfo(ctx, message);
    }
  }
}

