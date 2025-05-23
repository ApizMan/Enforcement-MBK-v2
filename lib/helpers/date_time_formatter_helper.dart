class DateTimeFormatterHelper {
  /// Converts '202505221232PM' → '22/05/2025'
  static String formatToDisplayDate(String rawDateTime) {
    try {
      final year = rawDateTime.substring(0, 4);
      final month = rawDateTime.substring(4, 6);
      final day = rawDateTime.substring(6, 8);

      return '$day/$month/$year';
    } catch (e) {
      print('Date parse error: $e');
      return '-';
    }
  }

  /// Converts '202505221232PM' → '12:32 PM'
  static String formatToDisplayTime(String rawDateTime) {
    try {
      final hour = rawDateTime.substring(8, 10);
      final minute = rawDateTime.substring(10, 12);
      final ampm = rawDateTime.substring(12, 14).toUpperCase();

      return '$hour:$minute:00 $ampm';
    } catch (e) {
      print('Time parse error: $e');
      return '-';
    }
  }
}
