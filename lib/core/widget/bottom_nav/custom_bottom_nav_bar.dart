import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:colormate_app/core/routing/routes.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/core/widget/bottom_nav/bottom_nav_items.dart';
import 'package:colormate_app/core/widget/bottom_nav/bottom_nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final NotchBottomBarController _controller = NotchBottomBarController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newIndex = calculateBottomNavIndex(context);
    if (_controller.index != newIndex) {
      _controller.index = newIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      notchBottomBarController: _controller,
      color: Colors.white,
      showLabel: true,
      shadowElevation: 5,
      kBottomRadius: 24.0,
      notchColor: kPrimaryColor,
      elevation: 10,
      showShadow: true,
      durationInMilliSeconds: 300,
      itemLabelStyle: const TextStyle(fontSize: 10),
      kIconSize: 24.0,
      bottomBarItems: buildBottomNavItems(),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(Routes.homeView);
            break;
          case 1:
            context.go(Routes.chatView);
            break;
          case 2:
            context.go(Routes.profileView);
            break;
        }
      },
    );
  }
}
