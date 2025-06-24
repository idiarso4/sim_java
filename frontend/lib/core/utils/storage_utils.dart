import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static final StorageUtils _instance = StorageUtils._internal();
  factory StorageUtils() => _instance;
  StorageUtils._internal();

  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userDataKey = 'user_data';
  static const String _appSettingsKey = 'app_settings';
  
  late final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage Methods (for sensitive data)
  
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: _authTokenKey);
    } catch (e) {
      debugPrint('Error getting auth token: $e');
      return null;
    }
  }

  Future<void> setAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
    } catch (e) {
      debugPrint('Error setting auth token: $e');
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      debugPrint('Error getting refresh token: $e');
      return null;
    }
  }

  Future<void> setRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      debugPrint('Error setting refresh token: $e');
      rethrow;
    }
  }

  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: _userIdKey);
    } catch (e) {
      debugPrint('Error getting user ID: $e');
      return null;
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _secureStorage.write(key: _userIdKey, value: userId);
    } catch (e) {
      debugPrint('Error setting user ID: $e');
      rethrow;
    }
  }

  // Regular SharedPreferences Methods (for non-sensitive data)
  
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Object serialization/deserialization
  Future<bool> setObject<T>(String key, T value) async {
    try {
      final json = jsonEncode(value);
      return await _prefs.setString(key, json);
    } catch (e) {
      debugPrint('Error saving object: $e');
      return false;
    }
  }

  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final json = _prefs.getString(key);
      if (json == null) return null;
      return fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting object: $e');
      return null;
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    try {
      await _prefs.clear();
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('Error clearing storage: $e');
      rethrow;
    }
  }

  // Clear secure storage only
  Future<void> clearSecureStorage() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('Error clearing secure storage: $e');
      rethrow;
    }
  }

  // Clear shared preferences only
  Future<void> clearSharedPreferences() async {
    try {
      await _prefs.clear();
    } catch (e) {
      debugPrint('Error clearing shared preferences: $e');
      rethrow;
    }
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Remove a specific key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // Save file to storage
  Future<bool> saveFile(String key, Uint8List bytes) async {
    try {
      final base64 = base64Encode(bytes);
      return await _prefs.setString(key, base64);
    } catch (e) {
      debugPrint('Error saving file: $e');
      return false;
    }
  }

  // Get file from storage
  Uint8List? getFile(String key) {
    try {
      final base64 = _prefs.getString(key);
      if (base64 == null) return null;
      return base64Decode(base64);
    } catch (e) {
      debugPrint('Error getting file: $e');
      return null;
    }
  }

  // User data methods
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final json = jsonEncode(userData);
      return await _prefs.setString(_userDataKey, json);
    } catch (e) {
      debugPrint('Error saving user data: $e');
      return false;
    }
  }

  Map<String, dynamic>? getUserData() {
    try {
      final json = _prefs.getString(_userDataKey);
      if (json == null) return null;
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // App settings methods
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      final json = jsonEncode(settings);
      return await _prefs.setString(_appSettingsKey, json);
    } catch (e) {
      debugPrint('Error saving app settings: $e');
      return false;
    }
  }

  Map<String, dynamic>? getAppSettings() {
    try {
      final json = _prefs.getString(_appSettingsKey);
      if (json == null) return null;
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error getting app settings: $e');
      return null;
    }
  }

  // Clear user session (keep app settings)
  Future<void> clearUserSession() async {
    try {
      await _secureStorage.delete(key: _authTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _userIdKey);
      await _prefs.remove(_userDataKey);
    } catch (e) {
      debugPrint('Error clearing user session: $e');
      rethrow;
    }
  }
}
