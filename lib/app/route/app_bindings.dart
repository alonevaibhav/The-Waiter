import 'dart:developer' as developer;

import 'package:get/get.dart';
import '../core/theme/theme_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register all controllers here
    developer.log(
      'Registering ThemeController in AppBindings...',
      name: 'AppBindings',
    );


    Get.put(ThemeController(), permanent: true);
    // Get.lazyPut<LoginViewController>(() => LoginViewController(), fenix: true);
  }
}
