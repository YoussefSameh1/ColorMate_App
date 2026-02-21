import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final ImagePickerService _imagePickerService;

  ImagePickerCubit(this._imagePickerService) : super(ImagePickerInitial());

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
}
