import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';

class ObjectDetectionResponse {
  final bool success;
  final List<DetectedObject> objects;
  final int totalObjects;

  const ObjectDetectionResponse({
    required this.success,
    required this.objects,
    required this.totalObjects,
  });

  factory ObjectDetectionResponse.fromJson(Map<String, dynamic> json) {
    return ObjectDetectionResponse(
      success: json['success'] as bool,
      objects:
          (json['objects'] as List)
              .map(
                (item) => DetectedObject.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      totalObjects: json['total_objects'] as int,
    );
  }
}
