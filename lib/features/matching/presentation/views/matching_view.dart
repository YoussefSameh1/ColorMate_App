import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/matching/presentation/cubit/upload_image_cubit.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/matching_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchingView extends StatelessWidget {
  const MatchingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadImageCubit(ImagePickerService()),
      child: Scaffold(body: const MatchingViewBody()),
    );
  }
}
