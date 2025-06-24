class AppConfig {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://your-api-base-url.com/api',
  );
  
  // App Information
  static const String appName = 'SIM Java';
  static const String appVersion = '1.0.0';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // Cache
  static const Duration cacheTimeout = Duration(minutes: 5);
  
  // Logging
  static const bool enableLogging = true;
  
  // Debug Mode
  static const bool debugMode = true;
  
  // Private constructor to prevent instantiation
  AppConfig._();
}
