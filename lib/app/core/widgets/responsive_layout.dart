import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Debug logs (remove in production)
    developer.log(
      'Current breakpoint: ${breakpoints.breakpoint.name}',
      name: 'ResponsiveLayout',
    );

    developer.log(
      'Screen width: $screenWidth',
      name: 'ResponsiveLayout',
    );

    if (breakpoints.isDesktop || breakpoints.equals('4K')) {
      developer.log(
        'Using DESKTOP layout',
        name: 'ResponsiveLayout',
        level: 800, // INFO
      );
      return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
    } else if (breakpoints.isTablet) {
      developer.log(
        'Using TABLET layout',
        name: 'ResponsiveLayout',
        level: 800,
      );
      return tablet ?? mobile ?? desktop ?? const SizedBox.shrink();
    } else {
      developer.log(
        'Using MOBILE layout',
        name: 'ResponsiveLayout',
        level: 800,
      );
      return mobile ?? tablet ?? desktop ?? const SizedBox.shrink();
    }
  }
}
