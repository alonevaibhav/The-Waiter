import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/Utils/snakbar_util.dart';
import '../../route/app_routes.dart';

class LoginController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final selectedRole = Rxn<String>();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  // Role list
  final List<String> roles = ['Manager', 'User', 'Chef'];

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Update selected role
  void updateRole(String? role) {
    selectedRole.value = role;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validate role
  String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a role';
    }
    return null;
  }

  // Handle login
  Future<void> handleLogin(context) async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Navigate based on role
        if (selectedRole.value != null) {
          NavigationService.goToHomeByRole(selectedRole.value!);


          // Show success message
          SnackBarUtil.showSuccess(
            context,
            'Login successful',
            title: 'Success',
            duration: const Duration(seconds: 2),
            dismissible: true,
          );
        }
      } catch (e) {
        // Handle error
        SnackBarUtil.showError(
          context,
          'Login failed. Please try again.',
          title: 'Error',
          duration: const Duration(seconds: 2),
          dismissible: true,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Handle forgot password
  void handleForgotPassword(BuildContext context) {
    SnackBarUtil.showInfo(
      context,
      'Password reset link will be sent to your email',
      title: 'Forgot Password',
      duration: const Duration(seconds: 2),
      dismissible: true,
    );
    // Navigate to forgot password screen or show dialog
    // Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
