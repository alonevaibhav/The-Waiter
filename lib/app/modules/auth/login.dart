import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/theme_toggle.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LoginController controller = Get.put(LoginController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // Left Side - Branding
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Title with Theme Toggle Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Restaurant Management',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Theme Toggle Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: ThemeToggleIconButton(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'Manage your restaurant operations\nwith ease and efficiency',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 48),

                      // Features
                      _buildFeatureItem(
                        icon: Icons.inventory_2_outlined,
                        text: 'Menu & Inventory Management',
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.receipt_long_outlined,
                        text: 'Order Processing & Billing',
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.analytics_outlined,
                        text: 'Real-time Analytics & Reports',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right Side - Login Form
          Expanded(
            flex: 4,
            child: Container(
              color: isDark ? Color(0xFF1A1D2E) : Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 40),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 420),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLoginHeader(context, isDark),
                          const SizedBox(height: 40),
                          _buildEmailField(context, controller, isDark),
                          const SizedBox(height: 20),
                          _buildPasswordField(context, controller, isDark),
                          const SizedBox(height: 20),
                          _buildRoleDropdown(context, controller, isDark),
                          const SizedBox(height: 32),
                          _buildLoginButton(context, controller),
                          const SizedBox(height: 16),
                          _buildForgotPasswordButton(context, controller),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 32,
            color: isDark ? Colors.white : Color(0xFF1A1D2E),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, LoginController controller, bool isDark) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 14),
        prefixIcon: Icon(
          Icons.email_outlined,
          size: 20,
          color: theme.primaryColor,
        ),
        filled: true,
        fillColor: isDark ? Color(0xFF232738) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorStyle: TextStyle(
          fontSize: 12,
          height: 0.8,
        ),
        errorMaxLines: 2,
      ),
      validator: controller.validateEmail,
    );
  }

  Widget _buildPasswordField(BuildContext context, LoginController controller, bool isDark) {
    final theme = Theme.of(context);

    return Obx(
          () => TextFormField(
        controller: controller.passwordController,
        obscureText: controller.obscurePassword.value,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 20,
            color: theme.primaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscurePassword.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          filled: true,
          fillColor: isDark ? Color(0xFF232738) : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(
            fontSize: 12,
            height: 0.8,
          ),
          errorMaxLines: 2,
        ),
        validator: controller.validatePassword,
      ),
    );
  }

  Widget _buildRoleDropdown(BuildContext context, LoginController controller, bool isDark) {
    final theme = Theme.of(context);

    return Obx(
          () => DropdownButtonFormField<String>(
        value: controller.selectedRole.value,
        style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: 'Select Role',
          labelStyle: TextStyle(fontSize: 14),
          prefixIcon: Icon(
            Icons.person_outline,
            size: 20,
            color: theme.primaryColor,
          ),
          filled: true,
          fillColor: isDark ? Color(0xFF232738) : Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(
            fontSize: 12,
            height: 0.8,
          ),
          errorMaxLines: 2,
        ),
        items: controller.roles.map((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: controller.updateRole,
        validator: controller.validateRole,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginController controller) {
    final theme = Theme.of(context);

    return Obx(
          () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.handleLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context, LoginController controller) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: () => controller.handleForgotPassword(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}