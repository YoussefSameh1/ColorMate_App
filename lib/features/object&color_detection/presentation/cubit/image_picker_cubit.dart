import 'dart:ui';

import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/dominant_color_extractor.dart';
import 'package:colormate_app/features/object&color_detection/data/repo/object_detection_repository.dart';
import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';
import 'package:colormate_app/features/object&color_detection/data/model/user_detection_history_item.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class ImagePickerCubit extends Cubit<ImagePickerState> {
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

  List<UserDetectionHistoryItem> _historyFromState(ImagePickerState state) {
    if (state is ImagePickerSuccess) return state.history;
    if (state is ImagePickerInitial) return state.history;
    return const [];
  }

  Future<void> pickFromCamera() async {
    final cachedHistory = _historyFromState(state);
    emit(ImagePickerLoading());
    try {
      final path = await _imagePickerService.pickImageFromCamera();
      if (path != null) {
        emit(ImagePickerSuccess(path, history: cachedHistory));
      } else {
        emit(ImagePickerInitial(history: cachedHistory));
      }
    } catch (e) {
      emit(ImagePickerError(e.toString()));
    }
  }

  Future<void> pickFromGallery() async {
    final cachedHistory = _historyFromState(state);
    emit(ImagePickerLoading());
    try {
      final path = await _imagePickerService.pickImageFromGallery();
      if (path != null) {
        emit(ImagePickerSuccess(path, history: cachedHistory));
      } else {
        emit(ImagePickerInitial(history: cachedHistory));
      }
    } catch (e) {
      emit(ImagePickerError(e.toString()));
    }
  }

  void reset() {
    emit(ImagePickerInitial(history: _historyFromState(state)));
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
      final imageSize = await _dominantColorExtractor.getImageSize(
        currentState.imagePath,
      );

      emit(
        currentState.copyWith(
          detectedObjects: response.objects,
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

  Future<List<UserDetectionHistoryItem>> fetchUserDetectionsHistory() async {
    final currentState = state;
    if (currentState is ImagePickerSuccess) {
      emit(currentState.copyWith(isLoadingHistory: true));
    } else if (currentState is ImagePickerInitial) {
      emit(currentState.copyWith(isLoadingHistory: true));
    }

    try {
      final items =
          await _objectDetectionRepository.fetchUserDetectionsHistory();
      final latest = state;
      if (latest is ImagePickerSuccess) {
        emit(latest.copyWith(history: items, isLoadingHistory: false));
      } else if (latest is ImagePickerInitial) {
        emit(latest.copyWith(history: items, isLoadingHistory: false));
      }

      return items;
    } catch (e) {
      final latest = state;
      if (latest is ImagePickerSuccess) {
        emit(latest.copyWith(isLoadingHistory: false));
      } else if (latest is ImagePickerInitial) {
        emit(latest.copyWith(isLoadingHistory: false));
      }
      emit(ImagePickerError(e.toString()));
      return const <UserDetectionHistoryItem>[];
    }
  }

  /// Open a history item: write its base64 image to a temporary file and
  /// set the current state to show that image with the parsed detected objects.
  Future<void> openHistoryItem(UserDetectionHistoryItem item) async {
    try {
      final bytes = item.decodeImageBytes();
      if (bytes == null) {
        throw Exception('Invalid image data in history item.');
      }

      final tmpDir = Directory.systemTemp;
      final file =
          await File(
            '${tmpDir.path}/colormate_history_${DateTime.now().microsecondsSinceEpoch}.png',
          ).create();
      await file.writeAsBytes(bytes, flush: true);

      final imageSize = await _dominantColorExtractor.getImageSize(file.path);

      emit(
        ImagePickerSuccess(
          file.path,
          detectedObjects: item.objects,
          history: _historyFromState(state),
          originalImageSize: imageSize,
          isDetecting: false,
          isExtractingDominantColor: false,
        ),
      );
    } catch (e) {
      emit(ImagePickerError(e.toString()));
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
      final dominantColor = await _dominantColorExtractor.extractFromImagePath(
        imagePath: currentState.imagePath,
        cropRect: cropRect,
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
}
