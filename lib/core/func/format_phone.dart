/// Formats an Egyptian phone number into a standardized display format.
///
/// Examples:
/// - Input: "01012345678"      -> Output: "+20 10 1234 5678"
/// - Input: "201112345678"     -> Output: "+20 11 1234 5678"
/// - Input: "+201212345678"    -> Output: "+20 12 1234 5678"
/// - Input: "015 123 456 78"   -> Output: "+20 15 1234 5678"
String formatEgyptianPhoneNumber(String phone) {
  if (phone.isEmpty) return '';

  String cleaned = phone.replaceAll(RegExp(r'\D'), '');

  // 1. Check Country Code
  if (cleaned.startsWith('20')) {
    cleaned = cleaned.substring(2);
  }

  // 2. Check Leading Zero (Remove 'else' so it runs even if step 1 ran)
  if (cleaned.startsWith('0')) {
    cleaned = cleaned.substring(1);
  }

  // 3. Validation & Formatting
  if (cleaned.length == 10 &&
      (cleaned.startsWith('10') ||
          cleaned.startsWith('11') ||
          cleaned.startsWith('12') ||
          cleaned.startsWith('15'))) {
    final prefix = cleaned.substring(0, 2);
    final part1 = cleaned.substring(2, 6);
    final part2 = cleaned.substring(6);

    return '+20 $prefix $part1 $part2';
  }

  return phone;
}
