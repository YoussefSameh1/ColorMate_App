import 'package:colormate_app/core/widget/bottom_sheet/custom_image_sourcebottom_sheet.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showImagePicker(BuildContext context) {
  final cubit = context.read<ImagePickerCubit>();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (_) => CustomImageSourceBottomSheet(
          onCameraSelected: cubit.pickFromCamera,
          onGallerySelected: cubit.pickFromGallery,
        ),
  );
}
