import 'dart:io';

import 'package:colormate_app/core/services/auth_session_manager.dart';
import 'package:colormate_app/core/storage/simple_auth_storage.dart';
import 'package:colormate_app/features/authentication/auth_data/services/auth_api_service.dart';
import 'package:colormate_app/features/fruits/presentation/cubit/fruit_result_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FruitResultCubit extends Cubit<FruitResultState> {
  FruitResultCubit() : super(FruitResultInitial());

  final AuthSessionManager _sessionManager = AuthSessionManager(
    authApiService: AuthApiService(),
    storage: SimpleAuthStorage(),
  );

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://colormate.runasp.net/api/',
      connectTimeout: const Duration(seconds: 30),
      // ⚠️ AI inference can be slow — give it enough time
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<void> analyzeFruit(String imagePath) async {
    emit(FruitResultLoading());

    try {
      await _sessionManager.init();
      final token = await _sessionManager.getValidAccessToken();

      // ✅ Build multipart form — field name must match Swagger: "UploadedImage"
      final formData = FormData.fromMap({
        'UploadedImage': await MultipartFile.fromFile(
          imagePath,
          filename: File(imagePath).uri.pathSegments.last,
        ),
      });

      final response = await _dio.post(
        'Fruits/upload-image',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;

      // ✅ ADD THIS — check the real response in your console
      print('🍎 FRUIT API RESPONSE: $data');

      final success = data['success'] == true;
      if (!success) {
        emit(FruitResultError('Analysis failed. Please try again.'));
        return;
      }

      final prediction = data['prediction'] as Map<String, dynamic>;

      final predictedClass =
          (prediction['predicted_Class'] ?? prediction['predicted_class'] ?? '')
              as String;

      final confidence = (prediction['confidence'] as num).toDouble();
      final probabilities = prediction['probabilities'] as Map<String, dynamic>;

      final rottenProb =
          ((probabilities['Rotten'] as num?)?.toDouble() ?? confidence) * 100;

      final status = predictedClass == 'Rotten' ? 'Not Fresh' : 'Fresh';

      emit(
        FruitResultSuccess(
          imagePath: imagePath,
          spoiledPercent: rottenProb,
          status: status,
          predictedClass: predictedClass,
          confidence: confidence,
        ),
      );
    } on AuthSessionException catch (e) {
      emit(FruitResultError(e.message));
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
      emit(FruitResultError(message));
    } catch (e) {
      emit(FruitResultError('Unexpected error: ${e.toString()}'));
    }
  }
}
