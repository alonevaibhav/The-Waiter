//
//
// import 'dart:developer' as developer;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// class ThemeController extends GetxController {
//   final _storage = GetStorage();
//   final _key = 'theme_mode';
//
//   // Keep GetX observable for other widgets
//   Rx<ThemeMode> themeMode = ThemeMode.system.obs;
//
//   // Add ValueNotifier for MaterialApp (more efficient)
//   late final ValueNotifier<ThemeMode> themeModeNotifier;
//
//   @override
//   void onInit() {
//     super.onInit();
//     developer.log('Initializing ThemeController...', name: 'ThemeController');
//
//     _loadThemeFromStorage();
//
//     // Initialize ValueNotifier with current theme
//     themeModeNotifier = ValueNotifier(themeMode.value);
//
//     // Keep both in sync
//     ever(themeMode, (mode) {
//       themeModeNotifier.value = mode;
//     });
//
//   }
//
//   @override
//   void onClose() {
//     themeModeNotifier.dispose();
//     super.onClose();
//   }
//
//   void _loadThemeFromStorage() {
//     final savedTheme = _storage.read(_key);
//     if (savedTheme != null) {
//       themeMode.value = _themeModeFromString(savedTheme);
//     }
//   }
//
//   Future<void> setThemeMode(ThemeMode mode) async {
//     themeMode.value = mode;
//     await _storage.write(_key, _themeModeToString(mode));
//   }
//
//   void toggleTheme() {
//     final newMode = themeMode.value == ThemeMode.light
//         ? ThemeMode.dark
//         : ThemeMode.light;
//     setThemeMode(newMode);
//   }
//
//   ThemeMode _themeModeFromString(String mode) {
//     switch (mode) {
//       case 'light': return ThemeMode.light;
//       case 'dark': return ThemeMode.dark;
//       default: return ThemeMode.system;
//     }
//   }
//
//
//
//   String _themeModeToString(ThemeMode mode) {
//     switch (mode) {
//       case ThemeMode.light: return 'light';
//       case ThemeMode.dark: return 'dark';
//       default: return 'system';
//     }
//   }
//
//   bool get isDarkMode => themeMode.value == ThemeMode.dark;
//   bool get isLightMode => themeMode.value == ThemeMode.light;
//   bool get isSystemMode => themeMode.value == ThemeMode.system;
// }

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static const String _storageKey = 'theme_mode';
  late final GetStorage _storage;

  // Keep GetX observable for other widgets
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs; // Default to light instead of system

  // Add ValueNotifier for MaterialApp (more efficient)
  late final ValueNotifier<ThemeMode> themeModeNotifier;

  @override
  void onInit() {
    super.onInit();
    developer.log('🎨 Initializing ThemeController...', name: 'ThemeController');

    // Initialize storage instance
    _storage = GetStorage();

    // Load theme from storage FIRST
    _loadThemeFromStorage();

    // Initialize ValueNotifier with loaded theme
    themeModeNotifier = ValueNotifier(themeMode.value);

    // Keep both in sync
    ever(themeMode, (mode) {
      developer.log('📱 Theme changed to: $mode', name: 'ThemeController');
      themeModeNotifier.value = mode;
    });

    developer.log('✅ ThemeController initialized with mode: ${themeMode.value}',
        name: 'ThemeController');
  }

  @override
  void onClose() {
    themeModeNotifier.dispose();
    super.onClose();
  }

  void _loadThemeFromStorage() {
    try {
      final savedTheme = _storage.read<String>(_storageKey);

      developer.log(
          '📖 Reading theme from storage: $savedTheme',
          name: 'ThemeController'
      );

      if (savedTheme != null && savedTheme.isNotEmpty) {
        final loadedMode = _themeModeFromString(savedTheme);
        themeMode.value = loadedMode;
        developer.log(
            '✅ Theme loaded successfully: $loadedMode',
            name: 'ThemeController'
        );
      } else {
        developer.log(
            '⚠️ No saved theme found, using system default',
            name: 'ThemeController'
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error loading theme from storage',
        name: 'ThemeController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      developer.log(
          '💾 Saving theme mode: $mode',
          name: 'ThemeController'
      );

      // Update the observable
      themeMode.value = mode;

      // Save to storage
      final modeString = _themeModeToString(mode);
      await _storage.write(_storageKey, modeString);

      developer.log(
          '✅ Theme saved successfully: $modeString',
          name: 'ThemeController'
      );

      // Verify the save
      final verification = _storage.read<String>(_storageKey);
      developer.log(
          '🔍 Verification - Stored value: $verification',
          name: 'ThemeController'
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error saving theme to storage',
        name: 'ThemeController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void toggleTheme() {
    final currentMode = themeMode.value;
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    developer.log(
        '🔄 Toggling theme from $currentMode to $newMode',
        name: 'ThemeController'
    );

    setThemeMode(newMode);
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        developer.log(
            '⚠️ Unknown theme mode: $mode, defaulting to system',
            name: 'ThemeController'
        );
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
  bool get isLightMode => themeMode.value == ThemeMode.light;
  bool get isSystemMode => themeMode.value == ThemeMode.system;
}