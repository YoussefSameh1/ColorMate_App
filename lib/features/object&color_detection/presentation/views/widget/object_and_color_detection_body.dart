import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_upload_section.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        final imagePath = state is ImagePickerSuccess ? state.imagePath : null;
        final isLoading = state is ImagePickerLoading;

        return Column(
          children: [
            ImageUploadSection(
              isLoading: isLoading,
              imagePath: imagePath,
              onChoosePhoto: () => showImagePicker(context),
            ),
            const SizedBox(height: 20),
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: PrimaryShadowButton(
                  text: 'Start Detection',
                  onPressed: () {
                    GoRouter.of(context).push(Routes.imageCorrectionView);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
