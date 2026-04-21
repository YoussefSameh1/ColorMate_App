abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class UploadImageSuccess extends UploadImageState {
  final String imagePath;

  UploadImageSuccess(this.imagePath);
}

class UploadImageError extends UploadImageState {
  final String message;

  UploadImageError(this.message);
}