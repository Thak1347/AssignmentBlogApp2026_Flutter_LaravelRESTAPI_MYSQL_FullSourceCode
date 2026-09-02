import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../../../data/models/post_model.dart';
import '../../../data/providers/post_provider.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/response_helper.dart';

class HomeController extends GetxController {
  final PostProvider _postProvider = Get.find<PostProvider>();
  final AuthController _authController = Get.find<AuthController>();

  final posts = <PostModel>[].obs;
  final filteredPosts = <PostModel>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isDeleting = false.obs;
  final isUpdating = false.obs;
  final isSearching = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  final currentPage = 1.obs;
  final hasMorePosts = true.obs;
  final isLoadMore = false.obs;
  final perPage = 10.obs;

  final searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void searchPosts(String query) {
    searchQuery.value = query;

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      _performSearch(query);
    });
  }
void _performSearch(String query) {
    final search = query.trim().toLowerCase();

    if (search.isEmpty) {
      filteredPosts.clear();
      return;
    }

    final results = posts.where((post) {
      final title = post.title.toLowerCase();

      final content = post.content?.toLowerCase() ?? '';

      final author = post.user?.name.toLowerCase() ?? '';

      return title.contains(search) ||
          content.contains(search) ||
          author.contains(search);
    }).toList();

    filteredPosts.assignAll(results);
  }
void closeSearch() {
    _searchDebounce?.cancel();

    searchController.clear();

    searchQuery.value = '';

    filteredPosts.clear();

    isSearching.value = false;

    errorMessage.value = '';

    FocusManager.instance.primaryFocus?.unfocus();
  }



  void clearSearch() {
    searchQuery.value = '';
    filteredPosts.clear();
    isSearching.value = false;
    errorMessage.value = '';
  }

  void toggleSearch() {
    if (isSearching.value) {
      clearSearch();
    } else {
      isSearching.value = true;
    }
  }

  Future<void> fetchPosts({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        isLoading.value = true;
        currentPage.value = 1;
        posts.clear();
        if (!isSearching.value) {
          filteredPosts.clear();
        }
      } else {
        this.isLoadMore.value = true;
      }

      errorMessage.value = '';

      // FIX: Remove page and perPage parameters
      final response = await _postProvider.getPosts();

      final postsData = ResponseHelper.extractList(response);

      final newPosts = postsData
          .whereType<Map<String, dynamic>>()
          .map((post) => PostModel.fromJson(post))
          .toList();

      if (isLoadMore) {
        posts.addAll(newPosts);
      } else {
        posts.value = newPosts;
        if (searchQuery.value.isNotEmpty) {
          searchPosts(searchQuery.value);
        }
      }

      hasMorePosts.value = newPosts.length >= perPage.value;

      if (posts.isEmpty) {
        errorMessage.value = 'No posts available';
      }
    } catch (e) {
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
      isRefreshing.value = false;
      isUpdating.value = false;
      this.isLoadMore.value = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadMore.value || !hasMorePosts.value) return;
    currentPage.value++;
    await fetchPosts(isLoadMore: true);
  }

  Future<void> refreshPosts() async {
    isRefreshing.value = true;
    currentPage.value = 1;
    hasMorePosts.value = true;
    await fetchPosts();
  }

  Future<void> deletePost(int postId) async {
    try {
      isDeleting.value = true;

      await _postProvider.deletePost(postId);

      posts.removeWhere((post) => post.id == postId);
      filteredPosts.removeWhere((post) => post.id == postId);

      Get.snackbar(
        'Success',
        'Post deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
    } catch (e) {
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

  Future<void> toggleLike(int postId) async {
    try {
      final index = posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final current = posts[index];
      final isLiked = !(current.isLiked ?? false);

      posts[index] = current.copyWith(
        isLiked: isLiked,
        likeCount: (current.likeCount ?? 0) + (isLiked ? 1 : -1),
      );

      final filterIndex = filteredPosts.indexWhere((p) => p.id == postId);
      if (filterIndex != -1) {
        final filterCurrent = filteredPosts[filterIndex];
        filteredPosts[filterIndex] = filterCurrent.copyWith(
          isLiked: isLiked,
          likeCount: (filterCurrent.likeCount ?? 0) + (isLiked ? 1 : -1),
        );
      }
    } catch (e) {
      await refreshPosts();
    }
  }

  void startUpdate() {
    isUpdating.value = true;
  }

  void finishUpdate() {
    isUpdating.value = false;
    refreshPosts();
  }

  void navigateToPostDetails(int postId) {
    Get.toNamed(AppRoutes.postDetails, arguments: {'postId': postId});
  }

  void navigateToCreatePost() {
    Get.toNamed(AppRoutes.createPost)?.then((_) {
      refreshPosts();
    });
  }

  void navigateToEditPost(PostModel post) {
    startUpdate();
    Get.toNamed(AppRoutes.editPost, arguments: {'post': post})?.then((_) {
      finishUpdate();
    });
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void showDeleteConfirmation(int postId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to delete this post? '
          'This action cannot be undone.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => TextButton(
              onPressed: isDeleting.value
                  ? null
                  : () {
                      Get.back();
                      deletePost(postId);
                    },
              child: isDeleting.value
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

  void clearError() {
    errorMessage.value = '';
  }

  bool get hasPosts => posts.isNotEmpty;
  bool get hasFilteredPosts => filteredPosts.isNotEmpty;
  List<PostModel> get displayPosts => isSearching.value ? filteredPosts : posts;
}
