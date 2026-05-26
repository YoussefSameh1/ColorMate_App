import 'package:colormate_app/features/object&color_detection/data/data_source/object_detection_remote_data_source.dart';
import 'package:colormate_app/features/object&color_detection/data/model/object_detection_response.dart';
import 'package:colormate_app/features/object&color_detection/data/model/user_detection_history_item.dart';

abstract class ObjectDetectionRepository {
  Future<ObjectDetectionResponse> detectObjects({required String imagePath});
  Future<List<UserDetectionHistoryItem>> fetchUserDetectionsHistory();
}

class ObjectDetectionRepositoryImpl implements ObjectDetectionRepository {
  final ObjectDetectionRemoteDataSource _remoteDataSource;

  ObjectDetectionRepositoryImpl(this._remoteDataSource);

  @override
  Future<ObjectDetectionResponse> detectObjects({
    required String imagePath,
  }) async {
    final response = await _remoteDataSource.detectObjects(
      imagePath: imagePath,
    );
    return ObjectDetectionResponse.fromJson(response);
  }

  @override
  Future<List<UserDetectionHistoryItem>> fetchUserDetectionsHistory() async {
    final response = await _remoteDataSource.fetchUserDetectionsHistory();
    return response
        .map((item) => UserDetectionHistoryItem.fromJson(item))
        .toList(growable: false);
  }
}
