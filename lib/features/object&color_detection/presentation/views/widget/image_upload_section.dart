import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_preview.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/upload_placeholder.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageUploadSection extends StatelessWidget {
  const ImageUploadSection({
    super.key,
    required this.isLoading,
    required this.imagePath,
    required this.onChoosePhoto,
  });

  final bool isLoading;
  final String? imagePath;
  final VoidCallback onChoosePhoto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      child: DottedBorder(
        color: AppColors.primary,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: 320.h,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : imagePath != null
                  ? ImagePreview(imagePath: imagePath!, onEdit: onChoosePhoto)
                  : UploadPlaceholder(onChoosePhoto: onChoosePhoto),
        ),
      ),
    );
  }
}
