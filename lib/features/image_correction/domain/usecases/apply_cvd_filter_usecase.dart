import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';
import 'package:colormate_app/features/image_correction/domain/repositories/image_correction_repository.dart';

class ApplyCvdFilterUseCase {
  ApplyCvdFilterUseCase(this._repository);

  final ImageCorrectionRepository _repository;

  Future<String> call({
    required String imagePath,
    required CvdType cvdType,
    required CvdMode mode,
    double severity = 1.0,
  }) {
    return _repository.processImage(
      imagePath: imagePath,
      cvdType: cvdType,
      mode: mode,
      severity: severity,
    );
  }
}
