import 'package:blog_app/app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../auth/controllers/auth_controller.dart';
import '../../../services/notification_service.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final isLoading = false.obs;
  final isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure user data is loaded
    _authController.getCurrentUser();
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _authController.logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void goBack() {
    Get.back();
  }

  void navigateToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> updateProfileImage() async {
    try {
      isUploadingImage.value = true;

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        // TODO: Implement profile image upload to API
        // await _authProvider.updateProfileImage(file);

        Get.snackbar(
          'Success',
          'Profile image updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade700,
        );

        // Refresh user data
        await _authController.getCurrentUser();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> sendWelcomeNotification() async {
    final user = _authController.user.value;
    if (user != null) {
      await _notificationService.showWelcomeNotification(user.name);
    }
  }

  // Get user posts count (from the list)
  int getUserPostCount() {
    // You can implement this by fetching user posts
    return 0;
  }

  // Get user comments count
  int getUserCommentCount() {
    // You can implement this by fetching user comments
    return 0;
  }
}
