import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../constants/app_colors.dart';
import '../../theme/controllers/theme_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.user.value;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: controller.navigateToHome,
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Image with edit option
                  GestureDetector(
                    onTap: controller.updateProfileImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              user.getInitials(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        // Loading overlay for image upload
                        Obx(
                          () => controller.isUploadingImage.value
                              ? Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  // Stats
                  Row(
                    children: [
                      _buildStatItem(
                        'Posts',
                        '${controller.getUserPostCount()}',
                      ),
                      _buildStatItem(
                        'Comments',
                        '${controller.getUserCommentCount()}',
                      ),
                      _buildStatItem(
                        'Joined',
                        user.createdAt?.split('-')[0] ?? '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.article_outlined,
                    title: 'My Posts',
                    onTap: () {
                      Get.snackbar(
                        'Coming Soon',
                        'My posts feature coming soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.comment_outlined,
                    title: 'My Comments',
                    onTap: () {
                      Get.snackbar(
                        'Coming Soon',
                        'My comments feature coming soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Obx(
                      () => Switch(
                        value: themeController.isDarkMode.value,
                        onChanged: (_) => themeController.toggleTheme(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Show notification permission status
                      Get.snackbar(
                        'Notifications',
                        'Notification service is active',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('About Blog App'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Version: 1.0.0'),
                              const SizedBox(height: 8),
                              const Text(
                                'A modern blog application built with Flutter and GetX.',
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Features:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text('• Read blog posts'),
                              const Text('• Create and edit posts'),
                              const Text('• Comment on posts'),
                              const Text('• Dark mode support'),
                              const Text('• Local notifications'),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: controller.logout,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Send Welcome Notification Button (for testing)
                  TextButton(
                    onPressed: controller.sendWelcomeNotification,
                    child: const Text(
                      'Send Test Notification',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
