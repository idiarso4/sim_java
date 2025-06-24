import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sim_java_frontend/core/utils/localization_utils.dart';

class FormUtils {
  // Common form validators
  static String? Function(String?)? get requiredValidator => (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      };

  static String? Function(String?)? get emailValidator => (value) {
        if (value == null || value.isEmpty) return null;
        final emailRegex = RegExp(
            r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      };

  static String? Function(String?)? get phoneValidator => (value) {
        if (value == null || value.isEmpty) return null;
        final phoneRegex = RegExp(r'^[0-9+\-\s()]{10,20}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      };

  static String? Function(String?)? get nisnValidator => (value) {
        if (value == null || value.isEmpty) return 'NISN is required';
        if (value.length != 10) return 'NISN must be 10 digits';
        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'NISN must contain only numbers';
        }
        return null;
      };

  static String? Function(String?)? get nipValidator => (value) {
        if (value == null || value.isEmpty) return 'NIP is required';
        if (value.length < 18) return 'NIP must be at least 18 digits';
        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'NIP must contain only numbers';
        }
        return null;
      };

  static String? Function(String?)? get npsnValidator => (value) {
        if (value == null || value.isEmpty) return 'NPSN is required';
        if (value.length != 8) return 'NPSN must be 8 digits';
        if (!RegExp(r'^\d{8}$').hasMatch(value)) {
          return 'NPSN must contain only numbers';
        }
        return null;
      };

  static String? Function(String?, int) minLengthValidator = (value, length) {
    if (value == null || value.isEmpty) return null;
    if (value.length < length) {
      return 'Must be at least $length characters';
    }
    return null;
  };

  static String? Function(String?, int) maxLengthValidator = (value, length) {
    if (value == null || value.isEmpty) return null;
    if (value.length > length) {
      return 'Cannot exceed $length characters';
    }
    return null;
  };

  static String? Function(String?, String) confirmPasswordValidator = 
      (value, password) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  };

  // Input formatters
  static TextInputFormatter get alphanumericFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));

  static TextInputFormatter get numericFormatter =>
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter get alphabeticFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

  static TextInputFormatter get emailFormatter =>
      FilteringTextInputFormatter.allow(RegExp(
          r'[a-zA-Z0-9.@!#$%&*+\/=?^_`{|}~-]'));

  static TextInputFormatter get phoneFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]'));

  static TextInputFormatter get nisnFormatter =>
      LengthLimitingTextInputFormatter(10);

  static TextInputFormatter get nipFormatter =>
      LengthLimitingTextInputFormatter(18);

  static TextInputFormatter get npsnFormatter =>
      LengthLimitingTextInputFormatter(8);

  // Formatting functions
  static String formatCurrency(dynamic value, {String symbol = 'Rp '}) {
    if (value == null) return '';
    final number = value is num ? value : double.tryParse(value.toString()) ?? 0;
    return '$symbol${NumberFormat('#,##0', 'id_ID').format(number)}';
  }

  static String formatDate(DateTime? date, {String format = 'dd/MM/yyyy'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime? dateTime, 
      {String format = 'dd/MM/yyyy HH:mm'}) {
    if (dateTime == null) return '';
    return DateFormat(format).format(dateTime);
  }

  static String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Parsing functions
  static DateTime? parseDate(String? dateString, {String format = 'dd/MM/yyyy'}) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static TimeOfDay? parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Validation helpers
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9.!#$%&*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{10,20}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return fieldName != null 
          ? '$fieldName must contain only numbers' 
          : 'Must contain only numbers';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < minLength) {
      return fieldName != null
          ? '$fieldName must be at least $minLength characters'
          : 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) return null;
    if (value.length > maxLength) {
      return fieldName != null
          ? '$fieldName cannot exceed $maxLength characters'
          : 'Cannot exceed $maxLength characters';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? validateDate(DateTime? date, {String? fieldName}) {
    if (date == null) {
      return fieldName != null 
          ? 'Please select a $fieldName' 
          : 'Please select a date';
    }
    return null;
  }

  static String? validateTime(TimeOfDay? time, {String? fieldName}) {
    if (time == null) {
      return fieldName != null 
          ? 'Please select a $fieldName' 
          : 'Please select a time';
    }
    return null;
  }

  // Form field decoration
  static InputDecoration inputDecoration({
    required BuildContext context,
    required String label,
    String? hint,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isRequired = false,
    bool isDense = true,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    double borderRadius = 8.0,
    Color? borderColor,
    double borderWidth = 1.0,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InputDecoration(
      labelText: isRequired ? '$label *' : label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: isDense,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: fillColor ?? colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor ?? colorScheme.outline,
          width: borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor ?? colorScheme.outline,
          width: borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: borderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: borderWidth,
        ),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.error,
      ),
      errorMaxLines: 2,
    );
  }

  // Helper to combine multiple validators
  static String? Function(String?)? combineValidators(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // Format NISN with proper formatting (e.g., 1234567890 -> 1234 5678 90)
  static String formatNisn(String nisn) {
    if (nisn.isEmpty) return '';
    final buffer = StringBuffer();
    for (int i = 0; i < nisn.length; i++) {
      buffer.write(nisn[i]);
      if ((i + 1) % 4 == 0 && i != nisn.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  // Format NIP with proper formatting (e.g., 123456789012345678 -> 12 3456 7890 1234 5678)
  static String formatNip(String nip) {
    if (nip.isEmpty) return '';
    final buffer = StringBuffer();
    for (int i = 0; i < nip.length; i++) {
      buffer.write(nip[i]);
      if ((i == 1 || i == 7 || i == 15) && i != nip.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  // Format NPSN with proper formatting (e.g., 12345678 -> 1234 5678)
  static String formatNpsn(String npsn) {
    if (npsn.isEmpty) return '';
    if (npsn.length <= 4) return npsn;
    return '${npsn.substring(0, 4)} ${npsn.substring(4)}';
  }
}
