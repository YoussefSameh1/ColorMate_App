import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButtonVisible = true,
    this.isTitleLong = false,
  });

  final String title;
  final bool isBackButtonVisible;
  final bool isTitleLong;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
          child: Row(
            children: [
              if (isBackButtonVisible)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: kPrimaryColor,
                      size: isTitleLong ? 20.sp : 28.sp,
                    ),
                  ),
                ),
              Spacer(flex: isBackButtonVisible ? 2 : 3),
              Text(title, style: Styles.titleStyle.copyWith(fontSize: isTitleLong ? 24.sp : 32.sp)),
              const Spacer(flex: 3),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Divider(thickness: 1, height: 1, color: kPrimaryColor.withAlpha(100)),
      ],
    );
  }
}
