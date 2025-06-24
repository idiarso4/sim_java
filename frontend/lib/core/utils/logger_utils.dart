import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A utility class for application-wide logging
class LoggerUtils {
  static final LoggerUtils _instance = LoggerUtils._internal();
  static Logger? _logger;
  static bool _isInitialized = false;
  static bool _enableLogging = true;
  static bool _enableFileLogging = false;
  static LogLevel _minLogLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  factory LoggerUtils() {
    if (!_isInitialized) {
      _instance._init();
    }
    return _instance;
  }

  LoggerUtils._internal();

  void _init() {
    if (_isInitialized) return;

    _logger = Logger(
      level: _minLogLevel,
      printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to be shown
        errorMethodCount: 5, // Number of method calls if stacktrace is provided
        lineLength: 80, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true, // Include time in log messages
      ),
    );

    _isInitialized = true;
  }

  /// Enable or disable logging
  static void enableLogging(bool enable) {
    _enableLogging = enable;
  }

  /// Enable or disable file logging
  static void enableFileLogging(bool enable) {
    _enableFileLogging = enable;
    // TODO: Implement file logging
  }

  /// Set the minimum log level
  static void setMinLogLevel(LogLevel level) {
    _minLogLevel = level;
    _logger?.level = level;
  }

  // Log a message at level [Level.verbose].
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.verbose, message, error, stackTrace);
  }

  // Log a message at level [Level.debug].
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  // Log a message at level [Level.info].
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  // Log a message at level [Level.warning].
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  // Log a message at level [Level.error].
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  // Log a message at level [Level.wtf] (What a Terrible Failure).
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.wtf, message, error, stackTrace);
  }

  // Log JSON data with pretty formatting
  static void json(String jsonString, {String? tag}) {
    if (!_enableLogging) return;
    
    try {
      // Simple JSON formatting (for demonstration)
      // In a real app, you might want to use a proper JSON formatter
      final prettyJson = JsonEncoder.withIndent('  ').convert(jsonString);
      _log(LogLevel.debug, '${tag != null ? '$tag: ' : ''}JSON: $prettyJson');
    } catch (e) {
      _log(LogLevel.error, 'Failed to parse JSON: $e');
    }
  }

  // Log network request
  static void request({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) {
    if (!_enableLogging) return;

    final buffer = StringBuffer();
    buffer.writeln('🌐 $method $url');
    
    if (queryParameters != null && queryParameters.isNotEmpty) {
      buffer.writeln('📋 Query Parameters:');
      queryParameters.forEach((key, value) {
        buffer.writeln('   $key: $value');
      });
    }
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('📋 Headers:');
      headers.forEach((key, value) {
        buffer.writeln('   $key: $value');
      });
    }
    
    if (body != null) {
      buffer.writeln('📦 Body:');
      if (body is Map || body is List) {
        buffer.writeln(body);
      } else {
        buffer.writeln(body.toString());
      }
    }
    
    _log(LogLevel.debug, buffer.toString());
  }

  // Log network response
  static void response({
    required String method,
    required String url,
    required int statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    int? contentLength,
    bool isRedirect = false,
  }) {
    if (!_enableLogging) return;

    final buffer = StringBuffer();
    final statusEmoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    buffer.writeln('$statusEmoji $method $url - $statusCode');
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('📋 Headers:');
      headers.forEach((key, value) {
        buffer.writeln('   $key: $value');
      });
    }
    
    if (contentLength != null) {
      buffer.writeln('📏 Content Length: $contentLength bytes');
    }
    
    if (body != null) {
      buffer.writeln('📦 Response Body:');
      if (body is Map || body is List) {
        buffer.writeln(body);
      } else {
        buffer.writeln(body.toString());
      }
    }
    
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.debug;
    _log(level, buffer.toString());
  }

  // Log an exception with stack trace
  static void exception(dynamic error, [StackTrace? stackTrace]) {
    if (!_enableLogging) return;
    
    final buffer = StringBuffer();
    buffer.writeln('❌ EXCEPTION: $error');
    
    if (stackTrace != null) {
      buffer.writeln('Stack Trace:');
      buffer.writeln(stackTrace.toString());
    }
    
    _log(LogLevel.error, buffer.toString(), error, stackTrace);
  }

  // Internal log method
  static void _log(
    LogLevel level,
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (!_enableLogging) return;
    
    // Skip if log level is below minimum
    if (level.index < _minLogLevel.index) return;
    
    final messageStr = message?.toString() ?? 'null';
    
    // Log to console in debug mode
    if (kDebugMode) {
      switch (level) {
        case LogLevel.verbose:
          developer.log('🔍 VERBOSE: $messageStr',
              time: DateTime.now(),
              level: 0,
              name: 'LoggerUtils',
              error: error,
              stackTrace: stackTrace);
          break;
        case LogLevel.debug:
          developer.log('🐛 DEBUG: $messageStr',
              time: DateTime.now(),
              level: 1000,
              name: 'LoggerUtils',
              error: error,
              stackTrace: stackTrace);
          break;
        case LogLevel.info:
          developer.log('ℹ️ INFO: $messageStr',
              time: DateTime.now(),
              level: 2000,
              name: 'LoggerUtils',
              error: error,
              stackTrace: stackTrace);
          break;
        case LogLevel.warning:
          developer.log('⚠️ WARNING: $messageStr',
              time: DateTime.now(),
              level: 3000,
              name: 'LoggerUtils',
              error: error,
              stackTrace: stackTrace);
          break;
        case LogLevel.error:
          developer.log('❌ ERROR: $messageStr',
              time: DateTime.now(),
              level: 4000,
              name: 'LoggerUtils',
              error: error,
              stackTrace: stackTrace);
          break;
        case LogLevel.wtf:
          developer.log('👾 WTF: $messageStr',
              time: DateTime.now(),
              level: 5000,
              name: 'LoggerUtils',
              error: error,
              stackTrace: stackTrace);
          break;
      }
    }
    
    // Log using the logger package
    if (_logger != null) {
      switch (level) {
        case LogLevel.verbose:
          _logger!.v(message, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.debug:
          _logger!.d(message, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.info:
          _logger!.i(message, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.warning:
          _logger!.w(message, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.error:
          _logger!.e(message, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.wtf:
          _logger!.wtf(message, error: error, stackTrace: stackTrace);
          break;
      }
    }
    
    // TODO: Implement file logging if enabled
    if (_enableFileLogging) {
      // Implement file logging here
    }
  }
}

// Log levels
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
}

// Extension for easy logging on any object
extension ObjectLogger on Object {
  void logV([String? message]) =>
      LoggerUtils.v(message ?? toString());

  void logD([String? message]) =>
      LoggerUtils.d(message ?? toString());

  void logI([String? message]) =>
      LoggerUtils.i(message ?? toString());

  void logW([String? message]) =>
      LoggerUtils.w(message ?? toString());

  void logE([String? message, dynamic error, StackTrace? stackTrace]) =>
      LoggerUtils.e(message ?? toString(), error, stackTrace);

  void logWtf([String? message]) =>
      LoggerUtils.wtf(message ?? toString());

  void logJson({String? tag}) =>
      LoggerUtils.json(toString(), tag: tag);
}

// Extension for BuildContext to easily access logger
extension LoggerExtension on BuildContext {
  void logV(dynamic message) => LoggerUtils.v(message);
  void logD(dynamic message) => LoggerUtils.d(message);
  void logI(dynamic message) => LoggerUtils.i(message);
  void logW(dynamic message) => LoggerUtils.w(message);
  void logE(dynamic message, [dynamic error, StackTrace? stackTrace]) => 
      LoggerUtils.e(message, error, stackTrace);
  void logWtf(dynamic message) => LoggerUtils.wtf(message);
  void logJson(String jsonString, {String? tag}) => 
      LoggerUtils.json(jsonString, tag: tag);
  void logException(dynamic error, [StackTrace? stackTrace]) => 
      LoggerUtils.exception(error, stackTrace);
}
