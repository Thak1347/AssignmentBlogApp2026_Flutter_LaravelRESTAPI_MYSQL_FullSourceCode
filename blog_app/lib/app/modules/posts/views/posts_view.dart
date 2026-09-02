import 'package:blog_app/app/data/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/posts_controller.dart';

class PostsView extends GetView<PostsController> {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Posts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingShimmer();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        if (controller.posts.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.fetchPosts,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return _buildPostCard(post);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.createPost),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    final authController = Get.find<AuthController>();
    final isOwner = authController.user.value?.id == post.userId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Image
          if (post.image != null && post.image!.isNotEmpty)
            GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.postDetails,
                arguments: {'postId': post.id},
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: post.getImageUrl(),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.postDetails,
                    arguments: {'postId': post.id},
                  ),
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),

                // Content Preview
                if (post.content != null && post.content!.isNotEmpty)
                  Text(
                    post.content!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),

                // Author and Date
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        post.user?.getInitials() ?? '?',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user?.name ?? 'Unknown Author',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            post.getFormattedDate(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons (Edit & Delete) - Only for owner
                    if (isOwner)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            onPressed: () => Get.toNamed(
                              AppRoutes.editPost,
                              arguments: {'post': post},
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                controller.showDeleteConfirmation(post.id),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Comments Count
                Row(
                  children: [
                    const Icon(
                      Icons.comment_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.getCommentCount()} comments',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Container(height: 200, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 200,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(radius: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              width: 100,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 12,
                              width: 80,
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Posts Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to create a post!',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.createPost),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'Create Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.fetchPosts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
