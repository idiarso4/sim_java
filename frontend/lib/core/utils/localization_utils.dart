import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationUtils {
  static final LocalizationUtils _instance = LocalizationUtils._internal();
  static late Map<String, dynamic> _localizedStrings;
  static Locale _locale = const Locale('id', 'ID'); // Default to Indonesian
  static bool _isInitialized = false;
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('id', 'ID'), // Indonesian
    Locale('en', 'US'), // English
  ];

  // Fallback locale
  static const Locale fallbackLocale = Locale('id', 'ID');

  // Stream controller for locale changes
  static final _localeController = StreamController<Locale>.broadcast();
  static Stream<Locale> get onLocaleChanged => _localeController.stream;

  factory LocalizationUtils() {
    return _instance;
  }

  LocalizationUtils._internal();

  // Initialize localization
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load last saved locale or use device locale
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code');
      final countryCode = prefs.getString('country_code');
      
      if (languageCode != null && countryCode != null) {
        _locale = Locale(languageCode, countryCode);
      } else {
        // Use device locale if supported, otherwise fallback
        final deviceLocale = WidgetsBinding.instance.window.locale;
        if (isLocaleSupported(deviceLocale)) {
          _locale = deviceLocale;
        }
      }
      
      // Load translations
      await _loadLocalizedStrings();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing localization: $e');
      // Fallback to default locale
      _locale = fallbackLocale;
      await _loadLocalizedStrings();
    }
  }

  // Load localized strings from JSON files
  static Future<void> _loadLocalizedStrings() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/translations/${_locale.languageCode}.json',
      );
      _localizedStrings = json.decode(jsonString);
    } catch (e) {
      debugPrint('Error loading localized strings: $e');
      // Fallback to default language
      if (_locale.languageCode != fallbackLocale.languageCode) {
        _locale = fallbackLocale;
        await _loadLocalizedStrings();
      } else {
        _localizedStrings = {};
      }
    }
  }

  // Get localized string
  static String translate(String key, {Map<String, dynamic>? args}) {
    if (!_isInitialized) {
      debugPrint('Localization not initialized');
      return key;
    }

    try {
      // Handle nested keys with dot notation (e.g., 'home.title')
      var result = _getNestedKey(_localizedStrings, key);
      
      if (result == null) {
        debugPrint('No translation found for key: $key');
        return key;
      }
      
      // Replace placeholders if args are provided
      if (args != null) {
        args.forEach((key, value) {
          result = result.replaceAll('{$key}', value.toString());
        });
      }
      
      return result;
    } catch (e) {
      debugPrint('Error translating key $key: $e');
      return key;
    }
  }

  // Helper method to get nested keys
  static String? _getNestedKey(Map<String, dynamic> map, String key) {
    final keys = key.split('.');
    dynamic result = map;
    
    for (final k in keys) {
      if (result is Map<String, dynamic> && result.containsKey(k)) {
        result = result[k];
      } else {
        return null;
      }
    }
    
    return result?.toString();
  }

  // Change app locale
  static Future<void> setLocale(Locale newLocale) async {
    if (!isLocaleSupported(newLocale)) {
      debugPrint('Locale $newLocale is not supported');
      return;
    }
    
    if (_locale.languageCode != newLocale.languageCode ||
        _locale.countryCode != newLocale.countryCode) {
      _locale = newLocale;
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', newLocale.languageCode);
      if (newLocale.countryCode != null) {
        await prefs.setString('country_code', newLocale.countryCode!);
      }
      
      // Reload translations
      await _loadLocalizedStrings();
      
      // Notify listeners
      _localeController.add(newLocale);
    }
  }

  // Get current locale
  static Locale get currentLocale => _locale;

  // Check if a locale is supported
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales.any((l) => 
      l.languageCode == locale.languageCode &&
      (l.countryCode == null || l.countryCode == locale.countryCode)
    );
  }

  // Get supported locales for MaterialApp
  static List<Locale> get supportedLocalesList => supportedLocales;

  // Get localized values for dropdowns
  static Map<String, String> getLocalizedMap(String key) {
    try {
      final map = _localizedStrings[key] as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      debugPrint('Error getting localized map for key $key: $e');
      return {};
    }
  }

  // Format number based on locale
  static String formatNumber(dynamic number, {int? decimalDigits}) {
    try {
      final formatted = number.toString();
      // This is a simple implementation. For full number formatting,
      // you might want to use the intl package
      return formatted;
    } catch (e) {
      debugPrint('Error formatting number: $e');
      return number.toString();
    }
  }

  // Format date based on locale
  static String formatDate(DateTime date, {String? format}) {
    // This is a simple implementation. For full date formatting,
    // you might want to use the intl package
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format currency based on locale
  static String formatCurrency(dynamic amount, {String? currencyCode}) {
    try {
      // This is a simple implementation. For full currency formatting,
      // you might want to use the intl package
      final currency = currencyCode ?? 'IDR';
      return '$currency ${amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      )}';
    } catch (e) {
      debugPrint('Error formatting currency: $e');
      return amount.toString();
    }
  }

  // Dispose resources
  static void dispose() {
    _localeController.close();
  }
}

// Extension for easy translation
extension StringExtension on String {
  String tr({Map<String, dynamic>? args}) {
    return LocalizationUtils.translate(this, args: args);
  }
}

// Usage example:
/*
// In MaterialApp
MaterialApp(
  locale: LocalizationUtils.currentLocale,
  supportedLocales: LocalizationUtils.supportedLocalesList,
  localizationsDelegates: [
    // Your delegates here
  ],
  // ...
);

// In your widgets
Text('welcome_message'.tr());
Text('greeting'.tr(args: {'name': 'John'}));

// Change language
await LocalizationUtils.setLocale(const Locale('en', 'US'));

// Listen to locale changes
StreamBuilder<Locale>(
  stream: LocalizationUtils.onLocaleChanged,
  builder: (context, snapshot) {
    // Rebuild your app when locale changes
    return YourWidget();
  },
);
*/
