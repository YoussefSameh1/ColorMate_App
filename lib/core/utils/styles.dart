import 'package:colormate_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static TextStyle skipTextButtonStyle = TextStyle(
    fontSize: 16,
    color: kAccentColor,
    fontWeight: FontWeight.w600,
    fontFamily: kPoppinsFont,
    decoration: TextDecoration.underline,
    decorationColor: kAccentColor,
  );
  static TextStyle onboardingTitleStyle = TextStyle(
    fontSize: 32,
    color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: kPoppinsFont,
  );
  static TextStyle onboardingDescriptionStyle = TextStyle(
    fontSize: 18,
    color: kSubTitleColor,
    fontWeight: FontWeight.w400,
    fontFamily: kPoppinsFont,
  );
}
