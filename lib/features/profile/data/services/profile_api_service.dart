import 'package:dio/dio.dart';

class ProfileApiException implements Exception {
  const ProfileApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProfileApiService {
  ProfileApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'http://colormate.runasp.net',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
            ),
          );

  final Dio _dio;

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    try {
      final response = await _dio.post(
        '/api/Users/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return _extractMessage(response.data) ?? 'Password changed successfully.';
    } on DioException catch (error) {
      throw ProfileApiException(_toUserFriendlyMessage(error));
    } catch (_) {
      throw const ProfileApiException('Unexpected error happened.');
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
    if (statusCode == 401) {
      return 'Unauthorized: please login again.';
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
}
