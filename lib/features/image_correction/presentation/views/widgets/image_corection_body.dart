import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';
import 'package:colormate_app/features/image_correction/presentation/view_model/cubit/image_correction_cubit.dart';
import 'package:colormate_app/features/image_correction/presentation/view_model/cubit/image_correction_state.dart';
import 'package:colormate_app/features/image_correction/presentation/views/widgets/correction_actions_section.dart';
import 'package:colormate_app/features/image_correction/presentation/views/widgets/correction_filter_card.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_upload_section.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCorrectionBody extends StatelessWidget {
  const ImageCorrectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ImagePickerCubit, ImagePickerState>(
          listener: (context, state) {
            if (state is ImagePickerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is ImagePickerSuccess) {
              context.read<ImageCorrectionCubit>().applySelectedFilter(
                imagePath: state.imagePath,
              );
            }
          },
        ),
        BlocListener<ImageCorrectionCubit, ImageCorrectionState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<ImageCorrectionCubit>().clearTransientMessages();
            } else if (state.lastSavedPath != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Saved to: ${state.lastSavedPath}'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<ImageCorrectionCubit>().clearTransientMessages();
            }
          },
        ),
      ],
      child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
        builder: (context, pickerState) {
          final sourceImagePath =
              pickerState is ImagePickerSuccess ? pickerState.imagePath : null;
          final isPickerLoading = pickerState is ImagePickerLoading;

          return BlocBuilder<ImageCorrectionCubit, ImageCorrectionState>(
            builder: (context, correctionState) {
              final displayedImagePath =
                  correctionState.processedImagePath ?? sourceImagePath;
              final isImageLoading =
                  isPickerLoading || correctionState.isProcessing;

              return ListView(
                padding: const EdgeInsets.only(top: 0, bottom: 28),
                children: [
                  ImageUploadSection(
                    isLoading: isImageLoading,
                    imagePath: displayedImagePath,
                    onChoosePhoto: () => showImagePicker(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Mode',
                      style: AppTextStyles.regular18().copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        ChoiceChip(
                          label: const Text('Simulation'),
                          selected: correctionState.mode == CvdMode.simulation,
                          onSelected: (_) {
                            context.read<ImageCorrectionCubit>().changeMode(
                              mode: CvdMode.simulation,
                              imagePath: sourceImagePath,
                            );
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Correction'),
                          selected: correctionState.mode == CvdMode.correction,
                          onSelected: (_) {
                            context.read<ImageCorrectionCubit>().changeMode(
                              mode: CvdMode.correction,
                              imagePath: sourceImagePath,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Choose Color Blindness Type',
                      style: AppTextStyles.regular18().copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (correctionState.isLoadingFilters)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    SizedBox(
                      height: 116,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: correctionState.filterOptions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final filter = correctionState.filterOptions[index];
                          final isSelected =
                              index == correctionState.selectedFilterIndex;
                          return CorrectionFilterCard(
                            title: filter.title,
                            imageAsset:
                                filter.previewAsset ??
                                'assets/images/object_detection_sample.png',
                            isSelected: isSelected,
                            onTap: () {
                              context.read<ImageCorrectionCubit>().selectFilter(
                                index: index,
                                imagePath: sourceImagePath,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 34),
                  CorrectionActionsSection(
                    canDownload: correctionState.hasProcessedImage,
                    onReset: () {
                      context.read<ImageCorrectionCubit>().reset();
                      context.read<ImagePickerCubit>().reset();
                    },
                    onDownload: () {
                      context.read<ImageCorrectionCubit>().saveProcessedImage(
                        originalImagePath: sourceImagePath,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
