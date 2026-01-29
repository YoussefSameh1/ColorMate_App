import 'package:colormate_app/core/services/storage_service.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/home_test.dart';
import 'package:flutter/material.dart';

class SkipTextButton extends StatelessWidget {
  const SkipTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async{
        final storageService = await StorageService.getInstance();
        await storageService.setOnboardingComplete();

        if (context.mounted){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeTest()),
            );
        }
      },
      child: Text('Skip', style: Styles.skipTextButtonStyle),
    );
  }
}
