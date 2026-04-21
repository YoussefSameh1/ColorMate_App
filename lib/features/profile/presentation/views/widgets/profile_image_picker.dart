import 'dart:io';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  static const String _baseUrl = 'http://colormate.runasp.net';

  final String? imagePath;
  final String? imageUrl;
  final bool isLoading;
  final VoidCallback onTap;

  const ProfileImagePicker({
    super.key,
    this.imagePath,
    this.imageUrl,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localImageProvider = _getLocalImageProvider();
    final resolvedImageUrl =
        (imagePath == null || imagePath!.isEmpty) &&
                imageUrl != null &&
                imageUrl!.isNotEmpty
            ? _resolveImageUrl(imageUrl!)
            : null;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: localImageProvider,
              child:
                  isLoading
                      ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                      : localImageProvider != null
                      ? null
                      : resolvedImageUrl != null
                      ? ClipOval(
                        child: Image.network(
                          resolvedImageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 60);
                          },
                        ),
                      )
                      : const Icon(Icons.person, size: 60),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: isLoading ? null : onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),

        if (imagePath != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }

  ImageProvider? _getLocalImageProvider() {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return FileImage(File(imagePath!));
    }

    return null;
  }

  String _resolveImageUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (trimmed.startsWith('/')) {
      return '$_baseUrl$trimmed';
    }

    return '$_baseUrl/$trimmed';
  }
}
