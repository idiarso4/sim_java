import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String defaultDateFormat = 'dd MMM yyyy';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'";

  // Format DateTime to string
  static String formatDate(DateTime? date, {String? format}) {
    if (date == null) return '';
    return DateFormat(format ?? defaultDateFormat).format(date);
  }

  // Parse string to DateTime
  static DateTime? parseDate(String? dateString, {String? format}) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat(format ?? defaultDateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Format time from minutes since midnight to HH:mm
  static String formatTimeFromMinutes(int minutes) {
    final hours = (minutes ~/ 60).toString().padLeft(2, '0');
    final mins = (minutes % 60).toString().padLeft(2, '0');
    return '$hours:$mins';
  }

  // Convert time string (HH:mm) to minutes since midnight
  static int timeToMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    return (hours * 60) + minutes;
  }

  // Get current date as string
  static String getCurrentDate({String? format}) {
    return formatDate(DateTime.now(), format: format);
  }

  // Get current time as string
  static String getCurrentTime({String? format}) {
    return DateFormat(format ?? defaultTimeFormat).format(DateTime.now());
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Add days to date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  // Get difference in days between two dates
  static int differenceInDays(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // Format duration
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:${twoDigits(duration.inSeconds.remainder(60))}';
    }
  }

  // Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  // Check if a date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Check if a date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  // Get age from birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    final m = now.month - birthDate.month;
    if (m < 0 || (m == 0 && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
