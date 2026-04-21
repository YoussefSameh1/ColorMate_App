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
    return Column(
      children: [
        CustomAppBar(title: 'Fruits Scanner'),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            children: [
              Text(
                'Scan fruit spoiled ares and assess freshness',
                style: Styles.titleStyle.copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 30.h),
              ClipOval(
                child: Image.asset(
                  AssetsData.fruit,
                  height: 300.h,
                  width: 300.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 50.h),
              ScanButton(),
            ],
          ),
        ),
      ],
    );
  }
}

