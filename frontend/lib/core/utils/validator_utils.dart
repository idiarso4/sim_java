import 'package:intl/intl.dart';

class ValidatorUtils {
  // Common validation messages
  static const String _requiredMessage = 'This field is required';
  static const String _invalidEmailMessage = 'Please enter a valid email';
  static const String _invalidPhoneMessage = 'Please enter a valid phone number';
  static const String _invalidNISNMessage = 'NISN must be 10 digits';
  static const String _invalidNIPMessage = 'NIP must be 18 digits';
  static const String _invalidNPSNMessage = 'NPSN must be 8 digits';
  static const String _passwordsNotMatchMessage = 'Passwords do not match';
  static const String _minLengthMessage = 'Must be at least {min} characters';
  static const String _maxLengthMessage = 'Must be at most {max} characters';
  static const String _minValueMessage = 'Must be at least {min}';
  static const String _maxValueMessage = 'Must be at most {max}';
  static const String _invalidDateMessage = 'Please enter a valid date';
  static const String _dateNotInFutureMessage = 'Date cannot be in the future';
  static const String _dateNotInPastMessage = 'Date cannot be in the past';
  static const String _invalidUrlMessage = 'Please enter a valid URL';
  static const String _invalidNumberMessage = 'Please enter a valid number';
  static const String _invalidIntegerMessage = 'Please enter a whole number';
  static const String _invalidDecimalMessage = 'Please enter a valid decimal number';
  static const String _invalidAlphabeticMessage = 'Only letters are allowed';
  static const String _invalidAlphanumericMessage = 'Only letters and numbers are allowed';
  static const String _invalidIndonesianPhoneMessage = 'Please enter a valid Indonesian phone number';

  // Required field validator
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? _requiredMessage;
    }
    return null;
  }

  // Email validator
  static String? email(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );
    return emailRegex.hasMatch(value) ? null : (message ?? _invalidEmailMessage);
  }

  // Phone number validator
  static String? phone(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 8 && digits.length <= 15
        ? null
        : (message ?? _invalidPhoneMessage);
  }

  // Indonesian phone number validator
  static String? indonesianPhone(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final regex = RegExp(r'^(\+?62|0)8[1-9][0-9]{6,9}$');
    return regex.hasMatch(digits)
        ? null
        : (message ?? _invalidIndonesianPhoneMessage);
  }

  // NISN (Nomor Induk Siswa Nasional) validator
  static String? nisn(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 10 ? null : (message ?? _invalidNISNMessage);
  }

  // NIP (Nomor Induk Pegawai) validator
  static String? nip(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 18 ? null : (message ?? _invalidNIPMessage);
  }

  // NPSN (Nomor Pokok Sekolah Nasional) validator
  static String? npsn(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 8 ? null : (message ?? _invalidNPSNMessage);
  }

  // Minimum length validator
  static String? minLength(String? value, int min, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return value.length >= min
        ? null
        : (message ?? _minLengthMessage.replaceAll('{min}', min.toString()));
  }

  // Maximum length validator
  static String? maxLength(String? value, int max, {String? message}) {
    if (value == null) return null;
    return value.length <= max
        ? null
        : (message ?? _maxLengthMessage.replaceAll('{max}', max.toString()));
  }

  // Minimum value validator
  static String? minValue(num? value, num min, {String? message}) {
    if (value == null) return null;
    return value >= min
        ? null
        : (message ?? _minValueMessage.replaceAll('{min}', min.toString()));
  }

  // Maximum value validator
  static String? maxValue(num? value, num max, {String? message}) {
    if (value == null) return null;
    return value <= max
        ? null
        : (message ?? _maxValueMessage.replaceAll('{max}', max.toString()));
  }

  // Password confirmation validator
  static String? confirmPassword(String? value, String? password, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return value == password ? null : (message ?? _passwordsNotMatchMessage);
  }

  // URL validator
  static String? url(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // protocol
      r'(([a-zA-Z\d]([a-zA-Z\d-]*[a-zA-Z\d])*)\.)+[a-zA-Z]{2,}' // domain
      r'(\/[-a-zA-Z\d%_.~+]*)*' // path
      r'(\?[;&a-zA-Z\d%_.~+=-]*)?' // query string
      r'(\#[-a-zA-Z_\d]*)?\$?', // fragment locator
      caseSensitive: false,
    );
    return urlRegex.hasMatch(value) ? null : (message ?? _invalidUrlMessage);
  }

  // Numeric validator
  static String? numeric(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value) != null ? null : (message ?? _invalidNumberMessage);
  }

  // Integer validator
  static String? integer(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value) != null ? null : (message ?? _invalidIntegerMessage);
  }

  // Decimal validator
  static String? decimal(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value) != null ? null : (message ?? _invalidDecimalMessage);
  }

  // Alphabetic validator
  static String? alphabetic(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final alphabeticRegex = RegExp(r'^[a-zA-Z\s]+$');
    return alphabeticRegex.hasMatch(value) ? null : (message ?? _invalidAlphabeticMessage);
  }

  // Alphanumeric validator
  static String? alphanumeric(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
    return alphanumericRegex.hasMatch(value)
        ? null
        : (message ?? _invalidAlphanumericMessage);
  }

  // Date validator
  static String? date(String? value, {String? format, String? message}) {
    if (value == null || value.isEmpty) return null;
    try {
      final dateFormat = DateFormat(format ?? 'dd/MM/yyyy');
      dateFormat.parseStrict(value);
      return null;
    } catch (e) {
      return message ?? _invalidDateMessage;
    }
  }

  // Date not in future validator
  static String? dateNotInFuture(String? value, {String? format, String? message}) {
    if (value == null || value.isEmpty) return null;
    try {
      final dateFormat = DateFormat(format ?? 'dd/MM/yyyy');
      final date = dateFormat.parseStrict(value);
      final now = DateTime.now();
      return date.isAfter(now) ? (message ?? _dateNotInFutureMessage) : null;
    } catch (e) {
      return message ?? _invalidDateMessage;
    }
  }

  // Date not in past validator
  static String? dateNotInPast(String? value, {String? format, String? message}) {
    if (value == null || value.isEmpty) return null;
    try {
      final dateFormat = DateFormat(format ?? 'dd/MM/yyyy');
      final date = dateFormat.parseStrict(value);
      final now = DateTime.now();
      return date.isBefore(now) ? (message ?? _dateNotInPastMessage) : null;
    } catch (e) {
      return message ?? _invalidDateMessage;
    }
  }

  // Combine multiple validators
  static String? validate(
    String? value, {
    List<String? Function(String?)> validators = const [],
  }) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  // Validate form with multiple fields
  static Map<String, String?> validateForm(
    Map<String, String> values, {
    required Map<String, List<String? Function(String?)>> validators,
  }) {
    final errors = <String, String?>{};
    
    validators.forEach((field, fieldValidators) {
      final value = values[field] ?? '';
      
      for (final validator in fieldValidators) {
        final error = validator(value);
        if (error != null) {
          errors[field] = error;
          break;
        }
      }
    });
    
    return errors;
  }
}

// Extension for TextFormField
extension ValidatorExtension on String? {
  String? validate(List<String? Function(String?)> validators) {
    return ValidatorUtils.validate(this, validators: validators);
  }
}
