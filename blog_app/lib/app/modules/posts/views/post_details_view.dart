import 'package:blog_app/app/data/models/post_model.dart';
import 'package:blog_app/app/modules/posts/controllers/posts_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class PostDetailsView extends GetView<PostsController> {
  const PostDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
        actions: [
          // Refresh Button
          IconButton(
            icon: Obx(
              () => controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
            ),
            onPressed: () {
              final postId = controller.post.value?.id;
              if (postId != null) {
                controller.refreshPost(postId);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final postId = controller.post.value?.id;
          if (postId != null) {
            await controller.refreshPost(postId);
          }
        },
        child: Obx(() {
          if (controller.isLoading.value && controller.post.value == null) {
            return _buildLoadingState();
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState();
          }

          final post = controller.post.value;
          if (post == null) {
            return _buildErrorState();
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (post.image != null && post.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: post.getImageUrl(),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 250,
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Author and Date with Edit & Delete
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        post.user?.getInitials() ?? '?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user?.name ?? 'Unknown Author',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            post.getFormattedDate(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Edit & Delete Buttons for owner
                    if (Get.find<AuthController>().user.value?.id ==
                        post.userId)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.primary,
                            ),
                            onPressed: () =>
                                Get.toNamed(
                                  AppRoutes.editPost,
                                  arguments: {'post': post},
                                )?.then((_) {
                                  // Refresh when returning from edit
                                  controller.refreshPost(post.id);
                                }),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _showDeleteConfirmation(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Content
                if (post.content != null && post.content!.isNotEmpty)
                  Text(
                    post.content!,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                const SizedBox(height: 24),

                // Comments Section
                _buildCommentsSection(post),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCommentsSection(PostModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${post.getCommentCount()}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            // Refresh comments button
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () {
                final postId = controller.post.value?.id;
                if (postId != null) {
                  controller.refreshPost(postId);
                }
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Refresh comments',
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Comments List with Loading State - FIXED HERE
        Obx(() {
          if (controller.isLoading.value && controller.post.value != null) {
            return _buildCommentsLoading();
          }

          final comments = post.comments;
          if (comments != null && comments.isNotEmpty) {
            return Column(
              children: comments
                  .map((comment) => _buildCommentItem(comment))
                  .toList(), // FIXED: Added .toList()
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No comments yet',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          );
        }),

        // Add Comment Button
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _navigateToComments(post.id),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.primary,
            ),
            icon: const Icon(Icons.add_comment, color: Colors.white, size: 20),
            label: const Text(
              'Add Comment',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsLoading() {
    return Column(
      children: [
        _buildShimmerComment(),
        _buildShimmerComment(),
        _buildShimmerComment(),
      ],
    );
  }

  Widget _buildShimmerComment() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 100, color: Colors.grey.shade200),
                const SizedBox(height: 4),
                Container(height: 12, width: 60, color: Colors.grey.shade200),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 4),
                Container(height: 12, width: 150, color: Colors.grey.shade200),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              comment.user?.getInitials() ?? '?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user?.name ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.getFormattedDate(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    final post = controller.post.value;
    if (post == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => TextButton(
              onPressed: controller.isDeleting.value
                  ? null
                  : () {
                      Get.back();
                      controller.deletePost(post.id);
                    },
              child: controller.isDeleting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToComments(int postId) {
    Get.toNamed(AppRoutes.comments, arguments: {'postId': postId})?.then((_) {
      // Refresh comments when returning from comments screen
      controller.refreshPost(postId);
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading post...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
              'Failed to load post',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final postId = controller.post.value?.id;
                    if (postId != null) {
                      controller.refreshPost(postId);
                    } else {
                      controller.goBack();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: controller.goBack,
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
