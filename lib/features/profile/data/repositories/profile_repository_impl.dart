import 'dart:io';

import 'package:dio/dio.dart';

import 'package:colormate_app/core/storage/simple_auth_storage.dart';
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

  ProfileRepositoryImpl({Dio? dio})
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

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final storage = SimpleAuthStorage();
      await storage.init();
      final token = storage.getSavedToken();

      if (token == null || token.isEmpty) {
        throw const ProfileApiException('Unauthorized: please login again.');
      }

      final attempts = _buildAuthHeaderAttempts(token);

      DioException? last401;

      for (final headers in attempts) {
        try {
          final response = await _dio.get(
            '/api/Profile',
            options: Options(headers: headers),
          );

          final data = response.data;
          if (data is Map<String, dynamic>) {
            return UserProfileModel.fromJson(data);
          }

          throw const ProfileApiException(
            'Invalid profile response from server.',
          );
        } on DioException catch (error) {
          if ((error.response?.statusCode ?? 0) == 401) {
            last401 = error;
            continue;
          }
          rethrow;
        }
      }

      if (last401 != null) {
        await storage.clearCredentials();
        throw last401;
      }

      throw const ProfileApiException('Unable to fetch profile now.');
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
      final token = storage.getSavedToken();

      if (token == null || token.isEmpty) {
        throw const ProfileApiException('Unauthorized: please login again.');
      }

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

      final attempts = _buildAuthHeaderAttempts(token);
      DioException? last401;

      for (final headers in attempts) {
        try {
          final formData = FormData.fromMap({
            'Picture': await MultipartFile.fromFile(
              pictureFile.path,
              filename: pictureFile.uri.pathSegments.last,
            ),
          });

          final response = await _dio.put(
            '/api/Profile/picture',
            data: formData,
            options: Options(headers: headers),
          );

          return _extractImageUrl(response.data);
        } on DioException catch (error) {
          if ((error.response?.statusCode ?? 0) == 401) {
            last401 = error;
            continue;
          }
          rethrow;
        }
      }

      if (last401 != null) {
        await storage.clearCredentials();
        throw last401;
      }

      throw const ProfileApiException('Unable to upload profile picture now.');
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
      final token = storage.getSavedToken();

      if (token == null || token.isEmpty) {
        throw const ProfileApiException('Unauthorized: please login again.');
      }

      final attempts = _buildAuthHeaderAttempts(token);
      final payload = {
        'firstName': profile.firstName,
        'lastName': profile.lastName,
        'phoneNumber': profile.phoneNumber,
      };

      DioException? last401;

      for (final headers in attempts) {
        try {
          await _dio.put(
            '/api/Profile',
            data: payload,
            options: Options(headers: headers),
          );
          return;
        } on DioException catch (error) {
          if ((error.response?.statusCode ?? 0) == 401) {
            last401 = error;
            continue;
          }
          rethrow;
        }
      }

      if (last401 != null) {
        await storage.clearCredentials();
        throw last401;
      }

      throw const ProfileApiException('Unable to update profile now.');
    } on DioException catch (error) {
      throw ProfileApiException(_toUserFriendlyMessage(error));
    } on ProfileApiException {
      rethrow;
    } catch (_) {
      throw const ProfileApiException('Unexpected error happened.');
    }
  }

  List<Map<String, dynamic>> _buildAuthHeaderAttempts(String rawToken) {
    final normalizedToken = rawToken.replaceFirst(
      RegExp(r'^Bearer\s+', caseSensitive: false),
      '',
    );

    return [
      <String, dynamic>{'Authorization': 'Bearer $normalizedToken'},
      <String, dynamic>{'Authorization': normalizedToken},
      <String, dynamic>{'token': normalizedToken},
      <String, dynamic>{'x-access-token': normalizedToken},
    ];
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

  // Future<String> _uploadImageToServer(String imagePath) async {
  //   try {

  //     final cleanPath = imagePath.replaceFirst('file://', '');
  //     final File imageFile = File(cleanPath);
  //

  //     if (!await imageFile.exists()) {
  //       throw Exception('Image file not found at: $cleanPath');
  //     }
  //

  //     final formData = FormData.fromMap({
  //       'image': await MultipartFile.fromFile(
  //         imageFile.path,
  //         filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //       ),
  //     });
  //
  //
  //     final response = await _apiService.post('/upload/profile-image', data: formData);
  //

  //     if (response.data['success'] == true && response.data['image_url'] != null) {
  //       return response.data['image_url'];
  //     } else {
  //       throw Exception('Invalid response from server');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to upload image: $e');
  //   }
  // }
}
