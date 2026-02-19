import 'package:colormate_app/core/utils/assets_data.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/fruits/presentation/views/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              AssetsData.fruit,
              height: 300.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 36.h,
            right: 16.w,
            child: Tag(text: 'Spoiled area\n25%', color: Colors.red),
          ),

          Positioned(
            bottom: 56.h,
            left: 24.w,
            child: Tag(text: 'Fresh part', color: Colors.green),
          ),
        ],
      ),
    );
  }
}
