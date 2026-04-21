import 'package:colormate_app/core/utils/assets_data.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/test/presentation/views/widgets/start_test_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestIntroViewBody extends StatelessWidget {
  const TestIntroViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(title: 'Test'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Icon(
                Icons.remove_red_eye_outlined,
                size: 100,
                color: kPrimaryColor,
              ),
              Text('Ishihara Test', style: Styles.titleStyle),
              SizedBox(height: 20.h),
              Text(
                'Spot hidden numbers in colored dots to check how well you see colors',
                style: Styles.descriptionStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Image.asset(AssetsData.test, height: 250.h, width: 250.w),
              SizedBox(height: 50.h),
              const StartTestButton(),
            ],
          ),
        ),
      ],
    );
  }
}
