import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvancedGameAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final String hint;
  final int subtitleValue;
  final int hintValue;
  final bool isColorCollectorGame;

  const AdvancedGameAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.subtitleValue,
    required this.hintValue,
    this.isColorCollectorGame = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: kPrimaryColor,
          size: 20.sp,
        ),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),

      title: Text(
        title,
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$subtitle: $subtitleValue',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isColorCollectorGame
                    ? '$hint: $hintValue/10'
                    : '$hint: $hintValue',
                style: TextStyle(color: kPrimaryColor, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
