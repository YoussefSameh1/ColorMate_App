import 'package:colormate_app/core/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

int calculateBottomNavIndex(BuildContext context) {
  final location = GoRouterState.of(context).uri.toString();

  if (location.startsWith(Routes.chatbotView)) return 1;
  if (location.startsWith(Routes.profileView)) return 2;
  return 0;
}
