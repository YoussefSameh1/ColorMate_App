import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';

abstract class ImageCorrectionRepository {
  Future<String> processImage({
    required String imagePath,
    required CvdType cvdType,
    required CvdMode mode,
    double severity = 1.0,
  });
}
