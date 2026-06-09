// scan_button.dart
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/matching/presentation/cubit/upload_image_cubit.dart';
import 'package:colormate_app/features/matching/presentation/cubit/upload_image_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final cubit = context.read<UploadImageCubit>();

        showImagePicker(
          context: context,
          onCameraSelected: () async {
            await cubit.pickFromCamera();
            _navigateIfSuccess(context);
          },
          onGallerySelected: () async {
            await cubit.pickFromGallery();
            _navigateIfSuccess(context);
          },
        );
      },
      icon: Icon(
        Icons.cloud_upload_outlined,
        color: Colors.white,
        size: 22.r,  // responsive icon size
      ),
      label: Text(
        'Scan fruit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,  // was 24.sp — more balanced across screen sizes
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),  // responsive padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        elevation: 2,
      ),
    );
  }

  void _navigateIfSuccess(BuildContext context) {
    final state = context.read<UploadImageCubit>().state;

    if (state is UploadImageSuccess) {
      GoRouter.of(context).go(Routes.fruitResultView, extra: state.imagePath);
    }
  }
}