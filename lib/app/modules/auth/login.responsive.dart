import 'package:flutter/cupertino.dart';

import '../../core/widgets/responsive_layout.dart';
import 'login.dart';
import 'mobile_login_screen.dart';

class LoginResponsive extends StatelessWidget {
  const LoginResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: MobileLoginScreen(),
      // tablet: LoginScreen(),
      desktop: LoginScreen(),
    );
  }
}
