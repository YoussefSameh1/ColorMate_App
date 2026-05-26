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
      className: _readString(
        json,
        const ['class_name', 'className', 'name', 'label'],
      ),
      confidence: _readDouble(json, const ['confidence', 'score']),
      bbox: _readDoubleList(json, const ['bbox', 'box']),
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

  static double _readDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
    }

    throw const FormatException('Missing detected object confidence.');
  }

  static List<double> _readDoubleList(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) {
        return value
            .whereType<num>()
            .map((item) => item.toDouble())
            .toList(growable: false);
      }
    }

    throw const FormatException('Missing detected object bbox.');
  }
}
