import 'dart:io';

import 'package:colormate_app/core/services/auth_session_manager.dart';
import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ObjectDetectionRemoteDataSource {
  ObjectDetectionRemoteDataSource({
    Dio? dio,
    AuthSessionManager? sessionManager,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: 'http://colormate.runasp.net',
               connectTimeout: const Duration(seconds: 20),
               receiveTimeout: const Duration(seconds: 20),
             ),
           ),
       _sessionManager =
           sessionManager ?? AuthSessionManager(storage: SimpleAuthStorage());

  final AuthSessionManager _sessionManager;

  final Dio _dio;

  Future<Map<String, dynamic>> detectObjects({
    required String imagePath,
  }) async {
    try {
      final normalizedPath = imagePath.replaceFirst('file://', '');
      final imageFile = File(normalizedPath);

      if (!await imageFile.exists()) {
        throw const ObjectDetectionApiException(
          'Selected image file was not found.',
        );
      }

      final formData = FormData.fromMap({
        'uploadedImage': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.uri.pathSegments.last,
        ),
      });

      final response = await _postAuthorized(
        '/api/ObjDetection/upload-image',
        data: formData,
      );

      _logDebug('ObjDetection status: ${response.statusCode}');
      _logDebug('ObjDetection response: ${response.data}');

      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (error) {
      _logDebug('ObjDetection error status: ${error.response?.statusCode}');
      _logDebug('ObjDetection error body: ${error.response?.data}');

      if ((error.response?.statusCode ?? 0) == 401) {
        await _sessionManager.clearSession();
        throw const ObjectDetectionApiException(
          'Unauthorized: please login again.',
        );
      }

      throw ObjectDetectionApiException(_toUserFriendlyMessage(error));
    } on AuthSessionException catch (error) {
      throw ObjectDetectionApiException(error.message);
    } on ObjectDetectionApiException {
      rethrow;
    } catch (_) {
      throw const ObjectDetectionApiException('Unexpected error happened.');
    }
  }

  Future<Response<dynamic>> _postAuthorized(String path, {dynamic data}) async {
    final headers = await _buildAuthorizedHeaders();
    return _dio.post(path, data: data, options: Options(headers: headers));
  }

  Future<Response<dynamic>> _getAuthorized(String path) async {
    final headers = await _buildAuthorizedHeaders();
    return _dio.get(path, options: Options(headers: headers));
  }

  Future<Map<String, dynamic>> _buildAuthorizedHeaders() async {
    await _sessionManager.init();
    final token = await _sessionManager.getValidAccessToken();
    return _buildAuthHeaders(token);
  }

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  String _toUserFriendlyMessage(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Request timed out. Please check your internet and try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Cannot reach the server now. Please try again later.';
    }

    final statusCode = error.response?.statusCode ?? 0;
    if (statusCode == 400) {
      return 'Please upload a valid image.';
    }

    if (statusCode >= 500) {
      return 'Server is temporarily unavailable. Please try again later.';
    }

    final serverMessage = _extractMessage(error.response?.data);
    if (serverMessage != null && serverMessage.trim().isNotEmpty) {
      return serverMessage;
    }

    return error.message ?? 'Unexpected network error.';
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      final keys = ['message', 'Message', 'error', 'Error', 'title', 'Title'];
      for (final key in keys) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }

  Map<String, dynamic> _buildAuthHeaders(String rawToken) {
    final normalizedToken = rawToken.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );

    return <String, dynamic>{'Authorization': 'Bearer $normalizedToken'};
  }
}

class ObjectDetectionApiException implements Exception {
  const ObjectDetectionApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
