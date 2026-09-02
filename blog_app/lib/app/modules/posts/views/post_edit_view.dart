import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/posts_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../widget/post_image_section.dart';

class PostEditView extends GetView<PostsController> {
  const PostEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: controller.goBack,
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.post.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostImageSection(controller: controller),

              const SizedBox(height: 24),

              TextField(
                controller: controller.titleController,
                maxLength: 255,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.contentController,
                maxLines: 8,
                maxLength: 5000,
                decoration: InputDecoration(
                  labelText: 'Content',
                  prefixIcon: const Icon(Icons.article),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildUpdateButton(),
              const SizedBox(height: 12),
              _buildDeleteButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: controller.isEditing.value
              ? null
              : controller.submitUpdate,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: controller.isEditing.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Update Post',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 55,
        child: OutlinedButton(
          onPressed: controller.isDeleting.value
              ? null
              : () {
                  final id = controller.post.value?.id;
                  if (id != null) {
                    controller.showDeleteConfirmation(id);
                  }
                },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
          ),
          child: controller.isDeleting.value
              ? const CircularProgressIndicator(color: Colors.red)
              : const Text('Delete Post', style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
