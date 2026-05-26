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
    const minConfidence = 0.5;

    final rawObjects = json['objects'];
    final filteredObjects =
        rawObjects is List
            ? rawObjects
                .whereType<Map<String, dynamic>>()
                .map(DetectedObject.fromJson)
                .where((object) => object.confidence >= minConfidence)
                .toList(growable: false)
            : const <DetectedObject>[];

    return ObjectDetectionResponse(
      success: json['success'] as bool,
      objects: filteredObjects,
      totalObjects: filteredObjects.length,
    );
  }
}
