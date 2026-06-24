// test_intro_view_body.dart
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/assets_data.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/test/presentation/views/widgets/start_test_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TestIntroViewBody extends StatelessWidget {
  const TestIntroViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(   // prevents overflow on short screens
      child: Column(
        children: [
          CustomAppBar(
            title: 'Test',
            onBackPressed: () => context.go(Routes.homeView),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 24.h),
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 80.r,            // was raw 100 — now scales with screen
                  color: kPrimaryColor,
                ),
                SizedBox(height: 8.h),
                Text('Ishihara Test', style: Styles.titleStyle),
                SizedBox(height: 16.h),
                Text(
                  'Spot hidden numbers in colored dots to check how well you see colors',
                  style: Styles.descriptionStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Image.asset(
                  AssetsData.test,
                  height: screenHeight * 0.28,   // proportional to screen height
                  width: screenHeight * 0.28,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 36.h),
                const StartTestButton(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}