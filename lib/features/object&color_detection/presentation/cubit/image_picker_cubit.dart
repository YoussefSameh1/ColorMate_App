import 'dart:ui';

import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/dominant_color_extractor.dart';
import 'package:colormate_app/features/object&color_detection/data/repo/object_detection_repository.dart';
import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  static const double _minVisibleConfidence = 0.6;

  final ImagePickerService _imagePickerService;
  final ObjectDetectionRepository _objectDetectionRepository;
  final DominantColorExtractor _dominantColorExtractor;

  ImagePickerCubit(
    this._imagePickerService, {
    required ObjectDetectionRepository objectDetectionRepository,
    DominantColorExtractor dominantColorExtractor =
        const DominantColorExtractor(),
  }) : _objectDetectionRepository = objectDetectionRepository,
       _dominantColorExtractor = dominantColorExtractor,
       super(ImagePickerInitial());

  Future<void> pickFromCamera() async {
    emit(ImagePickerLoading());
    try {
      final path = await _imagePickerService.pickImageFromCamera();
      if (path != null) {
        emit(ImagePickerSuccess(path));
      } else {
        emit(ImagePickerInitial());
      }
    } catch (e) {
      emit(ImagePickerError(e.toString()));
    }
  }

  Future<void> pickFromGallery() async {
    emit(ImagePickerLoading());
    try {
      final path = await _imagePickerService.pickImageFromGallery();
      if (path != null) {
        emit(ImagePickerSuccess(path));
      } else {
        emit(ImagePickerInitial());
      }
    } catch (e) {
      emit(ImagePickerError(e.toString()));
    }
  }

  void reset() {
    emit(ImagePickerInitial());
  }

  Future<void> detectObjects() async {
    final currentState = state;
    if (currentState is! ImagePickerSuccess) {
      return;
    }

    emit(currentState.copyWith(isDetecting: true));

    try {
      final response = await _objectDetectionRepository.detectObjects(
        imagePath: currentState.imagePath,
      );
      final visibleObjects = response.objects
          .where((object) => object.confidence >= _minVisibleConfidence)
          .toList(growable: false);
      final deduplicatedObjects = _deduplicateObjects(visibleObjects);
      final imageSize = await _dominantColorExtractor.getImageSize(
        currentState.imagePath,
      );

      emit(
        currentState.copyWith(
          detectedObjects: deduplicatedObjects,
          originalImageSize: imageSize,
          isDetecting: false,
          clearSelectedObjectId: true,
          clearSelectedObjectCropRect: true,
          clearSelectedObjectDominantColor: true,
          isExtractingDominantColor: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isDetecting: false));
      emit(ImagePickerError(e.toString()));
      emit(currentState.copyWith(isDetecting: false));
    }
  }

  Future<void> onDetectedObjectTapped(DetectedObject detectedObject) async {
    final currentState = state;
    if (currentState is! ImagePickerSuccess ||
        currentState.originalImageSize == null) {
      return;
    }

    final imageSize = currentState.originalImageSize!;
    final rect = detectedObject.toRect();

    final normalizedRect = Rect.fromLTRB(
      rect.left.clamp(0, imageSize.width),
      rect.top.clamp(0, imageSize.height),
      rect.right.clamp(0, imageSize.width),
      rect.bottom.clamp(0, imageSize.height),
    );

    emit(
      currentState.copyWith(
        selectedObjectId: detectedObject.objectId,
        selectedObjectCropRect: normalizedRect,
        clearSelectedObjectDominantColor: true,
      ),
    );

    await extractDominantColor(normalizedRect);
  }

  Future<void> onImageTapped(Offset imagePoint) async {
    final currentState = state;
    if (currentState is! ImagePickerSuccess ||
        currentState.originalImageSize == null) {
      return;
    }

    final tappedObject = _findObjectAtPoint(
      imagePoint,
      currentState.detectedObjects,
    );

    if (tappedObject != null) {
      await onDetectedObjectTapped(tappedObject);
      return;
    }

    final sampleRect = _buildTapSampleRect(
      imagePoint,
      currentState.originalImageSize!,
    );

    emit(
      currentState.copyWith(
        clearSelectedObjectId: true,
        selectedObjectCropRect: sampleRect,
        clearSelectedObjectDominantColor: true,
      ),
    );

    await extractDominantColor(sampleRect);
  }

  Future<void> extractDominantColor(Rect cropRect) async {
    final currentState = state;
    if (currentState is! ImagePickerSuccess) {
      return;
    }

    emit(
      currentState.copyWith(
        isExtractingDominantColor: true,
        clearSelectedObjectDominantColor: true,
      ),
    );

    try {
      // استخراج اللون من مركز المنطقة المحددة (Color Picker)
      final centerPoint = Offset(cropRect.center.dx, cropRect.center.dy);

      final dominantColor = await _dominantColorExtractor.extractColorFromPoint(
        imagePath: currentState.imagePath,
        point: centerPoint,
        sampleRadius: 8.0, // متوسط لون في نطاق 8 بيكسل حول النقطة
      );

      final latestState = state;
      if (latestState is ImagePickerSuccess) {
        emit(
          latestState.copyWith(
            isExtractingDominantColor: false,
            selectedObjectDominantColor: dominantColor,
          ),
        );
      }
    } catch (e) {
      final latestState = state;
      if (latestState is ImagePickerSuccess) {
        emit(latestState.copyWith(isExtractingDominantColor: false));
      }
      emit(ImagePickerError(e.toString()));
      final recoveredState = state;
      if (recoveredState is ImagePickerSuccess) {
        emit(recoveredState.copyWith(isExtractingDominantColor: false));
      }
    }
  }

  DetectedObject? getSelectedDetectedObject() {
    final currentState = state;
    if (currentState is! ImagePickerSuccess ||
        currentState.selectedObjectId == null) {
      return null;
    }

    try {
      return currentState.detectedObjects.firstWhere(
        (object) => object.objectId == currentState.selectedObjectId,
      );
    } catch (_) {
      return null;
    }
  }

  DetectedObject? _findObjectAtPoint(
    Offset point,
    List<DetectedObject> objects,
  ) {
    DetectedObject? bestMatch;
    var bestArea = double.infinity;

    for (final object in objects) {
      final rect = object.toRect();
      if (!rect.contains(point)) {
        continue;
      }

      final area = rect.width * rect.height;
      if (area < bestArea) {
        bestArea = area;
        bestMatch = object;
      }
    }

    return bestMatch;
  }

  Rect _buildTapSampleRect(Offset point, Size imageSize) {
    const sampleSize = 24.0;
    final halfSample = sampleSize / 2;

    final left = (point.dx - halfSample).clamp(0, imageSize.width - 1);
    final top = (point.dy - halfSample).clamp(0, imageSize.height - 1);
    final right = (point.dx + halfSample).clamp(left + 1, imageSize.width);
    final bottom = (point.dy + halfSample).clamp(top + 1, imageSize.height);

    return Rect.fromLTRB(
      left.toDouble(),
      top.toDouble(),
      right.toDouble(),
      bottom.toDouble(),
    );
  }

  List<DetectedObject> _deduplicateObjects(List<DetectedObject> objects) {
    if (objects.length < 2) {
      return objects;
    }

    final sortedObjects = List<DetectedObject>.from(objects)
      ..sort((left, right) => right.confidence.compareTo(left.confidence));

    final uniqueObjects = <DetectedObject>[];

    for (final object in sortedObjects) {
      final isDuplicate = uniqueObjects.any(
        (candidate) =>
            candidate.className.toLowerCase() ==
                object.className.toLowerCase() &&
            _intersectionOverUnion(candidate.toRect(), object.toRect()) >= 0.75,
      );

      if (!isDuplicate) {
        uniqueObjects.add(object);
      }
    }

    return uniqueObjects;
  }

  double _intersectionOverUnion(Rect first, Rect second) {
    final left = first.left > second.left ? first.left : second.left;
    final top = first.top > second.top ? first.top : second.top;
    final right = first.right < second.right ? first.right : second.right;
    final bottom = first.bottom < second.bottom ? first.bottom : second.bottom;

    final intersectionWidth = right - left;
    final intersectionHeight = bottom - top;
    if (intersectionWidth <= 0 || intersectionHeight <= 0) {
      return 0;
    }

    final intersectionArea = intersectionWidth * intersectionHeight;
    final firstArea = first.width * first.height;
    final secondArea = second.width * second.height;
    final unionArea = firstArea + secondArea - intersectionArea;

    if (unionArea <= 0) {
      return 0;
    }

    return intersectionArea / unionArea;
  }
}
