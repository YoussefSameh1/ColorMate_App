import 'package:image_picker/image_picker.dart';


class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();
  Future<String?> pickImageFromGallery({
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      return image?.path;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: ${e.toString()}');
    }
  }


  Future<String?> pickImageFromCamera({
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      return image?.path;
    } catch (e) {
      throw Exception('Failed to take photo from camera: ${e.toString()}');
    }
  }

}
