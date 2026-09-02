import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../modules/posts/controllers/posts_controller.dart';

class PostImageSection extends StatelessWidget {
  final PostsController controller;

  const PostImageSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final image = controller.selectedImage.value;
      final post = controller.post.value;

      if (image != null) {
        return _newImage(image);
      }

      if (post != null && post.hasImage()) {
        return _currentImage(post.getImageUrl());
      }

      return _emptyImage();
    });
  }

  Widget _newImage(File image) {
    return Stack(
      children: [
        _image(
          Image.file(
            image,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        _removeButton(),
      ],
    );
  }

  Widget _currentImage(String url) {
    return Stack(
      children: [
        _image(
          CachedNetworkImage(
            imageUrl: url,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) =>
                const Center(child: Icon(Icons.image_not_supported, size: 50)),
          ),
        ),
        _changeButton(),
      ],
    );
  }

  Widget _emptyImage() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 50,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text('Select New Image'),
            SizedBox(height: 4),
            Text(
              'JPG, PNG, WebP up to 2MB',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(height: 200, width: double.infinity, child: child),
    );
  }

  Widget _removeButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: CircleAvatar(
        backgroundColor: Colors.black54,
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: controller.removeImage,
        ),
      ),
    );
  }

  Widget _changeButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: controller.pickImage,
        ),
      ),
    );
  }
}
