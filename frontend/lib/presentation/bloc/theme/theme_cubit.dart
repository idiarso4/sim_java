import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_java_frontend/core/constants/strings.dart';
import 'package:sim_java_frontend/core/utils/logger.dart';
import 'package:sim_java_frontend/presentation/bloc/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(ThemeState.initial());

  // Factory constructor to initialize with SharedPreferences
  static Future<ThemeCubit> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeCubit(prefs: prefs);
  }

  // Initialize theme from shared preferences
  Future<void> initialize() async {
    try {
      final themeIndex = _prefs.getInt(_themeKey) ?? AppTheme.system.index;
      final appTheme = AppTheme.values[themeIndex];
      
      ThemeMode themeMode;
      switch (appTheme) {
        case AppTheme.light:
          themeMode = ThemeMode.light;
          break;
        case AppTheme.dark:
          themeMode = ThemeMode.dark;
          break;
        case AppTheme.system:
        default:
          themeMode = ThemeMode.system;
      }
      
      emit(state.copyWith(
        themeMode: themeMode,
        appTheme: appTheme,
      ));
    } catch (e) {
      AppLogger.e('Error initializing theme', e);
      emit(state);
    }
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    try {
      final newAppTheme = state.appTheme == AppTheme.light 
          ? AppTheme.dark 
          : AppTheme.light;
      
      await _saveTheme(newAppTheme);
      
      final newThemeMode = newAppTheme == AppTheme.light 
          ? ThemeMode.light 
          : ThemeMode.dark;
      
      emit(state.copyWith(
        themeMode: newThemeMode,
        appTheme: newAppTheme,
      ));
    } catch (e) {
      AppLogger.e('Error toggling theme', e);
    }
  }

  // Set theme based on system settings
  Future<void> setSystemTheme() async {
    try {
      await _saveTheme(AppTheme.system);
      emit(state.copyWith(
        themeMode: ThemeMode.system,
        appTheme: AppTheme.system,
      ));
    } catch (e) {
      AppLogger.e('Error setting system theme', e);
    }
  }

  // Set light theme
  Future<void> setLightTheme() async {
    try {
      await _saveTheme(AppTheme.light);
      emit(state.copyWith(
        themeMode: ThemeMode.light,
        appTheme: AppTheme.light,
      ));
    } catch (e) {
      AppLogger.e('Error setting light theme', e);
    }
  }

  // Set dark theme
  Future<void> setDarkTheme() async {
    try {
      await _saveTheme(AppTheme.dark);
      emit(state.copyWith(
        themeMode: ThemeMode.dark,
        appTheme: AppTheme.dark,
      ));
    } catch (e) {
      AppLogger.e('Error setting dark theme', e);
    }
  }

  // Save theme preference to shared preferences
  Future<void> _saveTheme(AppTheme theme) async {
    try {
      await _prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      AppLogger.e('Error saving theme preference', e);
      rethrow;
    }
  }

  // Get current theme mode
  ThemeMode get themeMode => state.themeMode;
  
  // Get current app theme
  AppTheme get appTheme => state.appTheme;
  
  // Check if dark mode is enabled
  bool get isDarkMode => state.themeMode == ThemeMode.dark;
  
  // Check if system theme is used
  bool get isSystemTheme => state.appTheme == AppTheme.system;
}
