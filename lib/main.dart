import 'package:colormate_app/core/services/storage_service.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.getInstance();
  /*
  final storageService = await StorageService.getInstance();
  await storageService.clearOnboarding();
  */
  runApp(const ColorMateApp());
}

class ColorMateApp extends StatelessWidget {
  const ColorMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: 'ColorMate App',
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: kBackgroundColor,
          ),
        );
      },
    );
  }
}
