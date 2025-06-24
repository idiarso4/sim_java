import 'package:sim_java_frontend/core/constants/strings.dart';

class FormValidator {
  // Required field validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '${AppStrings.requiredField} $fieldName' 
          : AppStrings.requiredField;
    }
    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}'
    );
    
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < 8) {
      return AppStrings.passwordMinLength(8);
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.passwordUppercase;
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppStrings.passwordLowercase;
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppStrings.passwordNumber;
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.passwordSpecialChar;
    }
    
    return null;
  }

  // Confirm password validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return null;
    if (password == null || password.isEmpty) return null;
    
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    
    return null;
  }

  // Phone number validator
  static String? phoneNumber(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    // Basic phone number validation (adjust regex as needed)
    final phoneRegex = RegExp(r'^[0-9+\-\s()]{8,20}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return AppStrings.invalidPhoneNumber;
    }
    
    return null;
  }

  // Numeric validator
  static String? numeric(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    if (double.tryParse(value) == null) {
      return AppStrings.invalidNumber;
    }
    
    return null;
  }

  
  // Integer validator
  static String? integer(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    if (int.tryParse(value) == null) {
      return AppStrings.invalidInteger;
    }
    
    return null;
  }
  
  // Minimum length validator
  static String? minLength(String? value, int minLength) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < minLength) {
      return '${AppStrings.minLength} $minLength ${AppStrings.characters}';
    }
    
    return null;
  }
  
  // Maximum length validator
  static String? maxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length > maxLength) {
      return '${AppStrings.maxLength} $maxLength ${AppStrings.characters}';
    }
    
    return null;
  }
  
  // Range validator for numbers
  static String? range(
    String? value, {
    required num min,
    required num max,
    bool isRequired = false,
  }) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    final number = num.tryParse(value);
    if (number == null) {
      return AppStrings.invalidNumber;
    }
    
    if (number < min || number > max) {
      return '${AppStrings.mustBeBetween} $min ${AppStrings.and} $max';
    }
    
    return null;
  }
  
  // URL validator
  static String? url(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // http:// or https://
      r'(([a-zA-Z\d]([a-zA-Z\d-]*[a-zA-Z\d])*)\.)+[a-zA-Z]{2,}' // domain
      r'(\/[-a-zA-Z\d%_.~+]*)*' // path
      r'(\?[;&a-zA-Z\d%_.~+=-]*)?' // query string
      r'(\#[-a-zA-Z_\d]*)?$' // fragment
    );
    
    if (!urlRegex.hasMatch(value)) {
      return AppStrings.invalidUrl;
    }
    
    return null;
  }
  
  // Date validator (YYYY-MM-DD format)
  static String? date(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return AppStrings.invalidDate;
    }
  }
  
  // Time validator (HH:MM format)
  static String? time(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]');
    
    if (!timeRegex.hasMatch(value)) {
      return AppStrings.invalidTime;
    }
    
    return null;
  }
  
  // Credit card number validator (basic)
  static String? creditCard(String? value, {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    
    // Remove all non-digit characters
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Check if it's a valid credit card number using Luhn algorithm
    if (digits.length < 13 || digits.length > 19) {
      return AppStrings.invalidCreditCardNumber;
    }
    
    int sum = 0;
    bool isSecond = false;
    
    for (int i = digits.length - 1; i >= 0; i--) {
      int digit = int.parse(digits[i]);
      
      if (isSecond) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit ~/ 10) + (digit % 10);
        }
      }
      
      sum += digit;
      isSecond = !isSecond;
    }
    
    if (sum % 10 != 0) {
      return AppStrings.invalidCreditCardNumber;
    }
    
    return null;
  }
  
  // Combine multiple validators
  static String? validate(
    String? value, 
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
