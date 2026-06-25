import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_state.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/image_upload_section.dart';
import 'package:colormate_app/features/object&color_detection/presentation/views/widget/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ObjectAndColorDetectionBody extends StatefulWidget {
  const ObjectAndColorDetectionBody({super.key});

  @override
  State<ObjectAndColorDetectionBody> createState() =>
      _ObjectAndColorDetectionBodyState();
}

class _ObjectAndColorDetectionBodyState
    extends State<ObjectAndColorDetectionBody> {
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
        final showObjectsList =
            (successState?.detectedObjects.length ?? 0) >= 5;
        final selectedObject =
            successState == null
                ? null
                : context.read<ImagePickerCubit>().getSelectedDetectedObject();

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                color: const Color(0xFFF8F3EA),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomAppBar(title: 'Objects & Colors'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                        child: _HeroSection(
                          onScanInfo:
                              'Upload a photo, run detection, and inspect results.',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                        child: _SectionCard(
                          title: 'Upload image',
                          subtitle:
                              'Choose a new photo, then run object detection.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ImageUploadSection(
                                isLoading: isLoading,
                                imagePath: imagePath,
                                onChoosePhoto:
                                    () => showImagePicker(
                                      context: context,
                                      onCameraSelected: () {
                                        context
                                            .read<ImagePickerCubit>()
                                            .pickFromCamera();
                                      },
                                      onGallerySelected: () {
                                        context
                                            .read<ImagePickerCubit>()
                                            .pickFromGallery();
                                      },
                                    ),
                                detectedObjects:
                                    successState?.detectedObjects ?? const [],
                                originalImageSize:
                                    successState?.originalImageSize,
                                selectedObjectId:
                                    successState?.selectedObjectId,
                                showLabels: !showObjectsList,
                                imageFit: BoxFit.contain,
                                onObjectTap:
                                    successState == null
                                        ? null
                                        : (object) {
                                          context
                                              .read<ImagePickerCubit>()
                                              .onDetectedObjectTapped(object);
                                        },
                                onImageTap:
                                    successState == null
                                        ? null
                                        : (point) {
                                          context
                                              .read<ImagePickerCubit>()
                                              .onImageTapped(point);
                                        },
                              ),
                              if (showObjectsList) ...[
                                const SizedBox(height: 6),
                                _DetectedObjectsListCard(
                                  objects: successState!.detectedObjects,
                                  selectedObjectId:
                                      successState.selectedObjectId,
                                  onObjectSelected: (object) {
                                    context
                                        .read<ImagePickerCubit>()
                                        .onDetectedObjectTapped(object);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (imagePath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: PrimaryShadowButton(
                                  text: 'Start Detection',
                                  isLoading: isDetecting,
                                  onPressed: () {
                                    context
                                        .read<ImagePickerCubit>()
                                        .detectObjects();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hasDetections ||
                          selectedObject != null ||
                          successState?.selectedObjectDominantColor != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                          child: _SectionCard(
                            title: 'Detection output',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (hasDetections)
                                  _InfoLine(
                                    icon: Icons.auto_awesome_rounded,
                                    text:
                                        'Detected objects: ${successState!.detectedObjects.length}',
                                    accent: AppColors.primary,
                                  ),
                                if (selectedObject != null) ...[
                                  const SizedBox(height: 10),
                                  _InfoLine(
                                    icon: Icons.touch_app_rounded,
                                    text:
                                        'Selected: ${selectedObject.className} (${(selectedObject.confidence * 100).toStringAsFixed(1)}%)',
                                    accent: AppColors.success,
                                  ),
                                ],
                                if (successState?.isExtractingDominantColor ==
                                        true ||
                                    successState?.selectedObjectDominantColor !=
                                        null) ...[
                                  const SizedBox(height: 10),
                                  _InfoLine(
                                    icon: Icons.color_lens_rounded,
                                    text:
                                        successState?.isExtractingDominantColor ??
                                                false
                                            ? 'Dominant color: extracting...'
                                            : 'Dominant color: ${_toColorName(successState?.selectedObjectDominantColor)}',
                                    accent: AppColors.primary,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, this.subtitle, required this.child});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.medium16().copyWith(color: AppColors.primary),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextStyles.regular10().copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 14),
          ] else
            const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.onScanInfo});

  final String onScanInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A4E22), Color(0xFFB98549)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.auto_graph_rounded,
                  color: AppColors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objects & Colors',
                      style: AppTextStyles.medium16().copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Detection lab for upload, backend analysis, and color extraction.',
                      style: AppTextStyles.regular10().copyWith(
                        color: AppColors.white.withOpacity(0.88),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(label: 'Upload → Detect', icon: Icons.upload_rounded),
              _HeroChip(label: 'Tap to inspect', icon: Icons.touch_app_rounded),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            onScanInfo,
            style: AppTextStyles.regular10().copyWith(
              color: AppColors.white.withOpacity(0.88),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.medium8().copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
    required this.accent,
  });

  final IconData icon;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.regular16().copyWith(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectedObjectsListCard extends StatelessWidget {
  const _DetectedObjectsListCard({
    required this.objects,
    required this.selectedObjectId,
    required this.onObjectSelected,
  });

  final List<DetectedObject> objects;
  final int? selectedObjectId;
  final ValueChanged<DetectedObject> onObjectSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.view_list_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detected objects',
                      style: AppTextStyles.medium16().copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap any item to light up its box on the image.',
                      style: AppTextStyles.regular10().copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 272,
            child: ListView.separated(
              itemCount: objects.length,
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final object = objects[index];
                final isSelected = object.objectId == selectedObjectId;

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onObjectSelected(object),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.success.withOpacity(0.12)
                              : AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.success.withOpacity(0.55)
                                : AppColors.primary.withOpacity(0.08),
                        width: isSelected ? 1.6 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            isSelected ? 0.06 : 0.03,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  isSelected
                                      ? [AppColors.success, AppColors.primary]
                                      : [
                                        AppColors.primary.withOpacity(0.9),
                                        AppColors.primary.withOpacity(0.65),
                                      ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTextStyles.medium16().copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                object.className,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.medium16().copyWith(
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Confidence ${(object.confidence * 100).toStringAsFixed(1)}%',
                                style: AppTextStyles.regular10().copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.success.withOpacity(0.16)
                                    : AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Icon(
                            isSelected
                                ? Icons.check_rounded
                                : Icons.touch_app_rounded,
                            size: 16,
                            color:
                                isSelected
                                    ? AppColors.success
                                    : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
