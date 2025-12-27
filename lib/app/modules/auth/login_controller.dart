import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class LoginController extends GetxController {
  final box = GetStorage();

  // Observable variables
  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final currentStep = 0.obs; // 0 for Employee ID, 1 for Password

  // Form keys
  final employeeIdFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkStoredCredentials();
  }

  @override
  void onClose() {
    employeeIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void checkStoredCredentials() async {
    final storedEmployeeId = box.read('employee_id');
    if (storedEmployeeId != null) {
      employeeIdController.text = storedEmployeeId;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToPasswordStep() {
    if (employeeIdFormKey.currentState!.validate()) {
      currentStep.value = 1;
      box.write('employee_id', employeeIdController.text);
    }
  }

  void goBackToEmployeeId() {
    currentStep.value = 0;
    passwordController.clear();
  }

  String? validateEmployeeId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Employee ID';
    }
    if (value.length < 3) {
      return 'Employee ID must be at least 3 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  Future<void> login() async {
    if (passwordFormKey.currentState?.validate() != true) return;

    isLoading.value = true;

    // ⏳ Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Temporary success response
      Fluttertoast.showToast(
        msg: "Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login Failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

}
