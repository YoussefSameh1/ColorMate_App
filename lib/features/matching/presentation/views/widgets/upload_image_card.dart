import 'package:colormate_app/features/matching/presentation/cubit/upload_image_cubit.dart';
import 'package:colormate_app/features/matching/presentation/cubit/upload_image_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_upload_section.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadImageCard extends StatelessWidget {
  const UploadImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadImageCubit, UploadImageState>(
      listener: (context, state) {
        if (state is UploadImageError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        String? imagePath;
        bool isLoading = false;

        if (state is UploadImageLoading) {
          isLoading = true;
        } else if (state is UploadImageSuccess) {
          imagePath = state.imagePath;
        }

        return ImageUploadSection(
          isLoading: isLoading,
          imagePath: imagePath,
          onChoosePhoto: () {
            final cubit = context.read<UploadImageCubit>();

            showImagePicker(
              context: context,
              onCameraSelected: cubit.pickFromCamera,
              onGallerySelected: cubit.pickFromGallery,
            );
          },
        );
      },
    );
  }
}
