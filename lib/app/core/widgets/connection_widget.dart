
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../route/app_routes.dart';
import '../Utils/snakbar_util.dart';
import '../services/connectivity_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late ConnectivityController _connectivityController;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _currentSnackBar;

  @override
  void initState() {
    super.initState();
    _connectivityController = Get.find<ConnectivityController>();

    // Delay setup to ensure navigator is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupCallbacks();
    });
  }

  void _setupCallbacks() {
    developer.log('Setting up connectivity callbacks', name: 'ConnectivityWrapper');

    // Set up the callbacks to show snackbars using navigator key
    _connectivityController.onShowError = (message, title, duration) {
      developer.log('onShowError callback triggered', name: 'ConnectivityWrapper');
      final context = AppRoutes.navigatorKey.currentContext;
      if (context != null && mounted) {
        developer.log('Showing error snackbar', name: 'ConnectivityWrapper');
        _dismissCurrentSnackBar();
        _currentSnackBar = SnackBarUtil.showError(
          context,
          message,
          title: title,
          duration: const Duration(days: 365), // Keep showing until dismissed
          dismissible: false, // Cannot be swiped away
        );
      } else {
        developer.log('Context is null or not mounted', name: 'ConnectivityWrapper');
      }
    };

    _connectivityController.onShowSuccess = (message, title, duration) {
      developer.log('onShowSuccess callback triggered', name: 'ConnectivityWrapper');
      final context = AppRoutes.navigatorKey.currentContext;
      if (context != null && mounted) {
        developer.log('Showing success snackbar', name: 'ConnectivityWrapper');
        _dismissCurrentSnackBar();
        _currentSnackBar = SnackBarUtil.showSuccess(
          context,
          message,
          title: title,
          duration: duration ?? const Duration(seconds: 3),
          dismissible: true, // Can be dismissed
        );
      } else {
        developer.log('Context is null or not mounted', name: 'ConnectivityWrapper');
      }
    };

    _connectivityController.onShowWarning = (message, title, duration) {
      developer.log('onShowWarning callback triggered', name: 'ConnectivityWrapper');
      final context = AppRoutes.navigatorKey.currentContext;
      if (context != null && mounted) {
        developer.log('Showing warning snackbar', name: 'ConnectivityWrapper');
        _dismissCurrentSnackBar();
        _currentSnackBar = SnackBarUtil.showWarning(
          context,
          message,
          title: title,
          duration: const Duration(days: 365), // Keep showing until dismissed
          dismissible: false, // Cannot be swiped away
        );
      } else {
        developer.log('Context is null or not mounted', name: 'ConnectivityWrapper');
      }
    };

    _connectivityController.onShowInfo = (message, title, duration) {
      developer.log('onShowInfo callback triggered', name: 'ConnectivityWrapper');
      final context = AppRoutes.navigatorKey.currentContext;
      if (context != null && mounted) {
        developer.log('Showing info snackbar', name: 'ConnectivityWrapper');
        _dismissCurrentSnackBar();
        _currentSnackBar = SnackBarUtil.showInfo(
          context,
          message,
          title: title,
          duration: duration ?? const Duration(seconds: 3),
          dismissible: true, // Can be dismissed
        );
      } else {
        developer.log('Context is null or not mounted', name: 'ConnectivityWrapper');
      }
    };

    developer.log('Callbacks setup complete', name: 'ConnectivityWrapper');
  }

  void _dismissCurrentSnackBar() {
    if (_currentSnackBar != null) {
      try {
        _currentSnackBar!.close();
        developer.log('Dismissed current snackbar', name: 'ConnectivityWrapper');
      } catch (e) {
        developer.log('Error dismissing snackbar: $e', name: 'ConnectivityWrapper', error: e);
      }
      _currentSnackBar = null;
    }
  }

  @override
  void dispose() {
    _dismissCurrentSnackBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}