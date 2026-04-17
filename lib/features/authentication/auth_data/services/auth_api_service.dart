import 'package:dio/dio.dart';

import 'package:colormate_app/features/authentication/auth_data/models/login_request_model.dart';
import 'package:colormate_app/features/authentication/auth_data/models/signup_request_model.dart';

class AuthApiException implements Exception {
  const AuthApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthApiService {
  AuthApiService({Dio? dio})
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

  Future<String> register(SignupRequestModel request) async {
    return _runRequest(() async {
      final response = await _dio.post(
        '/api/Users/Register',
        data: request.toJson(),
      );
      return _extractMessage(response.data) ?? 'Registration successful.';
    });
  }

  Future<String> login(LoginRequestModel request) async {
    return _runRequest(() async {
      final response = await _dio.post(
        '/api/Users/Login',
        data: request.toJson(),
      );
      return _extractMessage(response.data) ?? 'Login successful.';
    });
  }

  Future<String> verifyEmailOtp({
    required String email,
    required String code,
  }) async {
    return _runRequest(() async {
      final response = await _dio.post(
        '/api/Verification/VerifyEmailOtp',
        queryParameters: {'email': email, 'code': code},
      );
      return _extractMessage(response.data) ?? 'Email verified successfully.';
    });
  }

  Future<String> resendOtp({required String email}) async {
    return _runRequest(() async {
      final response = await _dio.post(
        '/api/Verification/ResendOtp',
        queryParameters: {'email': email},
      );
      return _extractMessage(response.data) ?? 'OTP has been resent.';
    });
  }

  Future<String> _runRequest(Future<String> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final serverMessage = _extractMessage(error.response?.data);
      throw AuthApiException(
        serverMessage ?? error.message ?? 'Unexpected network error.',
      );
    } catch (_) {
      throw const AuthApiException('Unexpected error happened.');
    }
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

      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty && value.first is String) {
            return value.first as String;
          }
        }
      }
    }

    return null;
  }
}
