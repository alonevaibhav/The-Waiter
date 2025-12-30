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

    // Debug prints (remove these in production)
    print('Current breakpoint: ${breakpoints.breakpoint.name}');
    print('Screen width: ${MediaQuery.of(context).size.width}');

    // Check breakpoints in order: Desktop -> Tablet -> Mobile
    if (breakpoints.isDesktop || breakpoints.equals('4K')) {
      // >= 801px
      print('✅ Using DESKTOP layout');
      return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
    } else if (breakpoints.isTablet) {
      // 451px - 800px
      print('✅ Using TABLET layout');
      return tablet ?? mobile ?? desktop ?? const SizedBox.shrink();
    } else {
      // 0px - 450px
      print('✅ Using MOBILE layout');
      return mobile ?? tablet ?? desktop ?? const SizedBox.shrink();
    }
  }
}