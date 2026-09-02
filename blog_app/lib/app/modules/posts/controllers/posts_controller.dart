import 'dart:io';
import 'package:blog_app/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/post_model.dart';
import '../../../data/providers/post_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/notification_service.dart';
import '../../auth/controllers/auth_controller.dart';

class PostsController extends GetxController {
  final PostProvider _postProvider = Get.find<PostProvider>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final posts = <PostModel>[].obs;
  final post = Rxn<PostModel>();
  final isLoading = false.obs;
  final isCreating = false.obs;
  final isEditing = false.obs;
  final isDeleting = false.obs;
  final isLiking = false.obs;
  final errorMessage = ''.obs;
  final updateStatus = ''.obs;
  final updateResult = Rxn<bool>();
  final isImageUploading = false.obs;

  final currentPage = 1.obs;
  final hasMorePosts = true.obs;
  final isLoadMore = false.obs;
  final perPage = 10.obs;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final selectedImage = Rxn<File>();
  final imagePath = ''.obs;
  final isImageChanged = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args['postId'] != null) fetchPost(args['postId']);
      if (args['post'] != null) {
        final data = args['post'] as PostModel;
        post.value = data;
        titleController.text = data.title;
        contentController.text = data.content ?? '';
      }
    }
    if (post.value == null && Get.currentRoute == '/home') fetchPosts();
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  Future<void> fetchPosts({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        isLoading.value = true;
        currentPage.value = 1;
        errorMessage.value = '';

        // Do NOT clear posts here.
        // Keep old posts visible while refreshing.
      } else {
        this.isLoadMore.value = true;
      }

      final response = await _postProvider.getPosts();

      List<dynamic> data = [];

      if (response is List) {
        data = response;
      } else if (response is Map<String, dynamic>) {
        if (response['data'] is List) {
          data = response['data'];
        } else if (response['posts'] is List) {
          data = response['posts'];
        }
      }

      final newPosts = data
          .whereType<Map<String, dynamic>>()
          .map((e) => PostModel.fromJson(e))
          .toList();

      if (isLoadMore) {
        posts.addAll(newPosts);
      } else {
        posts.assignAll(newPosts);
      }

      hasMorePosts.value = newPosts.length >= perPage.value;

      if (posts.isEmpty) {
        errorMessage.value = 'No posts available';
      } else {
        errorMessage.value = '';
      }

      debugPrint('✅ Posts loaded: ${posts.length}');
    } catch (e, stackTrace) {
      debugPrint('❌ FETCH POSTS ERROR: $e');
      debugPrint('$stackTrace');

      errorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Failed to load posts',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
      this.isLoadMore.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadMore.value || !hasMorePosts.value) return;
    currentPage.value++;
    await fetchPosts(isLoadMore: true);
  }

  Future<void> refreshPosts() async {
    try {
      isLoading.value = true;
      await fetchPosts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPost(int postId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _postProvider.getPost(postId);
      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;
      post.value = PostModel.fromJson(data);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load post',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPost(int postId) async => fetchPost(postId);

  Future<void> createPost() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
      return;
    }

    try {
      isCreating.value = true;
      await _postProvider.createPost(
        title: title,
        content: contentController.text.trim(),
        image: selectedImage.value,
      );
      await _notificationService.showPostCreatedNotification(title);
      Get.snackbar(
        'Success',
        'Post created! 🎉',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create post',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isCreating.value = false;
    }
  }

  //
  Future<void> updatePost({
    required int postId,
    required String title,
    String? content,
    File? image,
  }) async {
    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
      return;
    }

    try {
      isEditing.value = true;
      if (isImageChanged.value && selectedImage.value != null) {
        isImageUploading.value = true;
      }

      await _postProvider.updatePost(
        id: postId,
        title: title,
        content: content,
        image: image,
      );

      await _notificationService.showPostUpdatedNotification(title);
      Get.snackbar(
        'Success',
        'Post updated! ✏️',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      updateStatus.value = 'Error: ${e.toString()}';
      updateResult.value = false;
      Get.snackbar(
        'Error',
        'Failed to update post',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isEditing.value = false;
      isImageUploading.value = false;
    }
  }

  Future<void> submitUpdate() async {
    final currentPost = post.value;

    if (currentPost == null) {
      Get.snackbar(
        'Error',
        'Post not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
      return;
    }

    final title = titleController.text.trim();
    final content = contentController.text.trim();

    await updatePost(
      postId: currentPost.id,
      title: title,
      content: content.isEmpty ? null : content,
      image: selectedImage.value,
    );
  }

  Future<void> deletePost(int postId) async {
    final postToDelete = posts.firstWhereOrNull((p) => p.id == postId);

    final title = postToDelete?.title ?? 'Post';

    try {
      isDeleting.value = true;
      errorMessage.value = '';

      debugPrint('🗑️ Deleting post: $postId');

      // 1. Delete from Laravel
      await _postProvider.deletePost(postId);

      debugPrint('✅ Post deleted from Laravel');

      // 2. Remove immediately from local list
      posts.removeWhere((p) => p.id == postId);

      debugPrint('✅ Post removed from local list');

      // 3. Show local notification
      await _notificationService.showPostDeletedNotification(title);

      debugPrint('🔔 Delete notification sent');

      // 4. Show success message
      Get.snackbar(
        'Deleted',
        '"$title" deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      );

      // 5. Refresh posts from Laravel
      await fetchPosts();

      debugPrint('🔄 Posts refreshed after delete');
    } catch (e, stackTrace) {
      debugPrint('❌ DELETE ERROR: $e');
      debugPrint('$stackTrace');

      errorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Failed to delete post',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
        imagePath.value = image.path;
        isImageChanged.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickImageWithCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
        imagePath.value = image.path;
        isImageChanged.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
    imagePath.value = '';
    isImageChanged.value = true;
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageWithCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  void goBack() => Get.back();
  void navigateToEditPost(PostModel post) =>
      Get.toNamed(AppRoutes.editPost, arguments: {'post': post});
  void navigateToPostDetails(int postId) =>
      Get.toNamed(AppRoutes.postDetails, arguments: {'postId': postId});
  void navigateToCreatePost() => Get.toNamed(AppRoutes.createPost);

  void showDeleteConfirmation(int postId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => TextButton(
              onPressed: isDeleting.value
                  ? null
                  : () async {
                      Get.back();
                      await deletePost(postId);
                    },
              child: isDeleting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void clearError() => errorMessage.value = '';
  void clearUpdateStatus() {
    updateStatus.value = '';
    updateResult.value = null;
  }

  bool get hasPosts => posts.isNotEmpty;
  bool get isPostOwner =>
      post.value?.userId == Get.find<AuthController>().user.value?.id;
}
