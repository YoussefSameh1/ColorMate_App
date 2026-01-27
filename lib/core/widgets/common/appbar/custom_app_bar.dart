import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../buttons/custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackTap,
  });

  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorTheme().whiteColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,

      // -- Title
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.semiBold20().copyWith(
                color: ColorTheme().navyBlue,
              ),
            )
          : null,

      // -- Custom Back Button
      automaticallyImplyLeading: false, // Disable default back button
      leadingWidth: 70.w, // Enough space for padding + button
      leading: showBackButton
          ? Padding(
              // Matches Figma "Left: 16px"
              padding: EdgeInsets.only(left: 10.w),
              child: Center(child: CustomBackButton(onTap: onBackTap)),
            )
          : null,

      // -- Optional Actions
      actions: actions != null
          ? [
              ...actions!,
              SizedBox(width: 16.w), // Right padding for actions
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
