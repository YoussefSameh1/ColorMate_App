import 'dart:convert';

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
  final String? refreshToken;
  final String? expiresOn;
  final String? refreshTokenExpiration;
  final bool isAuthenticated;
  final String? username;
  final String? email;
  final String message;

  LoginResponse({
    required this.token,
    required this.message,
    this.refreshToken,
    this.expiresOn,
    this.refreshTokenExpiration,
    this.isAuthenticated = true,
    this.username,
    this.email,
  });
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
      return _parseLoginResponse(
        response.data,
        response.headers,
        fallbackMessage: 'Login successful.',
      );
    });
  }

  Future<LoginResponse> loginWithGoogle({required String idToken}) async {
    return _runLoginRequest(() async {
      final response = await _dio.post(
        '/api/Users/LoginWithGoogle',
        data: {'idToken': idToken},
      );
      return _parseLoginResponse(
        response.data,
        response.headers,
        fallbackMessage: 'Google login successful.',
      );
    });
  }

  Future<LoginResponse> refreshToken({
    required String refreshToken,
    String? accessToken,
  }) async {
    return _runLoginRequest(() async {
      final normalizedAccessToken = _normalizeToken(accessToken);
      final attempts = _buildTokenExchangeAttempts(
        refreshToken: refreshToken,
        accessToken: normalizedAccessToken,
      );

      DioException? lastError;

      for (final attempt in attempts) {
        try {
          final response = await _dio.post(
            '/api/Users/refreshToken',
            data: attempt.body,
            queryParameters: attempt.query,
            options: Options(
              contentType: attempt.contentType,
              headers:
                  normalizedAccessToken == null
                      ? null
                      : {'Authorization': 'Bearer $normalizedAccessToken'},
            ),
          );

          return _parseLoginResponse(
            response.data,
            response.headers,
            fallbackMessage: 'Token refreshed successfully.',
          );
        } on DioException catch (error) {
          lastError = error;
          final statusCode = error.response?.statusCode ?? 0;
          if (statusCode != 400 && statusCode != 401) {
            rethrow;
          }
        }
      }

      if (lastError != null) {
        throw lastError;
      }

      throw const AuthApiException('Unable to refresh token now.');
    });
  }

  Future<String> revokeToken({
    required String refreshToken,
    String? accessToken,
  }) async {
    return _runRequest(() async {
      final normalizedAccessToken = _normalizeToken(accessToken);
      final attempts = _buildTokenExchangeAttempts(
        refreshToken: refreshToken,
        accessToken: normalizedAccessToken,
      );

      DioException? lastError;

      for (final attempt in attempts) {
        try {
          final response = await _dio.post(
            '/api/Users/revokeToken',
            data: attempt.body,
            queryParameters: attempt.query,
            options: Options(
              contentType: attempt.contentType,
              headers:
                  normalizedAccessToken == null
                      ? null
                      : {'Authorization': 'Bearer $normalizedAccessToken'},
            ),
          );

          return _extractMessage(response.data) ??
              'Token revoked successfully.';
        } on DioException catch (error) {
          lastError = error;
          final statusCode = error.response?.statusCode ?? 0;
          if (statusCode != 400 && statusCode != 401) {
            rethrow;
          }
        }
      }

      if (lastError != null) {
        throw lastError;
      }

      throw const AuthApiException('Unable to revoke token now.');
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

  LoginResponse _parseLoginResponse(
    dynamic data,
    Headers headers, {
    required String fallbackMessage,
  }) {
    final token =
        _extractToken(data) ?? _extractTokenFromHeaders(headers) ?? '';
    final refreshToken = _extractRefreshToken(data);
    final expiresOn = _extractStringByKeys(data, [
      'expiresOn',
      'expires',
      'exp',
    ]);
    final refreshTokenExpiration = _extractStringByKeys(data, [
      'refreshTokenExpiration',
      'refreshExpiresOn',
    ]);
    final isAuthenticated = _extractBoolByKeys(data, [
      'isAuthenticated',
      'authenticated',
    ]);

    return LoginResponse(
      token: token,
      refreshToken: refreshToken,
      expiresOn: expiresOn,
      refreshTokenExpiration: refreshTokenExpiration,
      isAuthenticated: isAuthenticated ?? token.isNotEmpty,
      username: _extractStringByKeys(data, ['username', 'userName']),
      email: _extractStringByKeys(data, ['email']),
      message: _extractMessage(data) ?? fallbackMessage,
    );
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

  String? _extractRefreshToken(dynamic data) {
    return _extractStringByKeys(data, [
      'refreshToken',
      'refresh_token',
      'refresh',
    ]);
  }

  String? _extractStringByKeys(dynamic data, List<String> keys) {
    if (data is Map) {
      final map = data.map((key, value) => MapEntry(key.toString(), value));
      for (final key in keys) {
        final value = map[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      for (final value in map.values) {
        if (value is Map) {
          final nested = _extractStringByKeys(value, keys);
          if (nested != null) {
            return nested;
          }
        }
      }
    }

    return null;
  }

  bool? _extractBoolByKeys(dynamic data, List<String> keys) {
    if (data is Map) {
      final map = data.map((key, value) => MapEntry(key.toString(), value));
      for (final key in keys) {
        final value = map[key];
        if (value is bool) {
          return value;
        }
      }
    }

    return null;
  }

  String _asBearer(String rawToken) {
    final normalized = _normalizeToken(rawToken) ?? rawToken;
    return 'Bearer $normalized';
  }

  String? _normalizeToken(String? rawToken) {
    if (rawToken == null || rawToken.trim().isEmpty) {
      return null;
    }

    return rawToken
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
        .trim();
  }

  List<_TokenExchangeAttempt> _buildTokenExchangeAttempts({
    required String refreshToken,
    String? accessToken,
  }) {
    final _ = accessToken;
    final normalizedRefreshToken = refreshToken.trim();
    final attempts = <_TokenExchangeAttempt>[
      // Swagger indicates raw string body; try this first.
      _TokenExchangeAttempt(
        body: jsonEncode(normalizedRefreshToken),
        contentType: Headers.jsonContentType,
      ),
      // Lightweight fallback for backends expecting plain text.
      _TokenExchangeAttempt(
        body: normalizedRefreshToken,
        contentType: Headers.textPlainContentType,
      ),
    ];

    return attempts;
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

class _TokenExchangeAttempt {
  const _TokenExchangeAttempt({this.body, this.query, this.contentType});

  final dynamic body;
  final Map<String, dynamic>? query;
  final String? contentType;
}
