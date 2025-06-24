import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
