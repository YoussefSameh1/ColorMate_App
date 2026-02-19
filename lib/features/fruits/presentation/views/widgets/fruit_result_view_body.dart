import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/image_card.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FruitResultViewBody extends StatelessWidget {
  const FruitResultViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(title: 'Fruits Scanner'),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            children: [
              ImageCard(),
              SizedBox(height: 20.h),
              ResultCard(),
              ],
          ),
        ),
      ],
    );
  }
}
