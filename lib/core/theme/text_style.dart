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

  // -------- 11 sp --------
  static TextStyle regular11() => _style(11, FontWeight.w400, 9, 15);
  static TextStyle medium11() => _style(11, FontWeight.w500, 9, 15);
  static TextStyle semiBold11() => _style(11, FontWeight.w600, 9, 15);
  static TextStyle bold11() => _style(11, FontWeight.w700, 9, 15);

  // -------- 12 sp --------
  static TextStyle regular12() => _style(12, FontWeight.w400, 10, 16);
  static TextStyle medium12() => _style(12, FontWeight.w500, 10, 16);
  static TextStyle semiBold12() => _style(12, FontWeight.w600, 10, 16);
  static TextStyle bold12() => _style(12, FontWeight.w700, 10, 16);

  // -------- 13 sp --------
  static TextStyle regular13() => _style(13, FontWeight.w400, 11, 17);
  static TextStyle medium13() => _style(13, FontWeight.w500, 11, 17);
  static TextStyle semiBold13() => _style(13, FontWeight.w600, 11, 17);
  static TextStyle bold13() => _style(13, FontWeight.w700, 11, 17);

  // -------- 14 sp --------
  static TextStyle regular14() => _style(14, FontWeight.w400, 12, 18);
  static TextStyle medium14() => _style(14, FontWeight.w500, 12, 18);
  static TextStyle semiBold14() => _style(14, FontWeight.w600, 12, 18);
  static TextStyle bold14() => _style(14, FontWeight.w700, 12, 18);

  // -------- 15 sp --------
  static TextStyle regular15() => _style(15, FontWeight.w400, 13, 18);
  static TextStyle medium15() => _style(15, FontWeight.w500, 13, 18);
  static TextStyle semiBold15() => _style(15, FontWeight.w600, 13, 18);
  static TextStyle bold15() => _style(15, FontWeight.w700, 13, 18);

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

  // -------- 36 sp --------
  static TextStyle regular36() => _style(36, FontWeight.w400, 32, 42);
  static TextStyle medium36() => _style(36, FontWeight.w500, 32, 42);
  static TextStyle semiBold36() => _style(36, FontWeight.w600, 32, 42);
  static TextStyle bold36() => _style(36, FontWeight.w700, 32, 42);

  // -------- 40 sp --------
  static TextStyle regular40() => _style(40, FontWeight.w400, 36, 46);
  static TextStyle medium40() => _style(40, FontWeight.w500, 36, 46);
  static TextStyle semiBold40() => _style(40, FontWeight.w600, 36, 46);
  static TextStyle bold40() => _style(40, FontWeight.w700, 36, 46);

  // -------- 48 sp --------
  static TextStyle regular48() => _style(48, FontWeight.w400, 42, 54);
  static TextStyle medium48() => _style(48, FontWeight.w500, 42, 54);
  static TextStyle semiBold48() => _style(48, FontWeight.w600, 42, 54);
  static TextStyle bold48() => _style(48, FontWeight.w700, 42, 54);



  // --------------------------------------------------------------
  // ALDRICH FONTS (ALL SIZES)
  // --------------------------------------------------------------
  static TextStyle aldrich6() => _style(6, FontWeight.w400, 4, 10, fontFamily: "Aldrich");
  static TextStyle aldrich8() => _style(8, FontWeight.w400, 6, 12, fontFamily: "Aldrich");
  static TextStyle aldrich10() => _style(10, FontWeight.w400, 8, 14, fontFamily: "Aldrich");
  static TextStyle aldrich11() => _style(11, FontWeight.w400, 9, 15, fontFamily: "Aldrich");
  static TextStyle aldrich12() => _style(12, FontWeight.w400, 10, 16, fontFamily: "Aldrich");
  static TextStyle aldrich13() => _style(13, FontWeight.w400, 11, 17, fontFamily: "Aldrich");
  static TextStyle aldrich14() => _style(14, FontWeight.w400, 12, 18, fontFamily: "Aldrich");
  static TextStyle aldrich15() => _style(15, FontWeight.w400, 13, 18, fontFamily: "Aldrich");
  static TextStyle aldrich16() => _style(16, FontWeight.w400, 14, 20, fontFamily: "Aldrich");
  static TextStyle aldrich17() => _style(17, FontWeight.w400, 15, 21, fontFamily: "Aldrich");
  static TextStyle aldrich18() => _style(18, FontWeight.w400, 16, 22, fontFamily: "Aldrich");
  static TextStyle aldrich19() => _style(19, FontWeight.w400, 17, 23, fontFamily: "Aldrich");
  static TextStyle aldrich20() => _style(20, FontWeight.w400, 18, 24, fontFamily: "Aldrich");
  static TextStyle aldrich21() => _style(21, FontWeight.w400, 19, 27, fontFamily: "Aldrich");
  static TextStyle aldrich22() => _style(22, FontWeight.w400, 20, 28, fontFamily: "Aldrich");
  static TextStyle aldrich23() => _style(23, FontWeight.w400, 20, 28, fontFamily: "Aldrich");
  static TextStyle aldrich24() => _style(24, FontWeight.w400, 22, 30, fontFamily: "Aldrich");
  static TextStyle aldrich25() => _style(25, FontWeight.w400, 22, 32, fontFamily: "Aldrich");
  static TextStyle aldrich26() => _style(26, FontWeight.w400, 22, 32, fontFamily: "Aldrich");
  static TextStyle aldrich27() => _style(27, FontWeight.w400, 23, 33, fontFamily: "Aldrich");
  static TextStyle aldrich28() => _style(28, FontWeight.w400, 24, 34, fontFamily: "Aldrich");
  static TextStyle aldrich30() => _style(30, FontWeight.w400, 26, 36, fontFamily: "Aldrich");
  static TextStyle aldrich32() => _style(32, FontWeight.w400, 28, 38, fontFamily: "Aldrich");
  static TextStyle aldrich34() => _style(34, FontWeight.w400, 30, 40, fontFamily: "Aldrich");
  static TextStyle aldrich36() => _style(36, FontWeight.w400, 32, 42, fontFamily: "Aldrich");
  static TextStyle aldrich40() => _style(40, FontWeight.w400, 36, 46, fontFamily: "Aldrich");
  static TextStyle aldrich48() => _style(48, FontWeight.w400, 42, 54, fontFamily: "Aldrich");
}
