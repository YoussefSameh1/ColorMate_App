import 'package:dio/dio.dart';

import 'package:colormate_app/features/authentication/auth_data/models/login_request_model.dart';
import 'package:colormate_app/features/authentication/auth_data/models/signup_request_model.dart';

class AuthApiException implements Exception {
  const AuthApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LoginResponse {
  final String token;
  final String message;

  LoginResponse({required this.token, required this.message});
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

  Future<LoginResponse> login(LoginRequestModel request) async {
    return _runLoginRequest(() async {
      final response = await _dio.post(
        '/api/Users/Login',
        data: request.toJson(),
      );
      final token =
          _extractToken(response.data) ??
          _extractTokenFromHeaders(response.headers) ??
          '';
      final message = _extractMessage(response.data) ?? 'Login successful.';
      return LoginResponse(token: token, message: message);
    });
  }

  Future<LoginResponse> loginWithGoogle({required String idToken}) async {
    return _runLoginRequest(() async {
      final response = await _dio.post(
        '/api/Users/LoginWithGoogle',
        data: {'idToken': idToken},
      );
      final token =
          _extractToken(response.data) ??
          _extractTokenFromHeaders(response.headers) ??
          '';
      final message =
          _extractMessage(response.data) ?? 'Google login successful.';
      return LoginResponse(token: token, message: message);
    });
  }

  Future<LoginResponse> _runLoginRequest(
    Future<LoginResponse> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error) {
      final serverMessage = _extractMessage(error.response?.data);
      throw AuthApiException(
        _toUserFriendlyMessage(serverMessage: serverMessage, error: error),
      );
    } catch (_) {
      throw const AuthApiException('Unexpected error happened.');
    }
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
        _toUserFriendlyMessage(serverMessage: serverMessage, error: error),
      );
    } catch (_) {
      throw const AuthApiException('Unexpected error happened.');
    }
  }

  String _toUserFriendlyMessage({
    required DioException error,
    String? serverMessage,
  }) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Request timed out. Please check your internet and try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Cannot reach the server now. Please try again later.';
    }

    final statusCode = error.response?.statusCode ?? 0;
    if (statusCode >= 500) {
      return 'Server is temporarily unavailable. Please try again later.';
    }

    if (serverMessage != null && serverMessage.trim().isNotEmpty) {
      if (_looksLikeStackTrace(serverMessage)) {
        return 'Server is temporarily unavailable. Please try again later.';
      }
      return serverMessage;
    }

    return error.message ?? 'Unexpected network error.';
  }

  bool _looksLikeStackTrace(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('exception') ||
        normalized.contains('stack trace') ||
        normalized.contains('microsoft.data.sqlclient') ||
        normalized.contains('named pipes provider') ||
        normalized.contains(' at ') ||
        normalized.contains('system.');
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

  String? _extractToken(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final map = data.map((key, value) => MapEntry(key.toString(), value));
      final keys = [
        'token',
        'Token',
        'accessToken',
        'access_token',
        'accesstoken',
        'jwt',
        'jwtToken',
        'Authorization',
        'authorization',
      ];

      for (final key in keys) {
        final value = map[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      for (final entry in map.entries) {
        if (entry.value is Map) {
          final nestedToken = _extractToken(entry.value);
          if (nestedToken != null) return nestedToken;
        }
      }
    }

    return null;
  }

  String? _extractTokenFromHeaders(Headers headers) {
    final headerKeys = ['authorization', 'Authorization', 'x-access-token'];
    for (final key in headerKeys) {
      final value = headers.value(key);
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
