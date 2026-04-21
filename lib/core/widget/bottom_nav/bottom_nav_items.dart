import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

List<BottomBarItem> buildBottomNavItems() {
  return [
    _buildItem(
      inactiveIcon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _buildItem(
      inactiveIcon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Chat',
    ),
    _buildItem(
      inactiveIcon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];
}

BottomBarItem _buildItem({
  required IconData inactiveIcon,
  required IconData activeIcon,
  required String label,
}) {
  return BottomBarItem(
    inActiveItem: Icon(inactiveIcon, color: kPrimaryColor),
    activeItem: Icon(activeIcon, color: Colors.white),
    itemLabel: label,
  );
}
