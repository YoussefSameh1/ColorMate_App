// start_test_button.dart
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class StartTestButton extends StatelessWidget {
  const StartTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).go(Routes.testView);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),  // was raw 14
        ),
        minimumSize: Size(double.infinity, 52.h),     // full-width; was 250.w
        elevation: 0,
      ),
      child: Text('Start Test', style: Styles.buttonTextStyle),
    );
  }
}