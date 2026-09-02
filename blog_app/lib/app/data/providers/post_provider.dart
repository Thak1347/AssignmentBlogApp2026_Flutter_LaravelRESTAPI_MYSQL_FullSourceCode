import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'dart:developer';

import '../services/api_service.dart';

class PostProvider extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ============================================================
  // GET POSTS
  // ============================================================

  Future<dynamic> getPosts() async {
    try {
      final response = await _apiService.get('/posts');
      log('✅ Posts fetched successfully');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Get posts error: $e');
      throw e.toString();
    }
  }

  // ============================================================
  // GET SINGLE POST
  // ============================================================

  Future<Map<String, dynamic>> getPost(int id) async {
    try {
      final response = await _apiService.get('/posts/$id');
      log('✅ Post $id fetched successfully');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Get post error: $e');
      throw e.toString();
    }
  }

  // ============================================================
  // CREATE POST
  // ============================================================

  Future<Map<String, dynamic>> createPost({
    required String title,
    String? content,
    File? image,
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('title', title));

      if (content != null && content.isNotEmpty) {
        formData.fields.add(MapEntry('content', content));
      }

      if (image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _apiService.postFormData('/posts', formData);
      log('✅ Post created successfully');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Create post error: $e');
      throw e.toString();
    }
  }

  // ============================================================
  // UPDATE POST - FIXED
  // ============================================================

  Future<Map<String, dynamic>> updatePost({
    required int id,
    required String title,
    String? content,
    File? image,
  }) async {
    try {
      // If image is provided, use FormData
      if (image != null) {
        final formData = FormData();
        formData.fields.add(MapEntry('title', title));

        if (content != null && content.isNotEmpty) {
          formData.fields.add(MapEntry('content', content));
        }

        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
        

        final response = await _apiService.putFormData('/posts/$id', formData);
        log('✅ Post $id updated successfully with image');
        return response.data;
      } else {
        // No image, use regular JSON
        final response = await _apiService.put(
          '/posts/$id',
          data: {'title': title, 'content': content},
        );
        log('✅ Post $id updated successfully');
        return response.data;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Update post error: $e');
      throw e.toString();
    }
  }

  // ============================================================
  // DELETE POST
  // ============================================================

  Future<void> deletePost(int id) async {
    try {
      await _apiService.delete('/posts/$id');
      log('✅ Post $id deleted successfully');
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('❌ Delete post error: $e');
      throw e.toString();
    }
  }

  // ============================================================
  // LIKE POST - FIXED (if your API supports it)
  // ============================================================

  // Future<Map<String, dynamic>> likePost(int id) async {
  //   try {
  //     final response = await _apiService.post(
  //       '/posts/$id/like',
  //       data: {}, // Empty data
  //     );
  //     log('✅ Post $id liked');
  //     return response.data;
  //   } on DioException catch (e) {
  //     _handleDioError(e);
  //     throw _extractErrorMessage(e);
  //   } catch (e) {
  //     log('❌ Like post error: $e');
  //     throw e.toString();
  //   }
  // }

  // Future<Map<String, dynamic>> unlikePost(int id) async {
  //   try {
  //     final response = await _apiService.post('/posts/$id/unlike', data: {});
  //     log('✅ Post $id unliked');
  //     return response.data;
  //   } on DioException catch (e) {
  //     _handleDioError(e);
  //     throw _extractErrorMessage(e);
  //   } catch (e) {
  //     log('❌ Unlike post error: $e');
  //     throw e.toString();
  //   }
  // }

  // ============================================================
  // PRIVATE HELPER METHODS
  // ============================================================

  void _handleDioError(DioException e) {
    log('❌ Dio Error: ${e.response?.statusCode} - ${e.message}');
    if (e.response != null) {
      log('📦 Error Response Data: ${e.response?.data}');
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map) {
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
          if (data.containsKey('errors')) {
            final errors = data['errors'] as Map;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return errors.toString();
          }
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
