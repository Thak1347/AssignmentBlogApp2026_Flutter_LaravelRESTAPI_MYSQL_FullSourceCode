
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final StorageService _storageService = Get.find<StorageService>();

  final isLoading = false.obs;
  final user = Rxn<UserModel>();
  final errorMessage = ''.obs;

  // Login
  final loginEmail = ''.obs;
  final loginPassword = ''.obs;

  // Register
  final registerName = ''.obs;
  final registerEmail = ''.obs;
  final registerEmailConfirmation = ''.obs;
  final registerPassword = ''.obs;
  final registerPasswordConfirmation = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final savedUser = _storageService.getUser();

    if (savedUser != null) {
      user.value = savedUser;
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    if (loginEmail.value.trim().isEmpty ||
        loginPassword.value.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authProvider.login(
        email: loginEmail.value.trim(),
        password: loginPassword.value,
      );

      if (response['token'] == null) {
        throw Exception('Login failed. Token was not returned.');
      }

      _storageService.saveToken(
        response['token'].toString(),
      );

      if (response['user'] == null) {
        throw Exception('Login failed. User data was not returned.');
      }

      final userData = UserModel.fromJson(
        Map<String, dynamic>.from(response['user']),
      );

      user.value = userData;

      _storageService.saveUser(userData);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = _cleanErrorMessage(e);

      Get.snackbar(
        'Login Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> register() async {
    final name = registerName.value.trim();
    final email = registerEmail.value.trim();
    final emailConfirmation =
        registerEmailConfirmation.value.trim();
    final password = registerPassword.value;
    final passwordConfirmation =
        registerPasswordConfirmation.value;

    // Required fields
    if (name.isEmpty ||
        email.isEmpty ||
        emailConfirmation.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }

    // Email confirmation
    if (email != emailConfirmation) {
      errorMessage.value = 'Emails do not match';
      return;
    }

    // Password confirmation
    if (password != passwordConfirmation) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    // Password length
    if (password.length < 8) {
      errorMessage.value =
          'Password must be at least 8 characters';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authProvider.register(
        name: name,
        email: email,
        emailConfirmation: emailConfirmation,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response['token'] == null) {
        throw Exception(
          'Registration failed. Token was not returned.',
        );
      }

      _storageService.saveToken(
        response['token'].toString(),
      );

      if (response['user'] == null) {
        throw Exception(
          'Registration failed. User data was not returned.',
        );
      }

      final userData = UserModel.fromJson(
        Map<String, dynamic>.from(response['user']),
      );

      user.value = userData;

       _storageService.saveUser(userData);

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = _cleanErrorMessage(e);

      Get.snackbar(
        'Registration Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      await _authProvider.logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
       _storageService.clearAll();

      user.value = null;

      Get.offAllNamed(AppRoutes.login);

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
    }
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  Future<void> getCurrentUser() async {
    try {
      final response = await _authProvider.getCurrentUser();

      if (response['user'] != null) {
        final userData = UserModel.fromJson(
          Map<String, dynamic>.from(response['user']),
        );

        user.value = userData;

         _storageService.saveUser(userData);
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    errorMessage.value = '';
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _cleanErrorMessage(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }

    return message;
  }
}

