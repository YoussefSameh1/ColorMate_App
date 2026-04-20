import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_upload_section.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ObjectAndColorDetectionBody extends StatelessWidget {
  const ObjectAndColorDetectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImagePickerCubit, ImagePickerState>(
      listener: (context, state) {
        if (state is ImagePickerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final successState = state is ImagePickerSuccess ? state : null;
        final imagePath = successState?.imagePath;
        final isLoading = state is ImagePickerLoading;
        final isDetecting = successState?.isDetecting ?? false;
        final hasDetections =
            (successState?.detectedObjects.isNotEmpty ?? false);
        final selectedObject = successState == null
            ? null
            : context.read<ImagePickerCubit>().getSelectedDetectedObject();

        return Column(
          children: [
            CustomAppBar(title: 'Objects & Colors'),
            ImageUploadSection(
              isLoading: isLoading,
              imagePath: imagePath,
              onChoosePhoto: () => showImagePicker(
                context: context,
                onCameraSelected: () {
                  context.read<ImagePickerCubit>().pickFromCamera();
                },
                onGallerySelected: () {
                  context.read<ImagePickerCubit>().pickFromGallery();
                },
              ),
              detectedObjects: successState?.detectedObjects ?? const [],
              originalImageSize: successState?.originalImageSize,
              selectedObjectId: successState?.selectedObjectId,
              imageFit: BoxFit.contain,
              onObjectTap: successState == null
                  ? null
                  : (object) {
                      context.read<ImagePickerCubit>().onDetectedObjectTapped(
                        object,
                      );
                    },
              onImageTap: successState == null
                  ? null
                  : (point) {
                      context.read<ImagePickerCubit>().onImageTapped(point);
                    },
            ),
            const SizedBox(height: 20),
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: PrimaryShadowButton(
                  text: 'Start Detection',
                  isLoading: isDetecting,
                  onPressed: () {
                    context
                        .read<ImagePickerCubit>()
                        .detectObjectsWithMockData();
                  },
                ),
              ),
            if (hasDetections)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Detected objects: ${successState!.detectedObjects.length}',
                        style: AppTextStyles.medium16().copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (selectedObject != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Selected: ${selectedObject.className} (${(selectedObject.confidence * 100).toStringAsFixed(1)}%)',
                        style: AppTextStyles.regular16().copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (successState?.isExtractingDominantColor == true ||
                successState?.selectedObjectDominantColor != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    successState?.isExtractingDominantColor ?? false
                        ? 'Dominant color: extracting...'
                        : 'Dominant color: ${_toColorName(successState?.selectedObjectDominantColor)}',
                    style: AppTextStyles.regular16().copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _toColorName(Color? color) {
    if (color == null) {
      return '--';
    }

    final hsv = HSVColor.fromColor(color);
    final h = hsv.hue;
    final s = hsv.saturation;
    final v = hsv.value;

    if (v < 0.15) return 'black';
    if (s < 0.08 && v > 0.92) return 'white';

    if (s < 0.12) {
      if (v < 0.3) return 'charcoal';
      if (v < 0.75) return 'gray';
      return 'beige';
    }

    if (h >= 15 && h < 50) {
      if (v < 0.58) return 'brown';
      if (s < 0.42 && v > 0.7) return 'beige';
      if (v < 0.75) return 'tan';
      return 'orange';
    }

    if (h >= 345 || h < 15) return 'red';
    if (h >= 50 && h < 70) return 'yellow';
    if (h >= 70 && h < 160) return 'green';
    if (h >= 160 && h < 200) return 'cyan';
    if (h >= 200 && h < 255) return 'blue';
    if (h >= 255 && h < 300) return 'purple';
    if (h >= 300 && h < 345) return 'pink';

    return 'unknown';
  }
}
