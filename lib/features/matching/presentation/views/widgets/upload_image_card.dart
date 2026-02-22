import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadImageCard extends StatelessWidget {
  const UploadImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 1.5.w),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload_outlined, size: 60.r, color: kPrimaryColor),
          SizedBox(height: 12.h),
          Text(
            "Upload or Select Image",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Choose an image from your gallery or take a new one to apply outfit rating.",
            textAlign: TextAlign.center,
            style: TextStyle(color: kPrimaryColor),
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.upload, color: Colors.white),
            label: const Text(
              "Choose Photo",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
