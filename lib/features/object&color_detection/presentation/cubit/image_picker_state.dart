import 'dart:ui';

import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';
import 'package:colormate_app/features/object&color_detection/data/model/user_detection_history_item.dart';

abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {
  final List<UserDetectionHistoryItem> history;
  final bool isLoadingHistory;

  ImagePickerInitial({
    this.history = const [],
    this.isLoadingHistory = false,
  });

  ImagePickerInitial copyWith({
    List<UserDetectionHistoryItem>? history,
    bool? isLoadingHistory,
  }) {
    return ImagePickerInitial(
      history: history ?? this.history,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    );
  }
}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerSuccess extends ImagePickerState {
  final String imagePath;
  final List<DetectedObject> detectedObjects;
  final List<UserDetectionHistoryItem> history;
  final Size? originalImageSize;
  final bool isDetecting;
  final bool isLoadingHistory;
  final int? selectedObjectId;
  final Rect? selectedObjectCropRect;
  final bool isExtractingDominantColor;
  final Color? selectedObjectDominantColor;

  ImagePickerSuccess(
    this.imagePath, {
    this.detectedObjects = const [],
    this.history = const [],
    this.originalImageSize,
    this.isDetecting = false,
    this.isLoadingHistory = false,
    this.selectedObjectId,
    this.selectedObjectCropRect,
    this.isExtractingDominantColor = false,
    this.selectedObjectDominantColor,
  });

  ImagePickerSuccess copyWith({
    List<DetectedObject>? detectedObjects,
    List<UserDetectionHistoryItem>? history,
    Size? originalImageSize,
    bool? isDetecting,
    int? selectedObjectId,
    bool clearSelectedObjectId = false,
    Rect? selectedObjectCropRect,
    bool clearSelectedObjectCropRect = false,
    bool? isExtractingDominantColor,
    Color? selectedObjectDominantColor,
    bool clearSelectedObjectDominantColor = false,
    bool? isLoadingHistory,
  }) {
    return ImagePickerSuccess(
      imagePath,
      detectedObjects: detectedObjects ?? this.detectedObjects,
      history: history ?? this.history,
      originalImageSize: originalImageSize ?? this.originalImageSize,
      isDetecting: isDetecting ?? this.isDetecting,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
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
