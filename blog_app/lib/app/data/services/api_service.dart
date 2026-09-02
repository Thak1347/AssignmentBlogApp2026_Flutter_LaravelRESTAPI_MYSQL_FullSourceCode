import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'dart:developer';

import '../../config/api_endpoints.dart';
import '../../config/app_config.dart';
import 'storage_service.dart';

class ApiService extends GetxService {
  late final Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: Duration(seconds: AppConfig.connectionTimeout),
        receiveTimeout: Duration(seconds: AppConfig.receiveTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptor for token authentication & logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('🚀 Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            '✅ Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          log('❌ Error: ${error.response?.statusCode} ${error.message}');
          if (error.response?.statusCode == 401) {
            _storageService.clearAll();
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          requestHeader: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  // POST request
  Future<Response> post(String path, FormData formData, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // DELETE request
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  // POST with FormData (for file uploads)
  Future<Response> postFormData(String path, FormData formData) async {
    // Let Dio automatically calculate and attach boundary headers
    return await _dio.post(path, data: formData);
  }

  // PUT with FormData (Fix for Laravel / PHP backends)
  Future<Response> putFormData(String path, FormData formData) async {
    // Append _method field to support multipart updates in backends like Laravel
    formData.fields.add(const MapEntry('_method', 'PUT'));
    return await _dio.post(path, data: formData);
  }
}
