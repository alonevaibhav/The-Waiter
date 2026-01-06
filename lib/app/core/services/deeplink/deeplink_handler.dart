//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../../../route/app_routes.dart';
// import 'deeplink_controller.dart';
//
// class DeepLinkHandler {
//   static final DeepLinkHandler _instance = DeepLinkHandler._internal();
//   factory DeepLinkHandler() => _instance;
//   DeepLinkHandler._internal();
//
//   bool _isInitialized = false;
//
//   Future<void> initialize() async {
//     print('🚀 DeepLinkHandler: Starting initialization...');
//
//     if (_isInitialized) {
//       print('⚠️ DeepLinkHandler already initialized');
//       return;
//     }
//
//     _isInitialized = true;
//
//     // Setup listener for future deep links
//     _setupDeepLinkListener();
//
//     // Process any pending deep link that arrived during startup
//     await _processPendingDeepLink();
//
//     print('✅ DeepLinkHandler: Initialization complete');
//   }
//
//   void _setupDeepLinkListener() {
//     print('👂 DeepLinkHandler: Setting up listener...');
//     final deepLinkController = Get.find<DeepLinkController>();
//
//     ever(deepLinkController.pendingTableIdRx, (String? tableId) {
//       print('🔔 DeepLink change detected: $tableId');
//       print('   Processed: ${deepLinkController.isProcessed}');
//       print('   Initialized: $_isInitialized');
//
//       if (_isInitialized &&
//           tableId != null &&
//           !deepLinkController.isProcessed) {
//         print('🎯 Triggering deep link processing...');
//         _processPendingDeepLink();
//       }
//     });
//
//     print('✅ DeepLink listener active');
//   }
//
//   Future<void> _processPendingDeepLink() async {
//     final deepLinkController = Get.find<DeepLinkController>();
//
//     print('🔍 Checking for pending deep links...');
//     print('   Has pending: ${deepLinkController.hasPendingDeepLink}');
//     print('   Table ID: ${deepLinkController.pendingTableId}');
//     print('   Processed: ${deepLinkController.isProcessed}');
//
//     if (!deepLinkController.hasPendingDeepLink ||
//         deepLinkController.isProcessed) {
//       print('⏭️ No pending deep link to process');
//       return;
//     }
//
//     final tableId = deepLinkController.pendingTableId;
//     if (tableId == null) {
//       print('⚠️ Table ID is null');
//       return;
//     }
//
//     print('🎯 Processing deep link for table: $tableId');
//
//     // Check authentication
//     final isAuthenticated = await _isUserAuthenticated();
//     print('🔐 Auth status: $isAuthenticated');
//
//     if (!isAuthenticated) {
//       print('⏳ User not authenticated - will process after login');
//       return;
//     }
//
//     // Mark as processed BEFORE navigation
//     deepLinkController.markAsProcessed();
//     print('✅ Marked as processed');
//
//     // Small delay for UI stability
//     await Future.delayed(const Duration(milliseconds: 150));
//
//     try {
//       print('🧭 Attempting navigation to user dashboard...');
//
//       // Get context from GoRouter
//       final context = AppRoutes.router.routerDelegate.navigatorKey.currentContext;
//
//       if (context != null && context.mounted) {
//         // Navigate using context.go()
//         context.go(
//           AppRoutes.userDashboard,
//           extra: {'table_id': tableId},
//         );
//         print('✅ Navigation successful to table: $tableId');
//
//         // Clear the deep link after successful navigation
//         deepLinkController.clearPendingDeepLink();
//       } else {
//         print('❌ Navigation context not available');
//         // Reset processed state for retry
//         deepLinkController.isProcessedRx.value = false;
//       }
//     } catch (e, stackTrace) {
//       print('❌ Navigation error: $e');
//       print('Stack trace: $stackTrace');
//       // Reset processed state for retry
//       deepLinkController.isProcessedRx.value = false;
//     }
//   }
//
//   Future<bool> _isUserAuthenticated() async {
//     // TODO: Replace with your actual auth check
//     // Example:
//     // try {
//     //   final authController = Get.find<AuthController>();
//     //   return authController.isAuthenticated;
//     // } catch (e) {
//     //   print('⚠️ AuthController not found');
//     //   return false;
//     // }
//
//     return true; // Temporarily return true for testing
//   }
//
//   /// Call this after successful login
//   Future<void> processPendingAfterLogin() async {
//     print('🔓 Login detected - checking for pending deep links');
//     final deepLinkController = Get.find<DeepLinkController>();
//
//     if (deepLinkController.hasPendingDeepLink) {
//       print('📌 Found pending deep link, processing now...');
//       // Reset processed flag to allow navigation
//       deepLinkController.isProcessedRx.value = false;
//       await _processPendingDeepLink();
//     } else {
//       print('ℹ️ No pending deep links after login');
//     }
//   }
//
//   /// Manual navigation helper
//   void navigateToUserDashboard(String tableId) {
//     print('🧭 Manual navigation to table: $tableId');
//
//     final context = AppRoutes.router.routerDelegate.navigatorKey.currentContext;
//
//     if (context != null && context.mounted) {
//       context.go(
//         AppRoutes.userDashboard,
//         extra: {'table_id': tableId},
//       );
//       print('✅ Manual navigation successful');
//     } else {
//       print('❌ Cannot navigate: context not available');
//     }
//   }
// }


