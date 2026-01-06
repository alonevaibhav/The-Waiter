import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/auth/login.responsive.dart';
import '../modules/view/chef/chef_dashboard.dart';
import '../modules/view/manager/dashboard/manager_dashboard.dart';
import '../modules/view/user/view/cart/cart_screen.dart';
import '../modules/view/user/view/cart/checkout_screen.dart';
import '../modules/view/user/view/cart/order_success_screen.dart';
import '../modules/view/user/view/user_dashboard.dart';
import '../modules/widgets/route_error_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route paths - Auth
  static const login = '/login';

  // Route paths - Manager
  static const managerHome = '/managerHome';
  static const managerPermission = 'permission';

  // Route paths - User
  static const userHome = '/userHome';
  static const cartScreen = 'cartScreen';
  static const checkoutScreen = 'checkoutScreen';
  static const orderSuccess = 'orderSuccess';


  // Route paths - Chef
  static const chefHome = '/chefHome';
  static const chefPermission = 'permission';

  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // GoRouter instance
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: login, // Start at login
    debugLogDiagnostics: true,

    errorPageBuilder: (context, state) {
      developer.log(
        'Navigation error: ${state.error}',
        name: 'AppRoutes',
        error: state.error,
      );
      return MaterialPage(
        key: state.pageKey,
        child: ErrorScreen(error: state.error),
      );
    },

    routes: [
      // Login Route
      GoRoute(
        path: login,
        builder: (context, state) {
          return LoginResponsive();
        },
      ),
      // GoRoute(
      //   path: login,
      //   builder: (context, state) {
      //     return UserDashboard();
      //   },
      // ),

      // Manager Routes
      GoRoute(
        path: managerHome,
        builder: (context, state) {
          return DashboardView();
        },
        routes: [
          GoRoute(
            path: managerPermission,
            builder: (context, state) {
              return Placeholder();
            },
          ),
        ],
      ),

      // User Routes
      GoRoute(
        path: userHome,
        builder: (context, state) {
          return UserDashboard();
        },
        routes: [
          GoRoute(
            path: cartScreen,
            builder: (context, state) {
              return CartScreen();
            },
          ),
          GoRoute(
            path: checkoutScreen,
            builder: (context, state) {
              return CheckoutScreen();
            },
          ),
          GoRoute(
            path: orderSuccess,
            builder: (context, state) {
              final orderDetails = state.extra as Map<String, dynamic>;
              return OrderSuccessScreen(orderDetails: orderDetails);
            },
          ),

        ],
      ),

      // Chef Routes
      GoRoute(
        path: chefHome,
        builder: (context, state) {
          return ChefDashboard();
        },
        routes: [
          GoRoute(
            path: chefPermission,
            builder: (context, state) {
              return Placeholder();
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

  static String get currentLocation =>
      router.routerDelegate.currentConfiguration.uri.toString();

  // Auth Navigation
  static void goToLogin() {
    developer.log('Go to Login', name: 'NavigationService');
    router.go(AppRoutes.login);
  }

  // Manager Navigation
  static void goToManagerHome() {
    developer.log('Go to Manager Home', name: 'NavigationService');
    router.go(AppRoutes.managerHome);
  }

  static void pushToManagerPermission() {
    developer.log('Push Manager Permission Screen', name: 'NavigationService');
    router.push('${AppRoutes.managerHome}/${AppRoutes.managerPermission}');
  }

  // User Navigation
  static void goToUserHome() {
    developer.log('Go to User Home', name: 'NavigationService');
    router.go(AppRoutes.userHome);
  }

  static void pushToCartScreen() {
    developer.log('Push User Permission Screen', name: 'NavigationService');
    router.push('${AppRoutes.userHome}/${AppRoutes.cartScreen}');
  }
  static void pushToCheckoutScreen() {
    developer.log('Push User Permission Screen', name: 'NavigationService');
    router.push('${AppRoutes.userHome}/${AppRoutes.checkoutScreen}');
  }


  static void pushToOrderSuccess(Map<String, dynamic> orderDetails) {
    developer.log('Push Order Success Screen', name: 'NavigationService');
    router.go(
      '${AppRoutes.userHome}/${AppRoutes.orderSuccess}',
      extra: orderDetails,
    );
  }
  // Chef Navigation
  static void goToChefHome() {
    developer.log('Go to Chef Home', name: 'NavigationService');
    router.go(AppRoutes.chefHome);
  }

  static void pushToChefPermission() {
    developer.log('Push Chef Permission Screen', name: 'NavigationService');
    router.push('${AppRoutes.chefHome}/${AppRoutes.chefPermission}');
  }

  // Generic Navigation based on role
  static void goToHomeByRole(String role) {
    developer.log('Go to Home for role: $role', name: 'NavigationService');
    switch (role.toLowerCase()) {
      case 'manager':
        goToManagerHome();
        break;
      case 'user':
        goToUserHome();
        break;
      case 'chef':
        goToChefHome();
        break;
      default:
        developer.log('Unknown role: $role', name: 'NavigationService');
        goToLogin(); // Fallback to login for unknown roles
    }
  }

  // Back navigation
  static void goBack() {
    if (router.canPop()) {
      developer.log('Pop route', name: 'NavigationService');
      router.pop();
    } else {
      developer.log('No route to pop', name: 'NavigationService');
    }
  }

  static bool canGoBack() => router.canPop();
}
