import 'dart:io';

import 'package:colormate_app/features/image_correction/data/repositories/image_correction_repository_impl.dart';
import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';
import 'package:colormate_app/features/image_correction/domain/usecases/apply_cvd_filter_usecase.dart';
import 'package:colormate_app/features/image_correction/presentation/view_model/cubit/image_correction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCorrectionCubit extends Cubit<ImageCorrectionState> {
  ImageCorrectionCubit({
    required ImageCorrectionRepositoryImpl repository,
    required ApplyCvdFilterUseCase applyCvdFilterUseCase,
  }) : _repository = repository,
       _applyCvdFilterUseCase = applyCvdFilterUseCase,
       super(ImageCorrectionState.initial()) {
    loadFilterOptions();
  }

  final ImageCorrectionRepositoryImpl _repository;
  final ApplyCvdFilterUseCase _applyCvdFilterUseCase;

  Future<void> loadFilterOptions() async {
    emit(state.copyWith(isLoadingFilters: true, clearErrorMessage: true));
    try {
      final options = await _repository.getFilterOptions();
      emit(
        state.copyWith(
          isLoadingFilters: false,
          filterOptions: options,
          selectedFilterIndex: 0,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingFilters: false,
          errorMessage: 'Failed to load correction filters.',
        ),
      );
    }
  }

  Future<void> selectFilter({
    required int index,
    required String? imagePath,
  }) async {
    if (index < 0 || index >= state.filterOptions.length) {
      return;
    }

    emit(
      state.copyWith(
        selectedFilterIndex: index,
        clearErrorMessage: true,
        clearLastSavedPath: true,
      ),
    );

    await applySelectedFilter(imagePath: imagePath);
  }

  Future<void> changeMode({
    required CvdMode mode,
    required String? imagePath,
  }) async {
    if (state.mode == mode) {
      return;
    }

    emit(state.copyWith(mode: mode, clearErrorMessage: true));
    await applySelectedFilter(imagePath: imagePath);
  }

  Future<void> applySelectedFilter({required String? imagePath}) async {
    if (imagePath == null || imagePath.isEmpty) {
      emit(state.copyWith(clearProcessedImagePath: true));
      return;
    }

    final selected = state.selectedFilter;
    if (selected == null || selected.type == CvdType.none) {
      emit(
        state.copyWith(clearProcessedImagePath: true, clearErrorMessage: true),
      );
      return;
    }

    emit(
      state.copyWith(
        isProcessing: true,
        clearErrorMessage: true,
        clearLastSavedPath: true,
      ),
    );

    try {
      final processedPath = await _applyCvdFilterUseCase(
        imagePath: imagePath,
        cvdType: selected.type,
        mode: state.mode,
        severity: 1.0,
      );
      emit(
        state.copyWith(
          isProcessing: false,
          processedImagePath: processedPath,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isProcessing: false,
          errorMessage: 'Image processing failed. Please try another image.',
        ),
      );
    }
  }

  Future<void> saveProcessedImage({required String? originalImagePath}) async {
    final processedPath = state.processedImagePath;
    if (processedPath == null || processedPath.isEmpty) {
      emit(state.copyWith(errorMessage: 'No processed image to save.'));
      return;
    }

    try {
      final source = File(processedPath);
      if (!await source.exists()) {
        emit(state.copyWith(errorMessage: 'Processed image file not found.'));
        return;
      }

      final targetDirectory =
          originalImagePath == null
              ? Directory.systemTemp
              : File(originalImagePath).parent;

      final selectedType = state.selectedFilter?.type.name ?? 'cvd';
      final modeTag = state.mode == CvdMode.simulation ? 'sim' : 'corr';
      final destinationPath =
          '${targetDirectory.path}${Platform.pathSeparator}saved_${modeTag}_${selectedType}_${DateTime.now().millisecondsSinceEpoch}.png';

      await source.copy(destinationPath);
      emit(
        state.copyWith(lastSavedPath: destinationPath, clearErrorMessage: true),
      );
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Could not save processed image.'));
    }
  }

  void reset() {
    emit(
      state.copyWith(
        selectedFilterIndex: 0,
        mode: CvdMode.simulation,
        clearProcessedImagePath: true,
        clearErrorMessage: true,
        clearLastSavedPath: true,
      ),
    );
  }

  void clearTransientMessages() {
    emit(state.copyWith(clearErrorMessage: true, clearLastSavedPath: true));
  }
}
