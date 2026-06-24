import 'package:colormate_app/features/image_correction/data/repositories/image_correction_repository_impl.dart';
import 'package:colormate_app/features/image_correction/data/services/cvd_image_processing_service.dart';
import 'package:colormate_app/features/image_correction/data/sources/cvd_filter_local_data_source.dart';
import 'package:colormate_app/features/image_correction/domain/usecases/apply_cvd_filter_usecase.dart';
import 'package:colormate_app/features/image_correction/presentation/view_model/cubit/image_correction_cubit.dart';

ImageCorrectionCubit buildImageCorrectionCubit() {
  final repository = ImageCorrectionRepositoryImpl(
    filterDataSource: const CvdFilterLocalDataSource(),
    processingService: const CvdImageProcessingService(),
  );

  return ImageCorrectionCubit(
    repository: repository,
    applyCvdFilterUseCase: ApplyCvdFilterUseCase(repository),
  );
}
