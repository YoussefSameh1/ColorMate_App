// تحويل UTC String لـ تاريخ منسق
import 'package:easy_localization/easy_localization.dart';
import 'package:colormate_app/core/utils/constant.dart';

String formatDateFromUTC(String? utcString) {
  if (utcString == null || utcString.isEmpty) return '';

  try {
    // Parse UTC string to DateTime
    final dateTime = DateTime.parse(utcString);

    // Format as dd/MM/yyyy
    return DateFormat(
      'dd/MM/yyyy',
      ConstantVariable.englishLangCode,
    ).format(dateTime);
  } catch (e) {
    // If parsing fails, return original string
    return utcString;
  }
}
