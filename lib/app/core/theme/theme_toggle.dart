import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'theme_service.dart';
import 'app_theme.dart';

class ThemeToggleButton extends GetView<ThemeController> {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => GestureDetector(
      onTap: () => controller.toggleTheme(),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.darkSurfaceVariant
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: isDark
              ? AppTheme.darkShadowSmall
              : AppTheme.shadowSmall,
          border: Border.all(
            color: isDark
                ? AppTheme.primaryLight.withOpacity(0.2)
                : AppTheme.primary.withOpacity(0.1),
            width: 1.5.w,
          ),
        ),
        child: Stack(
          children: [
            // Animated background gradient
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                gradient: controller.isDarkMode
                    ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryLight.withOpacity(0.15),
                    AppTheme.accentLight.withOpacity(0.1),
                  ],
                )
                    : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary.withOpacity(0.08),
                    AppTheme.accent.withOpacity(0.05),
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
                      turns: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Icon(
                  controller.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  key: ValueKey(controller.isDarkMode),
                  color: controller.isDarkMode
                      ? AppTheme.primaryLight
                      : AppTheme.primary,
                  size: 24.sp,
                ),
              ),
            ),

            // Ripple effect overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.toggleTheme(),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  splashColor: (controller.isDarkMode
                      ? AppTheme.primaryLight
                      : AppTheme.primary).withOpacity(0.2),
                  highlightColor: (controller.isDarkMode
                      ? AppTheme.primaryLight
                      : AppTheme.primary).withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// Alternative compact version for app bars
class ThemeToggleIconButton extends GetView<ThemeController> {
  const ThemeToggleIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
      onPressed: () => controller.toggleTheme(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          controller.isDarkMode
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
          key: ValueKey(controller.isDarkMode),
        ),
      ),
      tooltip: controller.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    ));
  }
}