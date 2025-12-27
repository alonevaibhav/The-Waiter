
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/core/services/app_initilizer.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/theme/theme_service.dart';
import 'app/core/widgets/connection_widget.dart';
import 'app/route/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //App Initialization
  await AppInitializer.initialize();

  developer.log('App Initialized Successfully ✅✅✅ ', name: 'main');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeController.themeModeNotifier,
          builder: (context, themeMode, child) {
            return ConnectivityWrapper(
              child: MaterialApp.router(
                title: 'The Waiter',
                debugShowCheckedModeBanner: false,
                routerConfig: AppRoutes.router,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                // Add this navigator key
              ),
            );
          },
        );
      },
    );
  }
}