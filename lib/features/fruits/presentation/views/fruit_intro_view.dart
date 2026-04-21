import 'package:colormate_app/core/services/image_picker_service.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/fruit_intro_view_body.dart';
import 'package:colormate_app/features/matching/presentation/cubit/upload_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FruitIntroView extends StatelessWidget {
  const FruitIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadImageCubit(ImagePickerService()),
      child: Scaffold(body: const FruitIntroViewBody()),
    );
  }
}