import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../route/app_routes.dart';
import 'deeplink_controller.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    developer.log('🚀 Starting initialization...', name: 'DeepLinkHandler');

    if (_isInitialized) {
      developer.log('⚠️ Already initialized', name: 'DeepLinkHandler');
      return;
    }

    _isInitialized = true;

    // Setup listener for future deep links
    _setupDeepLinkListener();

    // Process any pending deep link that arrived during startup
    await _processPendingDeepLink();

    developer.log('✅ Initialization complete', name: 'DeepLinkHandler');
  }

  void _setupDeepLinkListener() {
    developer.log('👂 Setting up listener...', name: 'DeepLinkHandler');
    final deepLinkController = Get.find<DeepLinkController>();

    // Listen for table ID changes
    ever(deepLinkController.pendingTableIdRx, (String? tableId) {
      developer.log('🔔 Table ID change detected: $tableId', name: 'DeepLinkHandler');
      developer.log('   Processed: ${deepLinkController.isProcessed}', name: 'DeepLinkHandler');
      developer.log('   Initialized: $_isInitialized', name: 'DeepLinkHandler');

      if (_isInitialized && tableId != null && !deepLinkController.isProcessed) {
        developer.log('🎯 Triggering deep link processing...', name: 'DeepLinkHandler');
        _processPendingDeepLink();
      }
    });

    // Listen for business ID changes
    ever(deepLinkController.pendingBusinessIdRx, (String? businessId) {
      developer.log('🔔 Business ID change detected: $businessId', name: 'DeepLinkHandler');
      developer.log('   Processed: ${deepLinkController.isProcessed}', name: 'DeepLinkHandler');
      developer.log('   Initialized: $_isInitialized', name: 'DeepLinkHandler');

      if (_isInitialized && businessId != null && !deepLinkController.isProcessed) {
        developer.log('🎯 Triggering deep link processing...', name: 'DeepLinkHandler');
        _processPendingDeepLink();
      }
    });

    developer.log('✅ Listener active', name: 'DeepLinkHandler');
  }

  Future<void> _processPendingDeepLink() async {
    final deepLinkController = Get.find<DeepLinkController>();

    developer.log('🔍 Checking for pending deep links...', name: 'DeepLinkHandler');
    developer.log('   Has pending: ${deepLinkController.hasPendingDeepLink}', name: 'DeepLinkHandler');
    developer.log('   Table ID: ${deepLinkController.pendingTableId}', name: 'DeepLinkHandler');
    developer.log('   Business ID: ${deepLinkController.pendingBusinessId}', name: 'DeepLinkHandler');
    developer.log('   Processed: ${deepLinkController.isProcessed}', name: 'DeepLinkHandler');

    if (!deepLinkController.hasPendingDeepLink || deepLinkController.isProcessed) {
      developer.log('⏭️ No pending deep link to process', name: 'DeepLinkHandler');
      return;
    }

    final tableId = deepLinkController.pendingTableId;
    final businessId = deepLinkController.pendingBusinessId;

    developer.log('🎯 Processing deep link:', name: 'DeepLinkHandler');
    developer.log('   Table ID: $tableId', name: 'DeepLinkHandler');
    developer.log('   Business ID: $businessId', name: 'DeepLinkHandler');

    // Check authentication
    final isAuthenticated = await _isUserAuthenticated();
    developer.log('🔐 Auth status: $isAuthenticated', name: 'DeepLinkHandler');

    if (!isAuthenticated) {
      developer.log('⏳ User not authenticated - will process after login', name: 'DeepLinkHandler');
      return;
    }

    // Mark as processed BEFORE navigation
    deepLinkController.markAsProcessed();
    developer.log('✅ Marked as processed', name: 'DeepLinkHandler');

    // Small delay for UI stability
    await Future.delayed(const Duration(milliseconds: 150));

    try {
      developer.log('🧭 Attempting navigation to user dashboard...', name: 'DeepLinkHandler');

      // Get context from GoRouter
      final context = AppRoutes.router.routerDelegate.navigatorKey.currentContext;

      if (context != null && context.mounted) {
        // Prepare extra data
        final extraData = <String, dynamic>{};
        if (tableId != null) extraData['table_id'] = tableId;
        if (businessId != null) extraData['business_id'] = businessId;

        // Navigate using context.go()
        context.go(
          AppRoutes.userHome,
          extra: extraData.isNotEmpty ? extraData : null,
        );

        developer.log('✅ Navigation successful', name: 'DeepLinkHandler');
        developer.log('   Table ID: $tableId', name: 'DeepLinkHandler');
        developer.log('   Business ID: $businessId', name: 'DeepLinkHandler');

        // Clear the deep link after successful navigation
        deepLinkController.clearPendingDeepLink();
      } else {
        developer.log('❌ Navigation context not available', name: 'DeepLinkHandler');
        // Reset processed state for retry
        deepLinkController.isProcessedRx.value = false;
      }
    } catch (e, stackTrace) {
      developer.log('❌ Navigation error: $e', name: 'DeepLinkHandler', error: e, stackTrace: stackTrace);
      // Reset processed state for retry
      deepLinkController.isProcessedRx.value = false;
    }
  }

  Future<bool> _isUserAuthenticated() async {
    // TODO: Replace with your actual auth check
    // Example:
    // try {
    //   final authController = Get.find<AuthController>();
    //   return authController.isAuthenticated;
    // } catch (e) {
    //   developer.log('⚠️ AuthController not found', name: 'DeepLinkHandler');
    //   return false;
    // }

    // For now, return true to allow navigation (update this based on your auth logic)
    return true;
  }

  /// Call this after successful login
  Future<void> processPendingAfterLogin() async {
    developer.log('🔓 Login detected - checking for pending deep links', name: 'DeepLinkHandler');
    final deepLinkController = Get.find<DeepLinkController>();

    if (deepLinkController.hasPendingDeepLink) {
      developer.log('📌 Found pending deep link, processing now...', name: 'DeepLinkHandler');
      // Reset processed flag to allow navigation
      deepLinkController.isProcessedRx.value = false;
      await _processPendingDeepLink();
    } else {
      developer.log('ℹ️ No pending deep links after login', name: 'DeepLinkHandler');
    }
  }

  /// Manual navigation helper
  void navigateToUserDashboard({String? tableId, String? businessId}) {
    developer.log('🧭 Manual navigation', name: 'DeepLinkHandler');
    developer.log('   Table ID: $tableId', name: 'DeepLinkHandler');
    developer.log('   Business ID: $businessId', name: 'DeepLinkHandler');

    final context = AppRoutes.router.routerDelegate.navigatorKey.currentContext;

    if (context != null && context.mounted) {
      final extraData = <String, dynamic>{};
      if (tableId != null) extraData['table_id'] = tableId;
      if (businessId != null) extraData['business_id'] = businessId;

      context.go(
        AppRoutes.userHome,
        extra: extraData.isNotEmpty ? extraData : null,
      );
      developer.log('✅ Manual navigation successful', name: 'DeepLinkHandler');
    } else {
      developer.log('❌ Cannot navigate: context not available', name: 'DeepLinkHandler');
    }
  }
}