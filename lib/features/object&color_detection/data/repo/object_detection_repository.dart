import 'package:colormate_app/features/object&color_detection/data/data_source/object_detection_remote_data_source.dart';
import 'package:colormate_app/features/object&color_detection/data/model/object_detection_response.dart';

abstract class ObjectDetectionRepository {
  Future<ObjectDetectionResponse> detectObjects({required String imagePath});
}

class ObjectDetectionRepositoryImpl implements ObjectDetectionRepository {
  final ObjectDetectionRemoteDataSource _remoteDataSource;

  ObjectDetectionRepositoryImpl(this._remoteDataSource);

  @override
  Future<ObjectDetectionResponse> detectObjects({
    required String imagePath,
  }) async {
    final json = await _remoteDataSource.detectObjects(imagePath: imagePath);
    return ObjectDetectionResponse.fromJson(json);
  }
}
