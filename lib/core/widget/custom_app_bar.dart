import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButtonVisible = true,
    this.onBackPressed,
  });

  final String title;
  final bool isBackButtonVisible;
  final VoidCallback? onBackPressed;

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
                    onPressed: () {
                      if (onBackPressed != null) {
                        onBackPressed!();
                        return;
                      }

                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: kPrimaryColor,
                      size: 28,
                    ),
                  ),
                ),
              Spacer(flex: isBackButtonVisible ? 2 : 3),
              Text(title, style: Styles.titleStyle),
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
