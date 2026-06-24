// test_result_view_body.dart
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/test/presentation/cubit/test_cubit.dart';
import 'package:colormate_app/features/test/presentation/views/widgets/color_blindness_type_section.dart';
import 'package:colormate_app/features/test/presentation/views/widgets/info_about_color_blindness_type_section.dart';
import 'package:colormate_app/features/test/presentation/views/widgets/test_result_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TestResultViewBody extends StatelessWidget {
  const TestResultViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final result = context.read<TestCubit>().lastResult;

    if (result == null) {
      return const Center(child: Text('No result found.'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomAppBar(title: 'Test Result', isBackButtonVisible: false),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                ColorBlindnessTypeSection(diagnosis: result.diagnosis),
                InfoAboutColorBlindnessTypeSection(
                  diagnosis: result.diagnosis,
                  correctAnswerCount: result.correctAnswerCount,
                  protanAnswerCount: result.protanAnswerCount,
                  deutanAnswerCount: result.deutanAnswerCount,
                ),
                SizedBox(height: 20.h),
                TestResultButton(
                  text: 'Retake Test',
                  textColor: Colors.white,
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    context.read<TestCubit>().restartTest();
                    GoRouter.of(context).go(Routes.testView);
                  },
                ),
                SizedBox(height: 12.h),
                TestResultButton(
                  text: 'Learn More About ${result.diagnosis}',
                  textColor: kPrimaryColor,
                  backgroundColor: kSecondaryColor,
                  onPressed: () {
                    GoRouter.of(context).push(Routes.chatbotView);
                  },
                ),
                SizedBox(height: 12.h),
                TestResultButton(
                  text: 'Back To Home',
                  textColor: kPrimaryColor,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    GoRouter.of(context).go(Routes.homeView);
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}