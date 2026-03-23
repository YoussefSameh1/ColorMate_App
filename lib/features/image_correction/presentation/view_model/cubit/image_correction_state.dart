import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';

class ImageCorrectionState {
  const ImageCorrectionState({
    required this.filterOptions,
    required this.selectedFilterIndex,
    required this.mode,
    required this.isLoadingFilters,
    required this.isProcessing,
    required this.processedImagePath,
    required this.errorMessage,
    required this.lastSavedPath,
  });

  factory ImageCorrectionState.initial() {
    return const ImageCorrectionState(
      filterOptions: [],
      selectedFilterIndex: 0,
      mode: CvdMode.simulation,
      isLoadingFilters: false,
      isProcessing: false,
      processedImagePath: null,
      errorMessage: null,
      lastSavedPath: null,
    );
  }

  final List<CvdFilterOption> filterOptions;
  final int selectedFilterIndex;
  final CvdMode mode;
  final bool isLoadingFilters;
  final bool isProcessing;
  final String? processedImagePath;
  final String? errorMessage;
  final String? lastSavedPath;

  CvdFilterOption? get selectedFilter {
    if (filterOptions.isEmpty || selectedFilterIndex >= filterOptions.length) {
      return null;
    }
    return filterOptions[selectedFilterIndex];
  }

  bool get hasProcessedImage => processedImagePath != null;

  ImageCorrectionState copyWith({
    List<CvdFilterOption>? filterOptions,
    int? selectedFilterIndex,
    CvdMode? mode,
    bool? isLoadingFilters,
    bool? isProcessing,
    String? processedImagePath,
    bool clearProcessedImagePath = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? lastSavedPath,
    bool clearLastSavedPath = false,
  }) {
    return ImageCorrectionState(
      filterOptions: filterOptions ?? this.filterOptions,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      mode: mode ?? this.mode,
      isLoadingFilters: isLoadingFilters ?? this.isLoadingFilters,
      isProcessing: isProcessing ?? this.isProcessing,
      processedImagePath:
          clearProcessedImagePath
              ? null
              : processedImagePath ?? this.processedImagePath,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      lastSavedPath:
          clearLastSavedPath ? null : lastSavedPath ?? this.lastSavedPath,
    );
  }
}
