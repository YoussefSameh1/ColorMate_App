import 'package:flutter/material.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final double iconSize;
  final double spacing;

  const SocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.iconSize = 44,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onGooglePressed ?? () {},
          icon: Image.asset(
            'assets/icons/google_icon.png',
            width: iconSize,
            height: iconSize,
          ),
        ),
        // SizedBox(width: spacing),
        // IconButton(
        //   onPressed: onFacebookPressed ?? () {},
        //   icon: Image.asset(
        //     'assets/icons/facebook_icon.png',
        //     width: iconSize,
        //     height: iconSize,
        //   ),
        // ),
      ],
    );
  }
}
