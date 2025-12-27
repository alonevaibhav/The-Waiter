// import 'dart:developer' as developer;
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../route/app_bindings.dart';
// import '../theme/theme_service.dart';
// import 'api_service.dart';
// import 'connectivity_service.dart';
// import 'notification_service.dart';
//
// class AppInitializer {
//   static Future<void> initialize() async {
//     developer.log('Starting App Initialization...', name: 'AppInitializer');
//
//     try {
//
//       // Initialize App Bindings
//       developer.log('Initializing App Bindings...', name: 'AppInitializer');
//       AppBindings().dependencies();
//       developer.log('App Bindings initialized', name: 'AppInitializer');
//
//       // 1. Initialize GetStorage
//       developer.log('Initializing GetStorage...', name: 'AppInitializer');
//       await GetStorage.init();
//       developer.log('GetStorage initialized', name: 'AppInitializer');
//
//       // 2. Initialize API Service
//       developer.log('Initializing API Service...', name: 'AppInitializer');
//       await ApiService.init();
//       developer.log('API Service initialized', name: 'AppInitializer');
//
//       // 3. Initialize notification service
//       developer.log('Initializing Notification Service...', name: 'AppInitializer',);
//       await Get.putAsync(() => NotificationService().init());
//       developer.log('Notification Service initialized', name: 'AppInitializer',);
//
//       // 4. Initialize Theme Controller
//       developer.log('Initializing Theme Controller...', name: 'AppInitializer');
//       Get.put(ThemeController(), permanent: true);
//       developer.log('Theme Controller initialized', name: 'AppInitializer');
//
//       // 5. Initialize Connectivity Controller
//       developer.log('Initializing Connectivity Controller...', name: 'AppInitializer',);
//       Get.put(ConnectivityController(),permanent: true);
//       developer.log('Connectivity Controller initialized', name: 'AppInitializer',);
//
//
//
//
//
//
//
//       developer.log('App Initialization Complete ✓', name: 'AppInitializer',);
//     } catch (e, stackTrace) {
//       developer.log(
//         'App initialization failed',
//         name: 'AppInitializer',
//         error: e,
//         stackTrace: stackTrace,
//       );
//       rethrow;
//     }
//   }
// }


import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../route/app_bindings.dart';
import '../theme/theme_service.dart';
import 'api_service.dart';
import 'cache_service.dart';
import 'connectivity_service.dart';
import 'notification_service.dart';

class AppInitializer {
  static Future<void> initialize() async {
    developer.log('🚀 Starting App Initialization...', name: 'AppInitializer');

    try {

      developer.log('📦 Initializing GetStorage...', name: 'AppInitializer');
      await GetStorage.init();
      developer.log('✅ GetStorage initialized', name: 'AppInitializer');

      developer.log('🎨 Initializing Theme Controller...', name: 'AppInitializer');
      Get.put(ThemeController(), permanent: true);
      developer.log('✅ Theme Controller initialized', name: 'AppInitializer');

      // 3. Initialize App Bindings
      developer.log('🔗 Initializing App Bindings...', name: 'AppInitializer');
      AppBindings().dependencies();
      developer.log('✅ App Bindings initialized', name: 'AppInitializer');

      // 4. Initialize API Service
      developer.log('🌐 Initializing API Service...', name: 'AppInitializer');
      await ApiService.init();
      developer.log('✅ API Service initialized', name: 'AppInitializer');

      developer.log('🗃️ Initializing Cache Service...', name: 'AppInitializer');
      await Get.putAsync(() => CacheService().init());
      developer.log('✅ Cache Service initialized', name: 'AppInitializer');

      // 5. Initialize notification service
      developer.log('🔔 Initializing Notification Service...', name: 'AppInitializer');
      await Get.putAsync(() => NotificationService().init());
      developer.log('✅ Notification Service initialized', name: 'AppInitializer');

      // 6. Initialize Connectivity Controller
      developer.log('📡 Initializing Connectivity Controller...', name: 'AppInitializer');
      Get.put(ConnectivityController(), permanent: true);
      developer.log('✅ Connectivity Controller initialized', name: 'AppInitializer');








      developer.log(' App Initialization Complete!', name: 'AppInitializer');
    } catch (e, stackTrace) {
      developer.log(
        '❌ App initialization failed',
        name: 'AppInitializer',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}