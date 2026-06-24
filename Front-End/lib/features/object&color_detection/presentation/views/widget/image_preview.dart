import 'dart:io';

import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/theme/text_style.dart';
import 'package:colormate_app/features/object&color_detection/data/model/detected_object.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.imagePath,
    required this.onEdit,
    this.detectedObjects = const [],
    this.originalImageSize,
    this.selectedObjectId,
    this.onObjectTap,
    this.onImageTap,
    this.showLabels = true,
    this.imageFit = BoxFit.cover,
  });

  final String imagePath;
  final VoidCallback onEdit;
  final List<DetectedObject> detectedObjects;
  final Size? originalImageSize;
  final int? selectedObjectId;
  final ValueChanged<DetectedObject>? onObjectTap;
  final ValueChanged<Offset>? onImageTap;
  final bool showLabels;
  final BoxFit imageFit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown:
                    onImageTap == null || originalImageSize == null
                        ? null
                        : (details) {
                          final mappedPoint = _mapTapToImageSpace(
                            details.localPosition,
                            constraints.biggest,
                          );
                          if (mappedPoint != null) {
                            onImageTap!(mappedPoint);
                          }
                        },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.file(
                      File(imagePath),
                      width: double.infinity,
                      height: double.infinity,
                      fit: imageFit,
                    ),
                    if (detectedObjects.isNotEmpty && originalImageSize != null)
                      ..._buildObjectBoxes(constraints.biggest),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildObjectBoxes(Size containerSize) {
    if (originalImageSize == null) {
      return const [];
    }

    final imageWidth = originalImageSize!.width;
    final imageHeight = originalImageSize!.height;
    if (imageWidth <= 0 || imageHeight <= 0) {
      return const [];
    }

    final scale =
        (containerSize.width / imageWidth) <
                (containerSize.height / imageHeight)
            ? (containerSize.width / imageWidth)
            : (containerSize.height / imageHeight);
    final displayedWidth = imageWidth * scale;
    final displayedHeight = imageHeight * scale;
    final offsetX = (containerSize.width - displayedWidth) / 2;
    final offsetY = (containerSize.height - displayedHeight) / 2;

    return detectedObjects.expand((detectedObject) {
      final rect = detectedObject.toRect();
      final left = offsetX + (rect.left * scale);
      final top = offsetY + (rect.top * scale);
      final width =
          (rect.width * scale).clamp(0, containerSize.width).toDouble();
      final height =
          (rect.height * scale).clamp(0, containerSize.height).toDouble();
      final isSelected = selectedObjectId == detectedObject.objectId;

      final safeTopLabel =
          (top - 28).clamp(0, containerSize.height - 24).toDouble();
      final safeLeftLabel = left.clamp(0, containerSize.width - 120).toDouble();

      return [
        Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    isSelected
                        ? AppColors.success
                        : AppColors.white.withOpacity(0.75),
                width: isSelected ? 3.5 : 2,
              ),
              borderRadius: BorderRadius.circular(6),
              color: Colors.transparent,
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.26),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                      : null,
            ),
          ),
        ),
        if (showLabels || isSelected)
          Positioned(
            left: safeLeftLabel,
            top: safeTopLabel,
            child: GestureDetector(
              onTap:
                  onObjectTap != null
                      ? () => onObjectTap!(detectedObject)
                      : null,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 120),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.success : AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isSelected
                              ? AppColors.success.withOpacity(0.26)
                              : AppColors.primary.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${detectedObject.className} ${(detectedObject.confidence * 100).toStringAsFixed(1)}%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.medium16().copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
      ];
    }).toList();
  }

  Offset? _mapTapToImageSpace(Offset localPosition, Size containerSize) {
    if (originalImageSize == null) {
      return null;
    }

    final imageWidth = originalImageSize!.width;
    final imageHeight = originalImageSize!.height;
    if (imageWidth <= 0 || imageHeight <= 0) {
      return null;
    }

    final scale =
        (containerSize.width / imageWidth) <
                (containerSize.height / imageHeight)
            ? (containerSize.width / imageWidth)
            : (containerSize.height / imageHeight);

    final displayedWidth = imageWidth * scale;
    final displayedHeight = imageHeight * scale;
    final offsetX = (containerSize.width - displayedWidth) / 2;
    final offsetY = (containerSize.height - displayedHeight) / 2;

    final mappedX = ((localPosition.dx - offsetX) / scale).clamp(
      0,
      imageWidth - 1,
    );
    final mappedY = ((localPosition.dy - offsetY) / scale).clamp(
      0,
      imageHeight - 1,
    );

    return Offset(mappedX.toDouble(), mappedY.toDouble());
  }
}
