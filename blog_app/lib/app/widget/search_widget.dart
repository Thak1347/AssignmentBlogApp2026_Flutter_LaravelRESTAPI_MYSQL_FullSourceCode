import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/home/controllers/home_controller.dart';

class SearchWidget extends GetView<HomeController> {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: TextField(
        controller: controller.searchController,
        autofocus: true,
        onChanged: controller.searchPosts,
        decoration: InputDecoration(
          hintText: 'Search posts...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                )
              : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
