import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TakeTestButton extends StatelessWidget {
  const TakeTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).go(Routes.testView);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        minimumSize: Size(160.w, 40.h),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      ),
      child: Text('Start Test', style: Styles.buttonTextStyle.copyWith(fontSize: 14.sp)),
    );
  }
}