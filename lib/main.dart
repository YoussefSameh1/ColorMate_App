import 'package:colormate_app/core/services/storage_service.dart';
import 'package:colormate_app/core/theme/app_colors.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/utils/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env', isOptional: true);
  Gemini.init(apiKey: kGeminiApiKey);

  await StorageService.getInstance();

  Bloc.observer = SimpleBlocObserver();
  
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
            scaffoldBackgroundColor: AppColors.white,
          ),
        );
      },
    );
  }
}
