import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../data/models/post_model.dart';
import '../routes/app_routes.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/posts/controllers/posts_controller.dart';

class PostCard extends GetView<HomeController> {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final isOwner = auth.user.value?.id == post.userId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Post Image
          if (post.image?.isNotEmpty == true)
            GestureDetector(
              onTap: () => controller.navigateToPostDetails(post.id),
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

            /// Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                GestureDetector(
                  onTap: () => controller.navigateToPostDetails(post.id),
                  child: Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // CONTENT
                if (post.content?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    post.content!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],

                const SizedBox(height: 12),

                /// Author and Action
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        post.user?.getInitials() ?? '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
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
                            style: const TextStyle(fontWeight: FontWeight.w600),
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

                    /// Edit and Delete
                    if (isOwner) ...[
                      // EDIT
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          controller.startUpdate();

                          Get.toNamed(
                            AppRoutes.editPost,
                            arguments: {'post': post},
                          )?.then((_) {
                            controller.finishUpdate();
                          });
                        },
                      ),

                      // Delete
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          
                          final postsController = Get.find<PostsController>();

                          postsController.showDeleteConfirmation(post.id);
                        },
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                /// Comment and ReadMore
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

                    const Spacer(),

                    TextButton(
                      onPressed: () {
                        controller.navigateToPostDetails(post.id);
                      },
                      child: const Text('Read More'),
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
}
