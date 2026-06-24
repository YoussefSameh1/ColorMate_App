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
  static TextStyle titleStyle = TextStyle(
    fontSize: 32,
    color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: kPoppinsFont,
  );
  static TextStyle descriptionStyle = TextStyle(
    fontSize: 18,
    color: kSubTitleColor,
    fontWeight: FontWeight.w400,
    fontFamily: kPoppinsFont,
  );
  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: kPoppinsFont,
  );
  static TextStyle testQuestionTextStyle = TextStyle(
    fontSize: 18,
    color: kPrimaryColor,
    fontWeight: FontWeight.w600,
    fontFamily: kPoppinsFont,
  );
  static TextStyle textButtonTextStyle = TextStyle(
    fontSize: 14,
    color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: kPoppinsFont,
    decoration: TextDecoration.underline,
    decorationColor: kPrimaryColor,
  );
  static TextStyle testResultTextStyle = TextStyle(
    fontSize: 14,
    color: kPrimaryColor,
    fontWeight: FontWeight.w400,
    fontFamily: kPoppinsFont,
  );
}
