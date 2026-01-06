//
//
// import 'dart:async';
// import 'dart:developer' as developer;
// import 'package:app_links/app_links.dart';
// import 'package:get/get.dart';
// import 'deeplink_controller.dart';
//
// class DeepLinkService {
//   static final DeepLinkService _instance = DeepLinkService._internal();
//   factory DeepLinkService() => _instance;
//   DeepLinkService._internal();
//
//   final AppLinks _appLinks = AppLinks();
//   StreamSubscription? _linkSubscription;
//
//   // Update these to match your app
//   static const String packageName = 'com.example.the_waiter';
//   static const String scheme = 'thewaiter';
//   static const String webDomain = 'the-waiter-1.vercel.app';
//   static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
//
//   /// Initialize deep link handling
//   Future<void> initialize() async {
//     developer.log('🔗 Initializing Deep Link Service', name: 'DeepLinkService');
//
//     // Ensure DeepLinkController is registered
//     if (!Get.isRegistered<DeepLinkController>()) {
//       Get.put(DeepLinkController(), permanent: true);
//     }
//
//     // Handle initial deep link (when app is opened from link)
//     await _handleInitialLink();
//
//     // Listen for deep links while app is running
//     _linkSubscription = _appLinks.uriLinkStream.listen(
//           (Uri uri) {
//         developer.log('📱 Deep Link Received: $uri', name: 'DeepLinkService');
//         _handleDeepLink(uri);
//       },
//       onError: (err) {
//         developer.log('❌ Deep link error: $err', name: 'DeepLinkService', error: err);
//       },
//     );
//   }
//
//   /// Handle initial link when app starts
//   Future<void> _handleInitialLink() async {
//     try {
//       final uri = await _appLinks.getInitialLink();
//       if (uri != null) {
//         developer.log('📱 Initial Deep Link: $uri', name: 'DeepLinkService');
//         _handleDeepLink(uri);
//       }
//     } catch (e) {
//       developer.log('❌ Failed to get initial link: $e', name: 'DeepLinkService', error: e);
//     }
//   }
//
//   /// Parse and handle the deep link
//   void _handleDeepLink(Uri uri) {
//     developer.log('🔍 Parsing Deep Link: ${uri.toString()}', name: 'DeepLinkService');
//     developer.log('   Scheme: ${uri.scheme}', name: 'DeepLinkService');
//     developer.log('   Host: ${uri.host}', name: 'DeepLinkService');
//     developer.log('   Path: ${uri.path}', name: 'DeepLinkService');
//     developer.log('   Query Parameters: ${uri.queryParameters}', name: 'DeepLinkService');
//
//     // Extract table ID and business ID from different formats
//     final deepLinkData = _extractDeepLinkData(uri);
//
//     if (deepLinkData['tableId'] != null || deepLinkData['businessId'] != null) {
//       developer.log('✅ Successfully extracted deep link data:', name: 'DeepLinkService');
//       developer.log('   Table ID: ${deepLinkData['tableId']}', name: 'DeepLinkService');
//       developer.log('   Business ID: ${deepLinkData['businessId']}', name: 'DeepLinkService');
//
//       // Store in controller
//       final deepLinkController = Get.find<DeepLinkController>();
//       deepLinkController.setPendingDeepLink(
//         tableId: deepLinkData['tableId'],
//         businessId: deepLinkData['businessId'],
//       );
//
//       developer.log('💾 Stored in DeepLinkController - will navigate after processing', name: 'DeepLinkService');
//       return;
//     }
//
//     // If we reach here, no valid data was found
//     developer.log('ℹ️ Generic app open - no routing needed', name: 'DeepLinkService');
//   }
//
//   /// Extract table ID and business ID from various deep link formats
//   ///
//   /// Supported formats:
//   /// 1. https://the-waiter-1.vercel.app?id=167
//   /// 2. https://the-waiter-1.vercel.app?table=5&business=167
//   /// 3. thewaiter://table/5?business=167
//   /// 4. thewaiter://open?table=5&business=167
//   /// 5. https://the-waiter-1.vercel.app/#/login?id=167
//   Map<String, String?> _extractDeepLinkData(Uri uri) {
//     String? tableId;
//     String? businessId;
//
//     // Format 1: Web URL with 'id' parameter (your format: ?id=business_id)
//     if (uri.host == webDomain || uri.host == 'the-waiter-1.vercel.app') {
//       developer.log('📍 Web URL format detected', name: 'DeepLinkService');
//
//       // Check for 'id' parameter (business_id)
//       if (uri.queryParameters.containsKey('id')) {
//         businessId = uri.queryParameters['id'];
//         developer.log('✅ Extracted business ID from ?id: $businessId', name: 'DeepLinkService');
//       }
//
//       // Check for 'table' parameter
//       if (uri.queryParameters.containsKey('table')) {
//         tableId = uri.queryParameters['table'];
//         developer.log('✅ Extracted table ID from ?table: $tableId', name: 'DeepLinkService');
//       }
//
//       // Check for 'business' parameter (alternative)
//       if (uri.queryParameters.containsKey('business')) {
//         businessId = uri.queryParameters['business'];
//         developer.log('✅ Extracted business ID from ?business: $businessId', name: 'DeepLinkService');
//       }
//
//       // Handle fragment-based URLs (like /#/login?id=167)
//       if (uri.fragment.isNotEmpty) {
//         developer.log('📍 Fragment detected: ${uri.fragment}', name: 'DeepLinkService');
//         final fragmentUri = Uri.parse('dummy://dummy${uri.fragment}');
//
//         if (fragmentUri.queryParameters.containsKey('id')) {
//           businessId = fragmentUri.queryParameters['id'];
//           developer.log('✅ Extracted business ID from fragment: $businessId', name: 'DeepLinkService');
//         }
//
//         if (fragmentUri.queryParameters.containsKey('table')) {
//           tableId = fragmentUri.queryParameters['table'];
//           developer.log('✅ Extracted table ID from fragment: $tableId', name: 'DeepLinkService');
//         }
//       }
//     }
//
//     // Format 2: App scheme - thewaiter://table/5?business=167
//     if (uri.scheme == scheme && uri.host == 'table') {
//       developer.log('📍 App scheme with table host detected', name: 'DeepLinkService');
//
//       if (uri.pathSegments.isNotEmpty) {
//         tableId = uri.pathSegments.first;
//         developer.log('✅ Extracted table ID from path: $tableId', name: 'DeepLinkService');
//       }
//
//       if (uri.queryParameters.containsKey('business') || uri.queryParameters.containsKey('id')) {
//         businessId = uri.queryParameters['business'] ?? uri.queryParameters['id'];
//         developer.log('✅ Extracted business ID from query: $businessId', name: 'DeepLinkService');
//       }
//     }
//
//     // Format 3: App scheme - thewaiter://open?table=5&business=167
//     if (uri.scheme == scheme && uri.host == 'open') {
//       developer.log('📍 App scheme with open host detected', name: 'DeepLinkService');
//
//       if (uri.queryParameters.containsKey('table')) {
//         tableId = uri.queryParameters['table'];
//         developer.log('✅ Extracted table ID: $tableId', name: 'DeepLinkService');
//       }
//
//       if (uri.queryParameters.containsKey('business') || uri.queryParameters.containsKey('id')) {
//         businessId = uri.queryParameters['business'] ?? uri.queryParameters['id'];
//         developer.log('✅ Extracted business ID: $businessId', name: 'DeepLinkService');
//       }
//     }
//
//     // Format 4: Generic query parameters
//     if (tableId == null && uri.queryParameters.containsKey('table_id')) {
//       tableId = uri.queryParameters['table_id'];
//       developer.log('✅ Extracted table ID from table_id param: $tableId', name: 'DeepLinkService');
//     }
//
//     if (businessId == null && uri.queryParameters.containsKey('business_id')) {
//       businessId = uri.queryParameters['business_id'];
//       developer.log('✅ Extracted business ID from business_id param: $businessId', name: 'DeepLinkService');
//     }
//
//     if (tableId == null && businessId == null) {
//       developer.log('❌ Could not extract any deep link data', name: 'DeepLinkService');
//     }
//
//     return {
//       'tableId': tableId,
//       'businessId': businessId,
//     };
//   }
//
//   /// Dispose resources
//   void dispose() {
//     _linkSubscription?.cancel();
//   }
// }


