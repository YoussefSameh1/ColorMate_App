import 'package:colormate_app/features/matching/presentation/cubit/upload_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colormate_app/core/services/image_picker_service.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  final ImagePickerService _imagePickerService;

  UploadImageCubit(this._imagePickerService)
      : super(UploadImageInitial());

  Future<void> pickFromGallery() async {
    emit(UploadImageLoading());
    try {
      final path = await _imagePickerService.pickImageFromGallery();

      if (path != null) {
        emit(UploadImageSuccess(path));
      } else {
        emit(UploadImageInitial());
      }
    } catch (e) {
      emit(UploadImageError(e.toString()));
    }
  }

  Future<void> pickFromCamera() async {
    emit(UploadImageLoading());
    try {
      final path = await _imagePickerService.pickImageFromCamera();

      if (path != null) {
        emit(UploadImageSuccess(path));
      } else {
        emit(UploadImageInitial());
      }
    } catch (e) {
      emit(UploadImageError(e.toString()));
    }
  }

  void reset() {
    emit(UploadImageInitial());
  }
}