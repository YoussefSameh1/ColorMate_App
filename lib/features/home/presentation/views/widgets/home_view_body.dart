import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/widget/custom_app_bar.dart';
import 'package:colormate_app/features/home/presentation/views/widgets/home_grid_view.dart';
import 'package:colormate_app/features/home/presentation/views/widgets/welcome_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(title: 'Home', isBackButtonVisible: false),
          WelcomeSection(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: HomeGridView(),
            ),
          ),
        ],
      ),
    );
  }
}
