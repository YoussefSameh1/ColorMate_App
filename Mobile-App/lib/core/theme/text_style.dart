import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle _style(
    double size,
    FontWeight weight,
    double min,
    double max, {
    String fontFamily = "Poppins",
  }) {
    return TextStyle(
      fontSize: size.sp.clamp(min, max),
      fontWeight: weight,
      fontFamily: fontFamily,
    );
  }

  // --------------------------------------------------------------
  // POPPINS FONTS (DEFAULT)
  // --------------------------------------------------------------

 // -------- 8 sp --------
  static TextStyle regular8() => _style(8, FontWeight.w400, 6, 12);
  static TextStyle medium8() => _style(8, FontWeight.w500, 6, 12);
  static TextStyle semiBold8() => _style(8, FontWeight.w600, 6, 12);
  static TextStyle bold8() => _style(8, FontWeight.w700, 6, 12);

  // -------- 10 sp --------
  static TextStyle regular10() => _style(10, FontWeight.w400, 8, 14);
  static TextStyle medium10() => _style(10, FontWeight.w500, 8, 14);
  static TextStyle semiBold10() => _style(10, FontWeight.w600, 8, 14);
  static TextStyle bold10() => _style(10, FontWeight.w700, 8, 14);
  // -------- 16 sp --------
  static TextStyle regular16() => _style(16, FontWeight.w400, 14, 20);
  static TextStyle medium16() => _style(16, FontWeight.w500, 14, 20);
  static TextStyle semiBold16() => _style(16, FontWeight.w600, 14, 20);
  static TextStyle bold16() => _style(16, FontWeight.w700, 14, 20);

  // -------- 17 sp --------
  static TextStyle regular17() => _style(17, FontWeight.w400, 15, 21);
  static TextStyle medium17() => _style(17, FontWeight.w500, 15, 21);
  static TextStyle semiBold17() => _style(17, FontWeight.w600, 15, 21);
  static TextStyle bold17() => _style(17, FontWeight.w700, 15, 21);

  // -------- 18 sp --------
  static TextStyle regular18() => _style(18, FontWeight.w400, 16, 22);
  static TextStyle medium18() => _style(18, FontWeight.w500, 16, 22);
  static TextStyle semiBold18() => _style(18, FontWeight.w600, 16, 22);
  static TextStyle bold18() => _style(18, FontWeight.w700, 16, 22);

  // -------- 19 sp --------
  static TextStyle regular19() => _style(19, FontWeight.w400, 17, 23);
  static TextStyle medium19() => _style(19, FontWeight.w500, 17, 23);
  static TextStyle semiBold19() => _style(19, FontWeight.w600, 17, 23);
  static TextStyle bold19() => _style(19, FontWeight.w700, 17, 23);

  // -------- 20 sp --------
  static TextStyle regular20() => _style(20, FontWeight.w400, 18, 24);
  static TextStyle medium20() => _style(20, FontWeight.w500, 18, 24);
  static TextStyle semiBold20() => _style(20, FontWeight.w600, 18, 24);
  static TextStyle bold20() => _style(20, FontWeight.w700, 18, 24);

  // -------- 21 sp --------
  static TextStyle regular21() => _style(21, FontWeight.w400, 19, 27);
  static TextStyle medium21() => _style(21, FontWeight.w500, 19, 27);
  static TextStyle semiBold21() => _style(21, FontWeight.w600, 19, 27);
  static TextStyle bold21() => _style(21, FontWeight.w700, 19, 27);

  // -------- 22 sp --------
  static TextStyle regular22() => _style(22, FontWeight.w400, 20, 28);
  static TextStyle medium22() => _style(22, FontWeight.w500, 20, 28);
  static TextStyle semiBold22() => _style(22, FontWeight.w600, 20, 28);
  static TextStyle bold22() => _style(22, FontWeight.w700, 20, 28);

  // -------- 23 sp --------
  static TextStyle regular23() => _style(23, FontWeight.w400, 20, 28);
  static TextStyle medium23() => _style(23, FontWeight.w500, 20, 28);
  static TextStyle semiBold23() => _style(23, FontWeight.w600, 20, 28);
  static TextStyle bold23() => _style(23, FontWeight.w700, 20, 28);

  // -------- 24 sp --------
  static TextStyle regular24() => _style(24, FontWeight.w400, 22, 30);
  static TextStyle medium24() => _style(24, FontWeight.w500, 22, 30);
  static TextStyle semiBold24() => _style(24, FontWeight.w600, 22, 30);
  static TextStyle bold24() => _style(24, FontWeight.w700, 22, 30);

  // -------- 25 sp --------
  static TextStyle regular25() => _style(25, FontWeight.w400, 22, 32);
  static TextStyle medium25() => _style(25, FontWeight.w500, 22, 32);
  static TextStyle semiBold25() => _style(25, FontWeight.w600, 22, 32);
  static TextStyle bold25() => _style(25, FontWeight.w700, 22, 32);

  // -------- 26 sp --------
  static TextStyle regular26() => _style(26, FontWeight.w400, 22, 32);
  static TextStyle medium26() => _style(26, FontWeight.w500, 22, 32);
  static TextStyle semiBold26() => _style(26, FontWeight.w600, 22, 32);
  static TextStyle bold26() => _style(26, FontWeight.w700, 22, 32);

  // -------- 27 sp --------
  static TextStyle regular27() => _style(27, FontWeight.w400, 23, 33);
  static TextStyle medium27() => _style(27, FontWeight.w500, 23, 33);
  static TextStyle semiBold27() => _style(27, FontWeight.w600, 23, 33);
  static TextStyle bold27() => _style(27, FontWeight.w700, 23, 33);

  // -------- 28 sp --------
  static TextStyle regular28() => _style(28, FontWeight.w400, 24, 34);
  static TextStyle medium28() => _style(28, FontWeight.w500, 24, 34);
  static TextStyle semiBold28() => _style(28, FontWeight.w600, 24, 34);
  static TextStyle bold28() => _style(28, FontWeight.w700, 24, 34);

  // -------- 30 sp --------
  static TextStyle regular30() => _style(30, FontWeight.w400, 26, 36);
  static TextStyle medium30() => _style(30, FontWeight.w500, 26, 36);
  static TextStyle semiBold30() => _style(30, FontWeight.w600, 26, 36);
  static TextStyle bold30() => _style(30, FontWeight.w700, 26, 36);

  // -------- 32 sp --------
  static TextStyle regular32() => _style(32, FontWeight.w400, 28, 38);
  static TextStyle medium32() => _style(32, FontWeight.w500, 28, 38);
  static TextStyle semiBold32() => _style(32, FontWeight.w600, 28, 38);
  static TextStyle bold32() => _style(32, FontWeight.w700, 28, 38);

  // -------- 34 sp --------
  static TextStyle regular34() => _style(34, FontWeight.w400, 30, 40);
  static TextStyle medium34() => _style(34, FontWeight.w500, 30, 40);
  static TextStyle semiBold34() => _style(34, FontWeight.w600, 30, 40);
  static TextStyle bold34() => _style(34, FontWeight.w700, 30, 40);
}
