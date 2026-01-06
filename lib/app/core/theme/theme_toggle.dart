import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_service.dart';
import 'app_theme.dart';

class ThemeToggleButton extends GetView<ThemeController> {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = controller.isDarkMode;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => controller.toggleTheme(),
          child: Container(
            width: 56.0,  // Fixed desktop size
            height: 56.0,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: isDark
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isDark
                    ? AppTheme.primaryLight.withOpacity(0.25)
                    : AppTheme.primary.withOpacity(0.15),
                width: 2.0,
              ),
            ),
            child: Stack(
              children: [
                // Animated background gradient
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: isDark
                        ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryLight.withOpacity(0.18),
                        AppTheme.accentLight.withOpacity(0.12),
                      ],
                    )
                        : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primary.withOpacity(0.1),
                        AppTheme.accent.withOpacity(0.06),
                      ],
                    ),
                  ),
                ),

                // Icon with animation
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: RotationTransition(
                          turns: Tween<double>(begin: 0.8, end: 1.0)
                              .animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      key: ValueKey(isDark),
                      color: isDark
                          ? AppTheme.primaryLight
                          : AppTheme.primary,
                      size: 28.0,  // Fixed desktop icon size
                    ),
                  ),
                ),

                // Ripple effect overlay
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.toggleTheme(),
                      borderRadius: BorderRadius.circular(16.0),
                      splashColor: (isDark
                          ? AppTheme.primaryLight
                          : AppTheme.primary)
                          .withOpacity(0.25),
                      highlightColor: (isDark
                          ? AppTheme.primaryLight
                          : AppTheme.primary)
                          .withOpacity(0.15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
