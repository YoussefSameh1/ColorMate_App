import 'package:colormate_app/features/image_correction/data/services/cvd_image_processing_service.dart';
import 'package:colormate_app/features/image_correction/data/sources/cvd_filter_local_data_source.dart';
import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';
import 'package:colormate_app/features/image_correction/domain/repositories/image_correction_repository.dart';

class ImageCorrectionRepositoryImpl implements ImageCorrectionRepository {
  ImageCorrectionRepositoryImpl({
    required CvdFilterLocalDataSource filterDataSource,
    required CvdImageProcessingService processingService,
  }) : _filterDataSource = filterDataSource,
       _processingService = processingService;

  final CvdFilterLocalDataSource _filterDataSource;
  final CvdImageProcessingService _processingService;

  Future<List<CvdFilterOption>> getFilterOptions() async {
    final items = await _filterDataSource.getFilterOptions();
    return items.map((item) => item.toDomain()).toList(growable: false);
  }

  @override
  Future<String> processImage({
    required String imagePath,
    required CvdType cvdType,
    required CvdMode mode,
    double severity = 1.0,
  }) {
    return _processingService.processImage(
      imagePath: imagePath,
      cvdType: cvdType,
      mode: mode,
      severity: severity,
    );
  }
}
