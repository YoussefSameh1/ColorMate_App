import 'dart:ui';

import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';

abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerSuccess extends ImagePickerState {
  final String imagePath;
  final List<DetectedObject> detectedObjects;
  final Size? originalImageSize;
  final bool isDetecting;
  final int? selectedObjectId;
  final Rect? selectedObjectCropRect;
  final bool isExtractingDominantColor;
  final Color? selectedObjectDominantColor;

  ImagePickerSuccess(
    this.imagePath, {
    this.detectedObjects = const [],
    this.originalImageSize,
    this.isDetecting = false,
    this.selectedObjectId,
    this.selectedObjectCropRect,
    this.isExtractingDominantColor = false,
    this.selectedObjectDominantColor,
  });

  ImagePickerSuccess copyWith({
    List<DetectedObject>? detectedObjects,
    Size? originalImageSize,
    bool? isDetecting,
    int? selectedObjectId,
    bool clearSelectedObjectId = false,
    Rect? selectedObjectCropRect,
    bool clearSelectedObjectCropRect = false,
    bool? isExtractingDominantColor,
    Color? selectedObjectDominantColor,
    bool clearSelectedObjectDominantColor = false,
  }) {
    return ImagePickerSuccess(
      imagePath,
      detectedObjects: detectedObjects ?? this.detectedObjects,
      originalImageSize: originalImageSize ?? this.originalImageSize,
      isDetecting: isDetecting ?? this.isDetecting,
      selectedObjectId:
          clearSelectedObjectId
              ? null
              : selectedObjectId ?? this.selectedObjectId,
      selectedObjectCropRect:
          clearSelectedObjectCropRect
              ? null
              : selectedObjectCropRect ?? this.selectedObjectCropRect,
      isExtractingDominantColor:
          isExtractingDominantColor ?? this.isExtractingDominantColor,
      selectedObjectDominantColor:
          clearSelectedObjectDominantColor
              ? null
              : selectedObjectDominantColor ?? this.selectedObjectDominantColor,
    );
  }
}

class ImagePickerError extends ImagePickerState {
  final String message;
  ImagePickerError(this.message);
}
