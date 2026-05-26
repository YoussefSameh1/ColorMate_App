import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/object&color_detection/data/model/user_detection_history_item.dart';
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

class _ObjectAndColorDetectionBodyState extends State<ObjectAndColorDetectionBody> {
  List<UserDetectionHistoryItem> _historyItems = const [];
  bool _isHistoryLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory(silent: true);
    });
  }

  Future<void> _loadHistory({required bool silent}) async {
    if (!mounted) return;

    setState(() {
      _isHistoryLoading = true;
    });

    final cubit = context.read<ImagePickerCubit>();
    final items = await cubit.fetchUserDetectionsHistory();

    if (!mounted) return;

    setState(() {
      _historyItems = items;
      _isHistoryLoading = false;
    });
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
        final successState = state is ImagePickerSuccess ? state : null;
        final imagePath = successState?.imagePath;
        final isLoading = state is ImagePickerLoading;
        final isDetecting = successState?.isDetecting ?? false;
        final historyItems =
            successState?.history.isNotEmpty == true
                ? successState!.history
                : _historyItems;
        final isLoadingHistory =
            successState?.isLoadingHistory ?? _isHistoryLoading;
        final hasDetections =
            (successState?.detectedObjects.isNotEmpty ?? false);
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
                          historyCount: historyItems.length,
                          isLoadingHistory: isLoadingHistory,
                          onRefresh: () => _loadHistory(silent: false),
                          onOpenAll: () => _openHistory(context, historyItems),
                        ),
                      ),
                      if (historyItems.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                          child: _SectionCard(
                            title: 'Recent detections',
                            subtitle: 'Tap a card to reopen the image and bounding boxes.',
                            child: _HistoryPreviewRow(
                              historyItems: historyItems,
                              onTap: (item) => _openSingleHistoryItem(context, item),
                            ),
                          ),
                        )
                      else if (!isLoadingHistory)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                          child: _SectionCard(
                            title: 'Recent detections',
                            subtitle: 'Your saved history will appear here automatically.',
                            child: _EmptyHistoryState(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                        child: _SectionCard(
                          title: 'Upload image',
                          subtitle: 'Choose a new photo, then run object detection.',
                          child: ImageUploadSection(
                            isLoading: isLoading,
                            imagePath: imagePath,
                            onChoosePhoto:
                                () => showImagePicker(
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
                            onObjectTap:
                                successState == null
                                    ? null
                                    : (object) {
                                      context.read<ImagePickerCubit>().onDetectedObjectTapped(
                                        object,
                                      );
                                    },
                            onImageTap:
                                successState == null
                                    ? null
                                    : (point) {
                                      context.read<ImagePickerCubit>().onImageTapped(point);
                                    },
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
                                    context.read<ImagePickerCubit>().detectObjects();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hasDetections || selectedObject != null || successState?.selectedObjectDominantColor != null)
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
                                if (successState?.isExtractingDominantColor == true ||
                                    successState?.selectedObjectDominantColor != null) ...[
                                  const SizedBox(height: 10),
                                  _InfoLine(
                                    icon: Icons.color_lens_rounded,
                                    text:
                                        successState?.isExtractingDominantColor ?? false
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

  void _showHistorySheet(
    BuildContext context,
    List<UserDetectionHistoryItem> history, {
    required Future<void> Function(UserDetectionHistoryItem item) onTap,
  }) {
    final orderedHistory = List<UserDetectionHistoryItem>.of(history);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.65,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: _HistorySheetHeader(historyCount: orderedHistory.length),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child:
                          orderedHistory.isEmpty
                              ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 88,
                                        height: 88,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: const Icon(
                                          Icons.folder_open_outlined,
                                          size: 42,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No history yet',
                                        style: AppTextStyles.medium16().copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Your previous detections will appear here after you start using the feature.',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.regular16().copyWith(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : ListView.separated(
                                controller: scrollController,
                                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                                itemCount: orderedHistory.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = orderedHistory[index];
                                  final thumbnailBytes = item.decodeImageBytes();

                                  return Material(
                                    color: AppColors.secondary.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () async {
                                        Navigator.of(sheetContext).pop();
                                        await onTap(item);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Container(
                                                width: 78,
                                                height: 78,
                                                color: Colors.white,
                                                child:
                                                    thumbnailBytes == null
                                                        ? const Icon(
                                                          Icons.image_not_supported_outlined,
                                                          color: Colors.black45,
                                                        )
                                                        : Image.memory(
                                                          thumbnailBytes,
                                                          fit: BoxFit.cover,
                                                        ),
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Detection #${index + 1}',
                                                    style: AppTextStyles.medium16().copyWith(
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${item.totalObjects} detected objects',
                                                    style: AppTextStyles.regular16().copyWith(
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      _HistoryChip(
                                                        label: 'Open',
                                                        backgroundColor: AppColors.white,
                                                        textColor: AppColors.primary,
                                                      ),
                                                      if (item.objDetectionWithImageId != null) ...[
                                                        const SizedBox(width: 8),
                                                        _HistoryChip(
                                                          label: 'ID ${item.objDetectionWithImageId}',
                                                          backgroundColor: AppColors.primary.withOpacity(0.08),
                                                          textColor: AppColors.primary,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                              color: Colors.black45,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openHistory(BuildContext context, List<UserDetectionHistoryItem> history) {
    _showHistorySheet(
      context,
      history,
      onTap: (item) async {
        await context.read<ImagePickerCubit>().openHistoryItem(item);
      },
    );
  }

  Future<void> _openSingleHistoryItem(
    BuildContext context,
    UserDetectionHistoryItem item,
  ) async {
    await context.read<ImagePickerCubit>().openHistoryItem(item);
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.child,
  });

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
            style: AppTextStyles.medium16().copyWith(
              color: AppColors.primary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextStyles.regular10().copyWith(
                color: Colors.black54,
              ),
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
  const _HeroSection({
    required this.historyCount,
    required this.isLoadingHistory,
    required this.onRefresh,
    required this.onOpenAll,
  });

  final int historyCount;
  final bool isLoadingHistory;
  final VoidCallback onRefresh;
  final VoidCallback onOpenAll;

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
              _HeroChip(label: '$historyCount history items', icon: Icons.history_rounded),
              _HeroChip(label: 'Upload → Detect', icon: Icons.upload_rounded),
              _HeroChip(label: 'Tap to inspect', icon: Icons.touch_app_rounded),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextButton(
                    onPressed: isLoadingHistory ? null : onRefresh,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.white.withOpacity(0.18),
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      isLoadingHistory ? 'Refreshing...' : 'Refresh history',
                      style: AppTextStyles.medium10().copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextButton(
                    onPressed: isLoadingHistory ? null : onOpenAll,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      'Open history',
                      style: AppTextStyles.medium10().copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
            style: AppTextStyles.medium8().copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No saved detections yet. The history section will fill up after your first scans.',
              style: AppTextStyles.regular16().copyWith(
                color: Colors.black54,
              ),
            ),
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
              style: AppTextStyles.regular16().copyWith(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryPreviewRow extends StatelessWidget {
  const _HistoryPreviewRow({
    required this.historyItems,
    required this.onTap,
  });

  final List<UserDetectionHistoryItem> historyItems;
  final ValueChanged<UserDetectionHistoryItem> onTap;

  @override
  Widget build(BuildContext context) {
    final previewItems = historyItems.take(3).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent detections',
              style: AppTextStyles.medium16().copyWith(
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              '${historyItems.length} total',
              style: AppTextStyles.regular10().copyWith(
                color: Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: previewItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = previewItems[index];
              final thumbnailBytes = item.decodeImageBytes();

              return GestureDetector(
                onTap: () => onTap(item),
                child: Container(
                  width: 156,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child:
                                thumbnailBytes == null
                                    ? Container(
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.image_outlined,
                                        color: Colors.black45,
                                      ),
                                    )
                                    : Image.memory(
                                      thumbnailBytes,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detection #${index + 1}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.medium16().copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.totalObjects} objects',
                              style: AppTextStyles.regular10().copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ],
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
    );
  }
}

class _HistorySheetHeader extends StatelessWidget {
  const _HistorySheetHeader({required this.historyCount});

  final int historyCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.history_rounded,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'History',
                style: AppTextStyles.medium16().copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$historyCount saved detections',
                style: AppTextStyles.regular10().copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.medium8().copyWith(color: textColor),
      ),
    );
  }
}
