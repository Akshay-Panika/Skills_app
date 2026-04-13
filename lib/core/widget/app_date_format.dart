import 'package:intl/intl.dart';

class AppDateFormat {
  static String format(String? date) {
    if (date == null || date.trim().isEmpty) return "No Date";

    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd-MMMM-yyyy').format(parsed);
    } catch (e) {
      return "Invalid Date";
    }
  }
}