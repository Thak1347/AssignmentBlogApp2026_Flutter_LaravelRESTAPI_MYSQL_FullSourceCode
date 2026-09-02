import 'package:blog_app/app/widget/empty_state.dart';
import 'package:blog_app/app/widget/error_state.dart';
import 'package:blog_app/app/widget/loading_shimmer.dart';
import 'package:blog_app/app/widget/post_card.dart';
import 'package:blog_app/app/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../../services/notification_service.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog Feed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isSearching.value ? Icons.close : Icons.search,
              ),
              onPressed: controller.toggleSearch,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: controller.navigateToProfile,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Obx(
            () => controller.isSearching.value
                ? const SearchWidget()
                : const SizedBox.shrink(),
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value || controller.isUpdating.value) {
          return const LoadingShimmer();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return const ErrorState();
        }

        if (controller.isSearching.value) {
          final posts = controller.filteredPosts;

          if (posts.isEmpty && controller.searchQuery.value.isNotEmpty) {
            return _noResults();
          }

          return _postList(posts);
        }

        if (controller.posts.isEmpty) {
          return const EmptyState();
        }
        return _postList(controller.posts);
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToCreatePost,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _postList(List posts) {
    return RefreshIndicator(
      onRefresh: controller.refreshPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (_, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }

  Widget _noResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Try a different keyword'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.clearSearch,
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }
}
