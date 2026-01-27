import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constant.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
  });

  final WidgetBuilder mobileLayout, tabletLayout, desktopLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        if (constraints.maxWidth < 600) {
          return ScreenUtilInit(
            designSize: mobileDesignSize,
            minTextAdapt: true,
            splitScreenMode: true,
            child: mobileLayout(context),
          );
        } else if (constraints.maxWidth < 1024) {
          return ScreenUtilInit(
            designSize: tabletDesignSize,
            minTextAdapt: true,
            splitScreenMode: true,
            child: tabletLayout(context),
          );
        } else {
          return ScreenUtilInit(
            designSize: desktopDesignSize,
            minTextAdapt: true,
            splitScreenMode: true,
            child: desktopLayout(context),
          );
        }
      },
    );
  }
}
