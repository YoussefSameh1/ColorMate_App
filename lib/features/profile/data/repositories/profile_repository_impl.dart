import 'dart:io';

import 'package:dio/dio.dart';

import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/profile/data/models/user_profile_model.dart';
import 'package:colormate_app/features/profile/data/repositories/profile_repository.dart';

class ProfileApiException implements Exception {
  const ProfileApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ProfileRepositoryImpl implements ProfileRepository {
  static const int _maxPictureSizeInBytes = 10 * 1024 * 1024;

  ProfileRepositoryImpl({Dio? dio, AuthApiService? authApiService})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'http://colormate.runasp.net',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
            ),
          ),
      _authApiService = authApiService ?? AuthApiService();

  final Dio _dio;
  final AuthApiService _authApiService;

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final storage = SimpleAuthStorage();
      await storage.init();
      final response = await _runAuthorizedRequest<Response<dynamic>>(
        storage,
        (headers) =>
            _dio.get('/api/Profile', options: Options(headers: headers)),
      );
print("PROFILE RESPONSE: ${response.data}");
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UserProfileModel.fromJson(data);
      }

      throw const ProfileApiException('Invalid profile response from server.');
    } on DioException catch (error) {
      throw ProfileApiException(_toUserFriendlyMessage(error));
    } on ProfileApiException {
      rethrow;
    } catch (_) {
      throw const ProfileApiException('Unexpected error happened.');
    }
  }

  @override
  Future<String?> updateProfilePicture(String imagePath) async {
    try {
      final storage = SimpleAuthStorage();
      await storage.init();

      final normalizedPath = imagePath.replaceFirst('file://', '');
      final pictureFile = File(normalizedPath);

      if (!await pictureFile.exists()) {
        throw const ProfileApiException('Selected image file was not found.');
      }

      final extension = normalizedPath.toLowerCase();
      const allowedExtensions = [
        '.jpg',
        '.jpeg',
        '.png',
        '.webp',
        '.heic',
        '.heif',
      ];
      final isAllowed = allowedExtensions.any(extension.endsWith);
      if (!isAllowed) {
        throw const ProfileApiException(
          'Invalid image type. Please use JPG, PNG, WEBP, or HEIC.',
        );
      }

      final fileSize = await pictureFile.length();
      if (fileSize > _maxPictureSizeInBytes) {
        throw const ProfileApiException(
          'Image is too large. Maximum allowed size is 10 MB.',
        );
      }

      final response = await _runAuthorizedRequest<Response<dynamic>>(storage, (
        headers,
      ) async {
        final formData = FormData.fromMap({
          'Picture': await MultipartFile.fromFile(
            pictureFile.path,
            filename: pictureFile.uri.pathSegments.last,
          ),
        });

        return _dio.put(
          '/api/Profile/picture',
          data: formData,
          options: Options(headers: headers),
        );
        
      });
      print("UPLOAD RESPONSE: ${response.data}");

      return _extractImageUrl(response.data);
    } on DioException catch (error) {
      throw ProfileApiException(_toUserFriendlyMessage(error));
    } on ProfileApiException {
      rethrow;
    } catch (_) {
      throw const ProfileApiException('Unexpected error happened.');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      final storage = SimpleAuthStorage();
      await storage.init();
      final payload = {
        'firstName': profile.firstName,
        'lastName': profile.lastName,
        'phoneNumber': profile.phoneNumber,
      };

      await _runAuthorizedRequest<void>(
        storage,
        (headers) => _dio.put(
          '/api/Profile',
          data: payload,
          options: Options(headers: headers),
        ),
      );
    } on DioException catch (error) {
      throw ProfileApiException(_toUserFriendlyMessage(error));
    } on ProfileApiException {
      rethrow;
    } catch (_) {
      throw const ProfileApiException('Unexpected error happened.');
    }
  }

  Map<String, dynamic> _buildAuthHeaders(String rawToken) {
    final normalizedToken = rawToken.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );

    return <String, dynamic>{'Authorization': 'Bearer $normalizedToken'};
  }

  Future<T> _runAuthorizedRequest<T>(
    SimpleAuthStorage storage,
    Future<T> Function(Map<String, dynamic> headers) request,
  ) async {
    var token = await _resolveUsableToken(storage);

    try {
      return await request(_buildAuthHeaders(token));
    } on DioException catch (error) {
      if ((error.response?.statusCode ?? 0) != 401) {
        rethrow;
      }

      final refreshedToken = await _refreshAccessToken(
        storage,
        accessToken: token,
      );

      if (refreshedToken == null || refreshedToken.isEmpty) {
        await _revokeAndClearSession(storage, accessToken: token);
        throw error;
      }

      token = refreshedToken;
      return request(_buildAuthHeaders(token));
    }
  }

  Future<String> _resolveUsableToken(SimpleAuthStorage storage) async {
    final token = storage.getSavedToken();
    if (token == null || token.isEmpty) {
      throw const ProfileApiException('Unauthorized: please login again.');
    }

    // Refresh before making the request to avoid a guaranteed 401 roundtrip.
    if (!storage.isTokenExpired()) {
      return token;
    }

    final refreshedToken = await _refreshAccessToken(
      storage,
      accessToken: token,
    );
    if (refreshedToken == null || refreshedToken.isEmpty) {
      await _revokeAndClearSession(storage, accessToken: token);
      throw const ProfileApiException('Unauthorized: please login again.');
    }

    return refreshedToken;
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

    if (statusCode == 404) {
      return 'Profile not found.';
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

  String? _extractImageUrl(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      final keys = ['profilePictureUrl', 'imageUrl', 'url'];
      for (final key in keys) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      final nested = data['data'];
      if (nested is Map<String, dynamic>) {
        for (final key in keys) {
          final value = nested[key];
          if (value is String && value.trim().isNotEmpty) {
            return value;
          }
        }
      }
    }

    return null;
  }

  Future<String?> _refreshAccessToken(
    SimpleAuthStorage storage, {
    String? accessToken,
  }) async {
    try {
      final refreshToken = storage.getSavedRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      final refreshed = await _authApiService.refreshToken(
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      if (refreshed.token.isEmpty) {
        return null;
      }

      await storage.saveSession(
        token: refreshed.token,
        refreshToken: refreshed.refreshToken ?? refreshToken,
        tokenExpiry: refreshed.expiresOn,
        refreshTokenExpiry: refreshed.refreshTokenExpiration,
      );

      return refreshed.token;
    } catch (_) {
      return null;
    }
  }

  Future<void> _revokeAndClearSession(
    SimpleAuthStorage storage, {
    String? accessToken,
  }) async {
    final refreshToken = storage.getSavedRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _authApiService.revokeToken(
          refreshToken: refreshToken,
          accessToken: accessToken,
        );
      } catch (_) {
        // Ignore revoke failures and continue with local cleanup.
      }
    }

    await storage.clearCredentials();
  }
}
