import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/services/storage_service.dart';
import 'package:colormate_app/core/utils/styles.dart';
import 'package:colormate_app/home_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SkipTextButton extends StatelessWidget {
  const SkipTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async{
        final storageService = await StorageService.getInstance();
        await storageService.setOnboardingComplete();

        if (context.mounted){
          GoRouter.of(context).push(Routes.loginView);
        }
      },
      child: Text('Skip', style: Styles.skipTextButtonStyle),
    );
  }
}
