import 'package:colormate_app/features/image_correction/presentation/view_model/image_correction_view_model.dart';
import 'package:colormate_app/features/image_correction/presentation/views/widgets/correction_action_button.dart';
import 'package:colormate_app/features/object&color_detection/presentation/cubit/image_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CorrectionActionsSection extends StatelessWidget {
  const CorrectionActionsSection({super.key, required this.viewModel});

  final ImageCorrectionViewModel viewModel;

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
              onTap: () {
                viewModel.resetSelection();
                context.read<ImagePickerCubit>().reset();
              },
            ),
          ),
          const SizedBox(width: 12),
          CorrectionActionButton(
            text: 'Download',
            icon: Icons.file_download_outlined,
            isPrimary: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
