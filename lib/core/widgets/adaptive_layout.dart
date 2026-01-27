import 'package:flutter/material.dart';

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
        // Mobile: < 600px (phones only)
        if (constraints.maxWidth < 600) {
          return mobileLayout(context);
        }
        // Tablet: 600px - 1100px (small, medium, large tablets)
        else if (constraints.maxWidth < 1100) {
          return tabletLayout(context);
        }
        // Desktop: >= 1100px
        else {
          return desktopLayout(context);
        }
      },
    );
  }
}
