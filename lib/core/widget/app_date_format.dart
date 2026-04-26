import 'package:intl/intl.dart';

class AppDateFormat {
  static String dateFormat(String? date) {
    if (date == null || date.trim().isEmpty) {
      return "No Date";
    }

    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd-MMMM-yyyy').format(parsed);
    } catch (e) {
      return "Invalid Date";
    }
  }

  static String timeDateFormat(String? date) {
    if (date == null || date.trim().isEmpty) {
      return "No Time";
    }

    try {
      final parsed = DateTime.parse(date).toLocal();
      final now = DateTime.now();

      final difference =
          now.difference(parsed).inDays;

      /// if message older than 2 days → show date
      if (difference >= 2) {
        return DateFormat(
          'dd-MMMM-yyyy',
        ).format(parsed);
      }

      /// else show only time
      return DateFormat(
        'hh:mm a',
      ).format(parsed);

    } catch (e) {
      return "Invalid Time";
    }
  }
}