import 'package:colormate_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class SkipTextButton extends StatelessWidget {
  const SkipTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // go to home page
      },
      child: Text('Skip', style: Styles.skipTextButtonStyle),
    );
  }
}