import 'dart:async';
import 'dart:developer' as developer;
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'deeplink_controller.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  // Update these to match your app
  static const String packageName = 'com.example.the_waiter';
  static const String scheme = 'thewaiter';
  static const String webDomain = 'the-waiter-1.vercel.app';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';

  /// Initialize deep link handling
  Future<void> initialize() async {
    developer.log('🔗 Initializing Deep Link Service', name: 'DeepLinkService');

    // Ensure DeepLinkController is registered
    if (!Get.isRegistered<DeepLinkController>()) {
      Get.put(DeepLinkController(), permanent: true);
    }

    // Handle initial deep link (when app is opened from link)
    await _handleInitialLink();

    // Listen for deep links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
          (Uri uri) {
        developer.log('📱 Deep Link Received: $uri', name: 'DeepLinkService');
        _handleDeepLink(uri);
      },
      onError: (err) {
        developer.log('❌ Deep link error: $err', name: 'DeepLinkService', error: err);
      },
    );
  }

  /// Handle initial link when app starts
  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        developer.log('📱 Initial Deep Link: $uri', name: 'DeepLinkService');
        _handleDeepLink(uri);
      }
    } catch (e) {
      developer.log('❌ Failed to get initial link: $e', name: 'DeepLinkService', error: e);
    }
  }

  /// Parse and handle the deep link
  void _handleDeepLink(Uri uri) {
    developer.log('🔍 Parsing Deep Link: ${uri.toString()}', name: 'DeepLinkService');
    developer.log('   Scheme: ${uri.scheme}', name: 'DeepLinkService');
    developer.log('   Host: ${uri.host}', name: 'DeepLinkService');
    developer.log('   Path: ${uri.path}', name: 'DeepLinkService');
    developer.log('   Query Parameters: ${uri.queryParameters}', name: 'DeepLinkService');

    // Extract table ID and business ID from different formats
    final deepLinkData = _extractDeepLinkData(uri);

    if (deepLinkData['tableId'] != null || deepLinkData['businessId'] != null) {
      developer.log('✅ Successfully extracted deep link data:', name: 'DeepLinkService');
      developer.log('   Table ID: ${deepLinkData['tableId']}', name: 'DeepLinkService');
      developer.log('   Business ID: ${deepLinkData['businessId']}', name: 'DeepLinkService');

      // Store in controller
      final deepLinkController = Get.find<DeepLinkController>();
      deepLinkController.setPendingDeepLink(
        tableId: deepLinkData['tableId'],
        businessId: deepLinkData['businessId'],
      );

      developer.log('💾 Stored in DeepLinkController - will navigate after processing', name: 'DeepLinkService');
      return;
    }

    // If we reach here, no valid data was found
    developer.log('ℹ️ Generic app open - no routing needed', name: 'DeepLinkService');
  }

  /// Extract table ID and business ID from various deep link formats
  ///
  /// Supported formats:
  /// 1. https://the-waiter-1.vercel.app?id=167 (id = table_id)
  /// 2. https://the-waiter-1.vercel.app?table=5&business=167
  /// 3. thewaiter://table/5?business=167
  /// 4. thewaiter://open?table=5&business=167
  /// 5. https://the-waiter-1.vercel.app/#/login?id=167
  Map<String, String?> _extractDeepLinkData(Uri uri) {
    String? tableId;
    String? businessId;

    // Format 1: Web URL - Primary format
    if (uri.host == webDomain || uri.host == 'the-waiter-1.vercel.app') {
      developer.log('📍 Web URL format detected', name: 'DeepLinkService');

      // PRIMARY FORMAT: ?id=table_number
      if (uri.queryParameters.containsKey('id')) {
        tableId = uri.queryParameters['id'];
        developer.log('✅ Extracted table ID from ?id: $tableId', name: 'DeepLinkService');
      }

      // Check for explicit 'table' parameter
      if (uri.queryParameters.containsKey('table')) {
        tableId = uri.queryParameters['table'];
        developer.log('✅ Extracted table ID from ?table: $tableId', name: 'DeepLinkService');
      }

      // Check for 'table_id' parameter
      if (uri.queryParameters.containsKey('table_id')) {
        tableId = uri.queryParameters['table_id'];
        developer.log('✅ Extracted table ID from ?table_id: $tableId', name: 'DeepLinkService');
      }

      // Check for 'business' or 'business_id' parameter
      if (uri.queryParameters.containsKey('business')) {
        businessId = uri.queryParameters['business'];
        developer.log('✅ Extracted business ID from ?business: $businessId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('business_id')) {
        businessId = uri.queryParameters['business_id'];
        developer.log('✅ Extracted business ID from ?business_id: $businessId', name: 'DeepLinkService');
      }

      // Handle fragment-based URLs (like /#/login?id=167)
      if (uri.fragment.isNotEmpty) {
        developer.log('📍 Fragment detected: ${uri.fragment}', name: 'DeepLinkService');
        final fragmentUri = Uri.parse('dummy://dummy${uri.fragment}');

        // Extract from fragment
        if (fragmentUri.queryParameters.containsKey('id')) {
          tableId = fragmentUri.queryParameters['id'];
          developer.log('✅ Extracted table ID from fragment ?id: $tableId', name: 'DeepLinkService');
        }

        if (fragmentUri.queryParameters.containsKey('table')) {
          tableId = fragmentUri.queryParameters['table'];
          developer.log('✅ Extracted table ID from fragment ?table: $tableId', name: 'DeepLinkService');
        }

        if (fragmentUri.queryParameters.containsKey('business')) {
          businessId = fragmentUri.queryParameters['business'];
          developer.log('✅ Extracted business ID from fragment: $businessId', name: 'DeepLinkService');
        }
      }
    }

    // Format 2: App scheme - thewaiter://table/5?business=167
    if (uri.scheme == scheme && uri.host == 'table') {
      developer.log('📍 App scheme with table host detected', name: 'DeepLinkService');

      if (uri.pathSegments.isNotEmpty) {
        tableId = uri.pathSegments.first;
        developer.log('✅ Extracted table ID from path: $tableId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('business')) {
        businessId = uri.queryParameters['business'];
        developer.log('✅ Extracted business ID from query: $businessId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('business_id')) {
        businessId = uri.queryParameters['business_id'];
        developer.log('✅ Extracted business ID from query: $businessId', name: 'DeepLinkService');
      }
    }

    // Format 3: App scheme - thewaiter://open?table=5&business=167
    if (uri.scheme == scheme && uri.host == 'open') {
      developer.log('📍 App scheme with open host detected', name: 'DeepLinkService');

      if (uri.queryParameters.containsKey('table')) {
        tableId = uri.queryParameters['table'];
        developer.log('✅ Extracted table ID from ?table: $tableId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('id')) {
        tableId = uri.queryParameters['id'];
        developer.log('✅ Extracted table ID from ?id: $tableId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('table_id')) {
        tableId = uri.queryParameters['table_id'];
        developer.log('✅ Extracted table ID from ?table_id: $tableId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('business')) {
        businessId = uri.queryParameters['business'];
        developer.log('✅ Extracted business ID from ?business: $businessId', name: 'DeepLinkService');
      }

      if (uri.queryParameters.containsKey('business_id')) {
        businessId = uri.queryParameters['business_id'];
        developer.log('✅ Extracted business ID from ?business_id: $businessId', name: 'DeepLinkService');
      }
    }

    if (tableId == null && businessId == null) {
      developer.log('❌ Could not extract any deep link data', name: 'DeepLinkService');
    }

    return {
      'tableId': tableId,
      'businessId': businessId,
    };
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
  }
}