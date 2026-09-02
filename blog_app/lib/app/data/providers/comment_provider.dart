import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'dart:developer';

import '../services/api_service.dart';

class CommentProvider extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Get all comments for a specific post
  Future<List<dynamic>> getComments(int postId) async {
    try {
      final response = await _apiService.dio.get('/posts/$postId/comments');
      log(
        '✅ Comments fetched for post $postId: ${response.data is List ? response.data.length : 0} comments',
      );

      if (response.data is List) {
        return response.data;
      } else if (response.data is Map &&
          (response.data as Map).containsKey('data')) {
        return response.data['data'];
      }
      return [];
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Get comments error: $e');
      throw e.toString();
    }
  }

  /// Add a comment to a post
  Future<Map<String, dynamic>> addComment({
    required int postId,
    required String content,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/posts/$postId/comments',
        data: {'content': content},
      );
      log('✅ Comment added to post $postId');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Add comment error: $e');
      throw e.toString();
    }
  }

  /// Delete a comment
  Future<void> deleteComment(int commentId) async {
    try {
      await _apiService.dio.delete('/comments/$commentId');
      log('✅ Comment $commentId deleted');
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Delete comment error: $e');
      throw e.toString();
    }
  }

  /// Update a comment (if your API supports it)
  Future<Map<String, dynamic>> updateComment({
    required int commentId,
    required String content,
  }) async {
    try {
      final response = await _apiService.dio.put(
        '/comments/$commentId',
        data: {'content': content},
      );
      log('✅ Comment $commentId updated');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Update comment error: $e');
      throw e.toString();
    }
  }

  /// Like a comment (optional)
  Future<Map<String, dynamic>> likeComment(int commentId) async {
    try {
      final response = await _apiService.dio.post('/comments/$commentId/like');
      log('✅ Comment $commentId liked');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Like comment error: $e');
      throw e.toString();
    }
  }

  /// Unlike a comment (optional)
  Future<Map<String, dynamic>> unlikeComment(int commentId) async {
    try {
      final response = await _apiService.dio.post(
        '/comments/$commentId/unlike',
      );
      log('✅ Comment $commentId unliked');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Unlike comment error: $e');
      throw e.toString();
    }
  }

  /// Report a comment (optional)
  Future<Map<String, dynamic>> reportComment({
    required int commentId,
    required String reason,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/comments/$commentId/report',
        data: {'reason': reason},
      );
      log('✅ Comment $commentId reported');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Report comment error: $e');
      throw e.toString();
    }
  }

  /// Get comment by ID
  Future<Map<String, dynamic>> getComment(int commentId) async {
    try {
      final response = await _apiService.dio.get('/comments/$commentId');
      log('✅ Comment $commentId fetched');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Get comment error: $e');
      throw e.toString();
    }
  }

  // ============================================================
  // PRIVATE HELPER METHODS
  // ============================================================

  /// Handle Dio errors with logging
  void _handleDioError(DioException e) {
    log('❌ Dio Error: ${e.response?.statusCode} - ${e.message}');
    if (e.response != null) {
      log('📦 Error Response Data: ${e.response?.data}');
    }
  }

  /// Extract user-friendly error message from DioException
  String _extractErrorMessage(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map) {
          // Laravel validation errors format
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
          // Laravel errors format
          if (data.containsKey('errors')) {
            final errors = data['errors'] as Map;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return errors.toString();
          }
          // Custom error format
          if (data.containsKey('error')) {
            return data['error'].toString();
          }
          return data.toString();
        }
        return data.toString();
      }
    }
    return e.message ?? 'An unexpected error occurred';
  }
}
