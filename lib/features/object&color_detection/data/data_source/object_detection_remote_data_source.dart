import 'package:colormate_app/features/object&color_detection/data/model/object_detection_response.dart';
import 'package:dio/dio.dart';

class ObjectDetectionRemoteDataSource {
  final Dio _dio;

  ObjectDetectionRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> detectObjects({
    required String imagePath,
  }) async {
    // API integration will be enabled later.
    // final formData = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(imagePath),
    // });
    //
    // final response = await _dio.post(
    //   'https://your-backend/api/v1/detect',
    //   data: formData
    // );
    //
    // return Map<String, dynamic>.from(response.data as Map);

    final _ = _dio;
    return kMockDetectionResponse;
  }
}
