abstract class ImagePickerState {}

class ImagePickerInitial extends ImagePickerState {}

class ImagePickerLoading extends ImagePickerState {}

class ImagePickerSuccess extends ImagePickerState {
  final String imagePath;
  ImagePickerSuccess(this.imagePath);
}

class ImagePickerError extends ImagePickerState {
  final String message;
  ImagePickerError(this.message);
}