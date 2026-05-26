import 'dart:convert';
import 'dart:typed_data';

import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';

class UserDetectionHistoryItem {
  final String imageBase64;
  final int totalObjects;
  final List<DetectedObject> objects;
  final int? objDetectionWithImageId;

  UserDetectionHistoryItem({
    required this.imageBase64,
    required this.totalObjects,
    required this.objects,
    this.objDetectionWithImageId,
  });

  factory UserDetectionHistoryItem.fromJson(Map<String, dynamic> json) {
    const minConfidence = 0.5;

    final objs = <DetectedObject>[];
    final rawObjects = json['objects'];
    if (rawObjects is List) {
      for (final item in rawObjects) {
        if (item is Map<String, dynamic>) {
          final detectedObject = DetectedObject.fromJson(item);
          if (detectedObject.confidence >= minConfidence) {
            objs.add(detectedObject);
          }
        }
      }
    }

    return UserDetectionHistoryItem(
      imageBase64: _normalizeBase64(json['imageBase64']),
      totalObjects: objs.length,
      objects: objs,
      objDetectionWithImageId: json['objDetectionWithImageId'] as int?,
    );
  }

  Uint8List? decodeImageBytes() {
    if (imageBase64.trim().isEmpty) return null;
    try {
      return base64Decode(_stripDataUriPrefix(imageBase64));
    } catch (_) {
      return null;
    }
  }

  static String _normalizeBase64(dynamic value) {
    if (value is! String) return '';
    return _stripDataUriPrefix(value).trim();
  }

  static String _stripDataUriPrefix(String value) {
    final trimmed = value.trim();
    final commaIndex = trimmed.indexOf('base64,');
    if (trimmed.startsWith('data:') && commaIndex != -1) {
      return trimmed.substring(commaIndex + 'base64,'.length);
    }
    return trimmed;
  }
}
