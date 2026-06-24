import 'package:colormate_app/features/image_correction/presentation/views/widgets/correction_action_button.dart';
import 'package:flutter/material.dart';

class CorrectionActionsSection extends StatelessWidget {
  const CorrectionActionsSection({
    super.key,
    required this.onReset,
    required this.onDownload,
    required this.canDownload,
  });

  final VoidCallback onReset;
  final VoidCallback onDownload;
  final bool canDownload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: CorrectionActionButton(
              text: 'Reset',
              icon: Icons.delete_outline_rounded,
              isPrimary: false,
              onTap: onReset,
            ),
          ),
          const SizedBox(width: 12),
          CorrectionActionButton(
            text: canDownload ? 'Download' : 'No Output',
            icon: Icons.file_download_outlined,
            isPrimary: true,
            onTap: onDownload,
          ),
        ],
      ),
    );
  }
}
