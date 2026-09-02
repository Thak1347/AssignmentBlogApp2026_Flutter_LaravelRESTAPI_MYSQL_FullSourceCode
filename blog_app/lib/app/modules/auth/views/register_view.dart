
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 16),

              // Header icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Join our community today',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 32),

              // ==================================================
              // NAME
              // ==================================================

              TextField(
                onChanged: (value) {
                  controller.registerName.value = value;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // EMAIL
              // ==================================================

              TextField(
                onChanged: (value) {
                  controller.registerEmail.value = value;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // CONFIRM EMAIL
              // ==================================================

              Obx(
                () => TextField(
                  onChanged: (value) {
                    controller.registerEmailConfirmation.value =
                        value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Confirm Email',
                    hintText: 'Enter your email again',
                    prefixIcon: const Icon(
                      Icons.mark_email_read_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText:
                        controller
                                .registerEmailConfirmation
                                .value
                                .isNotEmpty &&
                            controller.registerEmail.value !=
                                controller
                                    .registerEmailConfirmation
                                    .value
                        ? 'Emails do not match'
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // PASSWORD
              // ==================================================

              TextField(
                onChanged: (value) {
                  controller.registerPassword.value = value;
                },
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password (min 8 characters)',
                  prefixIcon: const Icon(
                    Icons.lock_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // CONFIRM PASSWORD
              // ==================================================

              Obx(
                () => TextField(
                  onChanged: (value) {
                    controller
                        .registerPasswordConfirmation
                        .value = value;
                  },
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText:
                        controller
                                .registerPasswordConfirmation
                                .value
                                .isNotEmpty &&
                            controller.registerPassword.value !=
                                controller
                                    .registerPasswordConfirmation
                                    .value
                        ? 'Passwords do not match'
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // ERROR MESSAGE
              // ==================================================

              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // REGISTER BUTTON
              // ==================================================

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // LOGIN LINK
              // ==================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

