import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/object&color_detection/data/data_source/object_detection_remote_data_source.dart';
import 'package:colormate_app/features/object&color_detection/data/repo/object_detection_repository.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';

ImagePickerCubit buildObjectAndColorDetectionCubit() {
  final remoteDataSource = ObjectDetectionRemoteDataSource();
  final repository = ObjectDetectionRepositoryImpl(remoteDataSource);

  return ImagePickerCubit(
    ImagePickerService(),
    objectDetectionRepository: repository,
  );
}
