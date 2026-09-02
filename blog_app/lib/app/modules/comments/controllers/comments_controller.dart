import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/comment_model.dart';
import '../../../data/providers/comment_provider.dart';
import '../../../routes/app_routes.dart';

class CommentController extends GetxController {
  final CommentProvider _commentProvider = Get.find<CommentProvider>();

  final comments = <CommentModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  late int postId;
  final commentText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map && arguments['postId'] != null) {
      postId = arguments['postId'];
      fetchComments();
    }
  }

  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _commentProvider.getComments(postId);
      comments.value = (response as List)
          .map((comment) => CommentModel.fromJson(comment))
          .toList();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load comments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment() async {
    if (commentText.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a comment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final response = await _commentProvider.addComment(
        postId: postId,
        content: commentText.value,
      );

      if (response['comment'] != null) {
        final newComment = CommentModel.fromJson(response['comment']);
        comments.insert(0, newComment);
        commentText.value = '';

        Get.snackbar(
          'Success',
          'Comment added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade700,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add comment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      await _commentProvider.deleteComment(commentId);
      comments.removeWhere((comment) => comment.id == commentId);

      Get.snackbar(
        'Success',
        'Comment deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete comment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }
  }

  void goBack() {
    Get.back();
  }
}
