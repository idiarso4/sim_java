import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppTheme { light, dark, system }

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final AppTheme appTheme;

  const ThemeState({
    required this.themeMode,
    required this.appTheme,
  });

  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeMode.system,
      appTheme: AppTheme.system,
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    AppTheme? appTheme,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  List<Object> get props => [themeMode, appTheme];
}
