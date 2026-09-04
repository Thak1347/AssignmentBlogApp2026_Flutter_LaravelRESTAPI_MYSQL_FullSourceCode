import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'dart:developer';

import '../services/api_service.dart';

class AuthProvider extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String emailConfirmation,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'email_confirmation': emailConfirmation,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      log('Registration successful for: $email');

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('Registration error: $e');
      throw e.toString();
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Use regular POST with JSON data
      final response = await _apiService.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      log('Login successful for: $email');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('Login error: $e');
      throw e.toString();
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiService.dio.post('/logout');
      log('Logout successful');
    } on DioException catch (e) {
      _handleDioError(e);
      // Don't throw on logout error, just log it
      log('Logout error: ${e.message}');
    } catch (e) {
      log('Logout error: $e');
    }
  }

  /// Get current authenticated user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get('/current-user');
      log('Current user fetched successfully');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('Get current user error: $e');
      throw e.toString();
    }
  }

  /// Refresh token (optional - if your API supports it)
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await _apiService.dio.post('/refresh-token');
      log('Token refreshed successfully');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      throw _extractErrorMessage(e);
    } catch (e) {
      log('Refresh token error: $e');
      throw e.toString();
    }
  }

  /// Check if email is available (optional)
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await _apiService.dio.post(
        '/check-email',
        data: {'email': email},
      );
      return response.data['available'] ?? true;
    } catch (e) {
      log('Email check error: $e');
      return true; // Assume available on error
    }
  }

  // Private helper methods

  /// Handle Dio errors with logging
  void _handleDioError(DioException e) {
    log('Dio Error: ${e.response?.statusCode} - ${e.message}');
    if (e.response != null) {
      log('Error Response Data: ${e.response?.data}');
    }
  }

  /// Extract user friendly error message from DioException
  String _extractErrorMessage(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null) {
        // Try to get the message from different response formats
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
