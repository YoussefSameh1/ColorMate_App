import 'dart:io';

import 'package:colormate_app/core/services/auth_session_manager.dart';
import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/matching/presentation/cubit/matching_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchingCubit extends Cubit<MatchingState> {
  MatchingCubit() : super(MatchingInitial());

  final AuthSessionManager _sessionManager = AuthSessionManager(
    authApiService: AuthApiService(),
    storage: SimpleAuthStorage(),
  );

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://colormate.runasp.net/api/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<void> analyzeFruit(String imagePath) async {
    emit(MatchingLoading());

    try {
      await _sessionManager.init();
      final token = await _sessionManager.getValidAccessToken();

      final formData = FormData.fromMap({
        // ✅ Swagger shows lowercase 'uploadedImage'
        'uploadedImage': await MultipartFile.fromFile(
          imagePath,
          filename: File(imagePath).uri.pathSegments.last,
        ),
      });

      final response = await _dio.post(
        'OutfitRating/upload-image',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data as Map<String, dynamic>;

      final score = (data['score'] as num).toDouble();

      final suggestions = (data['suggestions'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();

      emit(
        MatchingSuccess(
          imagePath: imagePath,
          score: score,
          suggestions: suggestions,
        ),
      );
    } on AuthSessionException catch (e) {
      emit(MatchingError(e.message));
    } on DioException catch (e) {
      final message = switch (e.type) {
        DioExceptionType.connectionTimeout =>
          'Connection timed out. Check your internet.',
        DioExceptionType.receiveTimeout =>
          'Analysis is taking too long. Please try again.',
        DioExceptionType.badResponse => switch (e.response?.statusCode) {
          401 => 'Session expired. Please log in again.',
          400 => 'Invalid image. Please try a different photo.',
          _ => 'Server error: ${e.response?.statusCode}',
        },
        DioExceptionType.connectionError => 'No internet connection.',
        _ => 'Something went wrong. Please try again.',
      };
      emit(MatchingError(message));
    } catch (e) {
      emit(MatchingError('Unexpected error: ${e.toString()}'));
    }
  }
}