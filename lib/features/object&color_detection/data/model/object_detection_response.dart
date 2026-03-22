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

const Map<String, dynamic> kMockDetectionResponse = {
  'success': true,
  'objects': [
    {
      'object_id': 0,
      'class_name': 'teddy bear',
      'confidence': 0.88,
      'bbox': [0, 268, 322, 638],
    },
    {
      'object_id': 1,
      'class_name': 'teddy bear',
      'confidence': 0.71,
      'bbox': [99, 0, 428, 573],
    },
    {
      'object_id': 2,
      'class_name': 'teddy bear',
      'confidence': 0.54,
      'bbox': [0, 55, 202, 291],
    },
  ],
  'total_objects': 3,
};
