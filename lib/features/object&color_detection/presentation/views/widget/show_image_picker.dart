import 'package:colormate_app/core/widget/bottom_sheet/custom_image_sourcebottom_sheet.dart';
import 'package:flutter/material.dart';

void showImagePicker({
  required BuildContext context,
  required VoidCallback onCameraSelected,
  required VoidCallback onGallerySelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (_) => CustomImageSourceBottomSheet(
          onCameraSelected: onCameraSelected,
          onGallerySelected: onGallerySelected,
        ),
  );
}
