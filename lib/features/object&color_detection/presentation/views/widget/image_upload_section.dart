import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';
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
    this.detectedObjects = const [],
    this.originalImageSize,
    this.selectedObjectId,
    this.onObjectTap,
    this.onImageTap,
    this.showLabels = true,
    this.imageFit = BoxFit.cover,
  });

  final bool isLoading;
  final String? imagePath;
  final VoidCallback onChoosePhoto;
  final List<DetectedObject> detectedObjects;
  final Size? originalImageSize;
  final int? selectedObjectId;
  final ValueChanged<DetectedObject>? onObjectTap;
  final ValueChanged<Offset>? onImageTap;
  final bool showLabels;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final previewHeight =
        imagePath != null ? (screenHeight * 0.52).clamp(420.0, 560.0) : 270.h;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      child: DottedBorder(
        color: AppColors.primary,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: previewHeight,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : imagePath != null
                  ? ImagePreview(
                    imagePath: imagePath!,
                    onEdit: onChoosePhoto,
                    detectedObjects: detectedObjects,
                    originalImageSize: originalImageSize,
                    selectedObjectId: selectedObjectId,
                    onObjectTap: onObjectTap,
                    onImageTap: onImageTap,
                    showLabels: showLabels,
                    imageFit: imageFit,
                  )
                  : UploadPlaceholder(onChoosePhoto: onChoosePhoto),
        ),
      ),
    );
  }
}
