import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StringUtils {
  // Check if string is null or empty
  static bool isNullOrEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  // Check if string is not null and not empty
  static bool isNotNullOrEmpty(String? str) {
    return !isNullOrEmpty(str);
  }

  // Capitalize first letter of each word
  static String capitalize(String text) {
    if (isNullOrEmpty(text)) return '';
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    if (isNullOrEmpty(phone)) return '';
    
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Format based on length
    if (digits.length == 12 && digits.startsWith('62')) {
      // Format: 62 812-3456-7890
      return '${digits.substring(0, 2)} ${digits.substring(2, 5)}-${digits.substring(5, 9)}-${digits.substring(9)}';
    } else if (digits.length == 13 && digits.startsWith('62')) {
      // Format: 62 812-3456-78901
      return '${digits.substring(0, 2)} ${digits.substring(2, 5)}-${digits.substring(5, 9)}-${digits.substring(9)}';
    } else if (digits.length == 11 && digits.startsWith('0')) {
      // Format: 0812-3456-7890
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)}-${digits.substring(8)}';
    } else if (digits.length == 10 && digits.startsWith('8')) {
      // Format: 812-3456-7890
      return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    }
    
    // Return original if no matching format
    return phone;
  }

  // Format currency (IDR)
  static String formatCurrency(dynamic value, {String symbol = 'Rp '}) {
    if (value == null) return '$symbol0';
    
    final number = value is num ? value : double.tryParse(value.toString()) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0,
    );
    
    return formatter.format(number);
  }

  // Format date from string
  static String formatDateString(String? dateString, 
      {String format = 'dd MMM yyyy'}) {
    if (isNullOrEmpty(dateString)) return '';
    
    try {
      final date = DateTime.parse(dateString!);
      return DateFormat(format).format(date);
    } catch (e) {
      return dateString!;
    }
  }

  // Truncate string with ellipsis
  static String truncate(String text, {int length = 30, String omission = '...'}) {
    if (isNullOrEmpty(text)) return '';
    if (text.length <= length) return text;
    return '${text.substring(0, length)}$omission';
  }

  // Extract initials from name
  static String getInitials(String? name, {int limit = 2}) {
    if (isNullOrEmpty(name)) return '';
    
    final words = name!.trim().split(' ');
    var initials = '';
    
    for (var i = 0; i < limit && i < words.length; i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }
    
    return initials;
  }

  // Validate email
  static bool isValidEmail(String? email) {
    if (isNullOrEmpty(email)) return false;
    return RegExp(
      r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    ).hasMatch(email!);
  }

  // Validate URL
  static bool isValidUrl(String? url) {
    if (isNullOrEmpty(url)) return false;
    return Uri.tryParse(url!)?.hasAbsolutePath ?? false;
  }

  // Launch URL in browser
  static Future<bool> launchUrl(String? url) async {
    if (isNullOrEmpty(url)) return false;
    
    try {
      final uri = Uri.parse(url!);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Generate a random string
  static String generateRandomString({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final randomStr = StringBuffer();
    
    for (var i = 0; i < length; i++) {
      randomStr.write(chars[random % chars.length]);
    }
    
    return randomStr.toString();
  }

  // Convert string to enum
  static T? enumFromString<T>(Iterable<T> values, String value, 
      {bool caseSensitive = true}) {
    for (final enumValue in values) {
      if (caseSensitive) {
        if (enumValue.toString().split('.').last == value) {
          return enumValue;
        }
      } else {
        if (enumValue.toString().split('.').last.toLowerCase() == value.toLowerCase()) {
          return enumValue;
        }
      }
    }
    return null;
  }

  // Mask sensitive information (e.g., credit card, phone number)
  static String maskSensitiveInfo(String? input, 
      {int visibleDigits = 4, String maskChar = '*', bool fromStart = false}) {
    if (isNullOrEmpty(input)) return '';
    
    final length = input!.length;
    if (length <= visibleDigits) return input;
    
    final mask = maskChar * (length - visibleDigits);
    return fromStart 
        ? '$mask${input.substring(length - visibleDigits)}'
        : '${input.substring(0, visibleDigits)}$mask';
  }

  // Convert string to title case
  static String toTitleCase(String text) {
    if (isNullOrEmpty(text)) return '';
    
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }

  // Remove diacritics from string
  static String removeDiacritics(String text) {
    const diacritics = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const nonDiacritics = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    
    return text.splitMapJoin(
      '',
      onNonMatch: (char) {
        final index = diacritics.indexOf(char);
        return index != -1 ? nonDiacritics[index] : char;
      },
    );
  }

  // Count words in a string
  static int countWords(String text) {
    if (isNullOrEmpty(text)) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  // Check if string contains only numbers
  static bool isNumeric(String? str) {
    if (isNullOrEmpty(str)) return false;
    return double.tryParse(str!) != null;
  }

  // Check if string is a valid Indonesian phone number
  static bool isValidIndonesianPhoneNumber(String? phone) {
    if (isNullOrEmpty(phone)) return false;
    
    // Remove all non-digit characters
    final digits = phone!.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Check if it's a valid Indonesian phone number
    // 08xxxxxxxxxx (11-13 digits)
    // 628xxxxxxxxx (11-13 digits)
    return RegExp(r'^(\+?62|0)8[1-9][0-9]{6,9}$').hasMatch(digits);
  }

  // Convert string to slug
  static String toSlug(String text) {
    if (isNullOrEmpty(text)) return '';
    
    // Convert to lowercase and remove diacritics
    var slug = removeDiacritics(text.toLowerCase());
    
    // Replace non-alphanumeric characters with dashes
    slug = slug.replaceAll(RegExp(r'[^a-z0-9\s-]'), '-');
    
    // Replace multiple spaces or dashes with a single dash
    slug = slug.replaceAll(RegExp(r'[\s-]+'), '-');
    
    // Trim dashes from start and end
    return slug.replaceAll(RegExp(r'^-+|-+$'), '');
  }

  // Format file size
  static String formatFileSize(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  // Check if string is a valid URL and return Uri, null otherwise
  static Uri? parseUri(String? url) {
    if (isNullOrEmpty(url)) return null;
    
    try {
      return Uri.parse(url!);
    } catch (e) {
      return null;
    }
  }

  // Extract domain from URL
  static String? extractDomain(String? url) {
    if (isNullOrEmpty(url)) return null;
    
    try {
      final uri = Uri.parse(url!);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  // Generate initials from multiple names
  static String getInitialsFromNames(String? names, {int maxInitials = 2}) {
    if (isNullOrEmpty(names)) return '';
    
    final nameList = names!.trim().split(' ');
    var initials = '';
    
    for (var i = 0; i < nameList.length && i < maxInitials; i++) {
      if (nameList[i].isNotEmpty) {
        initials += nameList[i][0].toUpperCase();
      }
    }
    
    return initials;
  }

  // Check if string is a valid JSON
  static bool isValidJson(String? str) {
    if (isNullOrEmpty(str)) return false;
    
    try {
      jsonDecode(str!);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Convert string to enum value
  static T? toEnum<T>(List<T> values, String value) {
    try {
      return values.firstWhere(
        (e) => e.toString().split('.').last == value,
      );
    } catch (e) {
      return null;
    }
  }

  // Generate a hash code from string (simple implementation)
  static int simpleHash(String str) {
    var hash = 0;
    for (var i = 0; i < str.length; i++) {
      hash = (hash << 5) - hash + str.codeUnitAt(i);
      hash |= 0; // Convert to 32bit integer
    }
    return hash;
  }

  // Check if string contains HTML tags
  static bool containsHtml(String? str) {
    if (isNullOrEmpty(str)) return false;
    return RegExp(r'<[a-z][\s\S]*>', caseSensitive: false).hasMatch(str!);
  }

  // Remove HTML tags from string
  static String stripHtml(String? html) {
    if (isNullOrEmpty(html)) return '';
    
    // Remove HTML tags
    var text = html!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
    
    // Replace multiple spaces with a single space
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return text;
  }

  // Truncate string at word boundary
  static String truncateAtWord(String text, {int maxLength = 100, String omission = '...'}) {
    if (isNullOrEmpty(text) || text.length <= maxLength) return text ?? '';
    
    var result = text.substring(0, maxLength);
    final lastSpace = result.lastIndexOf(' ');
    
    if (lastSpace > 0) {
      result = result.substring(0, lastSpace);
    }
    
    return '$result$omission';
  }

  // Add commas to number string
  static String formatNumberWithCommas(String number) {
    if (isNullOrEmpty(number)) return '0';
    
    try {
      return NumberFormat('#,###').format(int.parse(number));
    } catch (e) {
      return number;
    }
  }
}

// Extension methods for String class
extension StringExtension on String? {
  bool get isNullOrEmpty => StringUtils.isNullOrEmpty(this);
  bool get isNotNullOrEmpty => StringUtils.isNotNullOrEmpty(this);
  String get capitalize => StringUtils.capitalize(this ?? '');
  String get toTitleCase => StringUtils.toTitleCase(this ?? '');
  String get removeDiacritics => StringUtils.removeDiacritics(this ?? '');
  String toSlug() => StringUtils.toSlug(this ?? '');
  bool get isValidEmail => StringUtils.isValidEmail(this);
  bool get isValidUrl => StringUtils.isValidUrl(this);
  Future<bool> launch() => StringUtils.launchUrl(this);
  String mask({int visibleDigits = 4, String maskChar = '*', bool fromStart = false}) => 
      StringUtils.maskSensitiveInfo(this, 
          visibleDigits: visibleDigits, 
          maskChar: maskChar, 
          fromStart: fromStart);
  int get wordCount => StringUtils.countWords(this ?? '');
  bool get isNumeric => StringUtils.isNumeric(this);
  bool get isValidIndonesianPhone => StringUtils.isValidIndonesianPhoneNumber(this);
  String formatFileSize({int decimals = 2}) => 
      StringUtils.formatFileSize(int.tryParse(this ?? '0') ?? 0, decimals: decimals);
  String? get extractDomain => StringUtils.extractDomain(this);
  String get initials => StringUtils.getInitialsFromNames(this);
  bool get isJson => StringUtils.isValidJson(this);
  String stripHtml() => StringUtils.stripHtml(this);
  String truncateAtWord({int maxLength = 100, String omission = '...'}) =>
      StringUtils.truncateAtWord(this ?? '', maxLength: maxLength, omission: omission);
  String formatWithCommas() => StringUtils.formatNumberWithCommas(this ?? '');
}
