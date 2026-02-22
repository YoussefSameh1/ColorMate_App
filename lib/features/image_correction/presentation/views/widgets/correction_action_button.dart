import 'package:colormate_app/core/widget/buttons/primary_shadow_button.dart';
import 'package:colormate_app/core/widget/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

class CorrectionActionButton extends StatelessWidget {
  const CorrectionActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return PrimaryShadowButton(
        text: text,
        icon: icon,
        onPressed: onTap,
        width: 164,
        height: 48,
        radius: 24,
      );
    }

    return SecondaryButton(
      text: text,
      onPressed: onTap,
      icon: icon,
      width: 164,
      height: 48,
    );
  }
}
