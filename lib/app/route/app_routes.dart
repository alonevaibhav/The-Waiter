

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/no use/cache/api_test_log.dart';
import '../modules/no use/permission_view.dart';
import '../modules/view/manager/dashboard/manager_dashboard.dart';
import '../modules/view/menu_screen.dart';
import '../modules/widgets/route_error_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route paths
  static const home = '/home';
  static const permission = 'permission';

  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  // GoRouter instance
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: home,
    debugLogDiagnostics: true,

    errorBuilder: (context, state) {
      developer.log(
        'Navigation error: ${state.error}',
        name: 'AppRoutes',
        error: state.error,
      );
      return ErrorScreen(error: state.error);
    },

    routes: [
      GoRoute(
        path: home,
        builder: (context, state) {
          return DashboardView();
        },
        routes: [
          GoRoute(
            path: permission,
            builder: (context, state) {
              return IntegratedPermissionDemoScreen();
            },
          ),
        ],
      ),
    ],
  );
}




class NavigationService {
  NavigationService._();

  static GoRouter get router => AppRoutes.router;
  static GlobalKey<NavigatorState> get navigatorKey => AppRoutes.navigatorKey;

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static String get currentLocation => router.routerDelegate.currentConfiguration.uri.toString();

  /// Replace stack → used for login / splash
  static void goToHome() {
    developer.log('Go to Home', name: 'NavigationService');
    router.go(AppRoutes.home);
  }

  /// Push → back button works
  static void pushToPermission() {
    developer.log('Push Permission Screen', name: 'NavigationService');
    router.push('${AppRoutes.home}/${AppRoutes.permission}');
  }

  /// Back navigation
  static void goBack() {
    if (router.canPop()) {
      developer.log('Pop route', name: 'NavigationService');
      router.pop();
    } else {
      developer.log(
        'No route to pop',
        name: 'NavigationService',
      );
    }
  }

  static bool canGoBack() => router.canPop();
}
