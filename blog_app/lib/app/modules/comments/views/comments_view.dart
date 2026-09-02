import 'package:blog_app/app/modules/comments/controllers/comments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';

class CommentsView extends GetView<CommentController> {
  const CommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorState();
              }

              if (controller.comments.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  final comment = controller.comments[index];
                  return _buildCommentItem(comment);
                },
              );
            }),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentItem(comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                comment.user?.getInitials() ?? '?',
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
            // Delete button for own comments
            if (Get.find<AuthController>().user.value?.id == comment.userId)
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red,
                ),
                onPressed: () => _showDeleteConfirmation(comment.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => controller.commentText.value = value,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => CircleAvatar(
              backgroundColor: AppColors.primary,
              child: controller.isSubmitting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: controller.addComment,
                      padding: EdgeInsets.zero,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int commentId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteComment(commentId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.comment_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Comments Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(color: Colors.grey[500]),
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
              onPressed: controller.fetchComments,
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
