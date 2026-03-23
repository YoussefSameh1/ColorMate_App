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
      objectId: json['object_id'] as int,
      className: json['class_name'] as String,
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
}
