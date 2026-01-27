/// Utility functions for date formatting and conversion
class DateUtils {
  /// Convert DateTime to UTC String format
  /// Format: 2025-10-25T00:00:00Z (ISO 8601 with Z)
  /// Always uses 00:00:00 for time component
  static String convertToUtcString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    // Always use 00:00:00 for time as backend expects date only
    return '$year-$month-${day}T00:00:00Z';
  }

  /// Convert DateTime to DD/MM/YYYY format
  static String convertToDDMMYYYY(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
