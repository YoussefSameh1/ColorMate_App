import 'dart:ui';

class DetectedObject {
  final int objectId;
  final String className;
  final double confidence;
  final List<double> bbox;

  const DetectedObject({
    required this.objectId,
    required this.className,
    required this.confidence,
    required this.bbox,
  });

  factory DetectedObject.fromJson(Map<String, dynamic> json) {
    return DetectedObject(
      objectId: _readInt(json, const ['object_id', 'objectId', 'id']),
      className: _readString(json, const ['class_name', 'className', 'name']),
      confidence: (json['confidence'] as num).toDouble(),
      bbox:
          (json['bbox'] as List)
              .map((value) => (value as num).toDouble())
              .toList(),
    );
  }

  Rect toRect() {
    return Rect.fromLTRB(bbox[0], bbox[1], bbox[2], bbox[3]);
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }

    throw const FormatException('Missing detected object id.');
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }

    throw const FormatException('Missing detected object class name.');
  }
}
