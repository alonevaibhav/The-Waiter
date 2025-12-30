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

    if (breakpoints.largerThan(TABLET)) {
      return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
    } else if (breakpoints.between(MOBILE, DESKTOP)) {
      return tablet ?? mobile ?? desktop ?? const SizedBox.shrink();
    } else {
      return mobile ?? tablet ?? desktop ?? const SizedBox.shrink();
    }
  }
}
