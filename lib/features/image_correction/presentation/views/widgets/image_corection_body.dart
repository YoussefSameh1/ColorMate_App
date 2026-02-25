import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/image_correction/presentation/view_model/image_correction_view_model.dart';
import 'package:colormate_app/features/image_correction/presentation/views/widgets/correction_actions_section.dart';
import 'package:colormate_app/features/image_correction/presentation/views/widgets/correction_filter_card.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_upload_section.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCorrectionBody extends StatefulWidget {
  const ImageCorrectionBody({super.key});

  @override
  State<ImageCorrectionBody> createState() => _ImageCorrectionBodyState();
}

class _ImageCorrectionBodyState extends State<ImageCorrectionBody> {
  late final ImageCorrectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ImageCorrectionViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

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

        return AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.only(top: 0, bottom: 28),
              children: [
                 CustomAppBar(title: 'Image Correction'),
                ImageUploadSection(
                  isLoading: isLoading,
                  imagePath: imagePath,
                  onChoosePhoto: () => showImagePicker(context),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'Correction Filters',
                    style: AppTextStyles.regular18().copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 116,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: _viewModel.filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final filter = _viewModel.filters[index];
                      final isSelected =
                          index == _viewModel.selectedFilterIndex;
                      return CorrectionFilterCard(
                        title: filter.title,
                        imageAsset: filter.imageAsset,
                        isSelected: isSelected,
                        onTap: () => _viewModel.selectFilter(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 34),
                CorrectionActionsSection(viewModel: _viewModel),
              ],
            );
          },
        );
      },
    );
  }
}
