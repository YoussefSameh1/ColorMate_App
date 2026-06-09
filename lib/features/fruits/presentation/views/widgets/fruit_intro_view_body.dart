// fruit_intro_view_body.dart
import 'package:colormate_app/core/utils/assets_data.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/scan_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FruitIntroViewBody extends StatelessWidget {
  const FruitIntroViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.65; // 65% of screen width, works on all sizes

    return SingleChildScrollView(  // prevents overflow on small screens
      child: Column(
        children: [
          CustomAppBar(title: 'Fruits Scanner'),
          Padding(
            padding: EdgeInsets.only(
              top: 40.h,
              left: 16.w,
              right: 16.w,
              bottom: 24.h,
            ),
            child: Column(
              children: [
                Text(
                  'Scan fruit spoiled areas and assess freshness',
                  textAlign: TextAlign.center,
                  style: Styles.titleStyle.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 24.h),
                ClipOval(
                  child: Image.asset(
                    AssetsData.fruit,
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 40.h),
                const ScanButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}