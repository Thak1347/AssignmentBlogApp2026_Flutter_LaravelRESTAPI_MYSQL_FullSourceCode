import 'package:blog_app/app/modules/posts/controllers/posts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../constants/app_colors.dart';

class CreatePostView extends GetView<PostsController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Selection
            _buildImageSection(),
            const SizedBox(height: 24),

            // Title Field
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter post title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
              maxLength: 255,
            ),
            const SizedBox(height: 16),

            // Content Field
            TextField(
              controller: controller.contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Write your post content...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.article),
              ),
              maxLines: 8,
              maxLength: 5000,
            ),
            const SizedBox(height: 24),

            // Create Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isCreating.value
                      ? null
                      : controller.createPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isCreating.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Create Post',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Obx(() {
      if (controller.selectedImage.value != null) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                controller.selectedImage.value!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: controller.removeImage,
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                ),
              ),
            ),
          ],
        );
      }

      return GestureDetector(
        onTap: controller.pickImage,
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 50,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Select Image',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              Text(
                'JPG, PNG, WebP up to 2MB',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    });
  }
}
