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
    final rawObjects = json['objects'] ?? json['detections'];
    final parsedObjects =
        rawObjects is List
            ? rawObjects
                .whereType<Map<String, dynamic>>()
                .map(DetectedObject.fromJson)
                .toList(growable: false)
            : const <DetectedObject>[];

    final totalObjects =
        _readInt(json, const ['totalObjects', 'total_objects', 'count']) ??
        parsedObjects.length;

    return ObjectDetectionResponse(
      success: _readBool(json, const ['success']) ?? true,
      objects: parsedObjects,
      totalObjects: totalObjects,
    );
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  static bool? _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) return value;
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true') return true;
        if (normalized == 'false') return false;
      }
    }

    return null;
  }
}
