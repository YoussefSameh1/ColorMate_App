import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/matching/presentation/views/widgets/upload_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchingViewBody extends StatelessWidget {
  const MatchingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(title: 'Color Matching Assistant'),
        SizedBox(height: 16.h),
        UploadImageCard(),
      ],
    );
  }
}
