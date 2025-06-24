import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light Theme Colors
  static const Color _primaryColor = Color(0xFF4F46E5); // Indigo-600
  static const Color _primaryVariant = Color(0xFF4338CA); // Indigo-700
  static const Color _secondaryColor = Color(0xFF10B981); // Emerald-500
  static const Color _secondaryVariant = Color(0xFF059669); // Emerald-600
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _surfaceColor = Color(0xFFF9FAFB);
  static const Color _errorColor = Color(0xFFEF4444); // Red-500
  static const Color _onPrimaryColor = Color(0xFFFFFFFF);
  static const Color _onSecondaryColor = Color(0xFFFFFFFF);
  static const Color _onBackgroundColor = Color(0xFF1F2937); // Gray-800
  static const Color _onSurfaceColor = Color(0xFF1F2937); // Gray-800
  static const Color _onErrorColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color _darkPrimaryColor = Color(0xFF6366F1); // Indigo-500
  static const Color _darkPrimaryVariant = Color(0xFF4F46E5); // Indigo-600
  static const Color _darkSecondaryColor = Color(0xFF10B981); // Emerald-500
  static const Color _darkSecondaryVariant = Color(0xFF059669); // Emerald-600
  static const Color _darkBackgroundColor = Color(0xFF111827); // Gray-900
  static const Color _darkSurfaceColor = Color(0xFF1F2937); // Gray-800
  static const Color _darkErrorColor = Color(0xFFF87171); // Red-400
  static const Color _darkOnPrimaryColor = Color(0xFFFFFFFF);
  static const Color _darkOnSecondaryColor = Color(0xFFFFFFFF);
  static const Color _darkOnBackgroundColor = Color(0xFFFFFFFF);
  static const Color _darkOnSurfaceColor = Color(0xFFFFFFFF);
  static const Color _darkOnErrorColor = Color(0xFF000000);

  // Text Themes
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      headline1: base.headline1!.copyWith(
        fontSize: 96.0,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: textColor,
      ),
      headline2: base.headline2!.copyWith(
        fontSize: 60.0,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: textColor,
      ),
      headline3: base.headline3!.copyWith(
        fontSize: 48.0,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headline4: base.headline4!.copyWith(
        fontSize: 34.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      headline5: base.headline5!.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headline6: base.headline6!.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textColor,
      ),
      subtitle1: base.subtitle1!.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: textColor,
      ),
      subtitle2: base.subtitle2!.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor,
      ),
      bodyText1: base.bodyText1!.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: textColor,
      ),
      bodyText2: base.bodyText2!.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      button: base.button!.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: textColor,
      ),
      caption: base.caption!.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textColor.withOpacity(0.6),
      ),
      overline: base.overline!.copyWith(
        fontSize: 10.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: textColor,
      ),
    );
  }

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: _primaryColor,
    primaryColorLight: _primaryVariant,
    primaryColorDark: _primaryVariant,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _primaryColor,
      primaryVariant: _primaryVariant,
      secondary: _secondaryColor,
      secondaryVariant: _secondaryVariant,
      surface: _surfaceColor,
      background: _backgroundColor,
      error: _errorColor,
      onPrimary: _onPrimaryColor,
      onSecondary: _onSecondaryColor,
      onSurface: _onSurfaceColor,
      onBackground: _onBackgroundColor,
      onError: _onErrorColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: _backgroundColor,
    appBarTheme: const AppBarTheme(
      color: _primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _onPrimaryColor),
      titleTextStyle: TextStyle(
        color: _onPrimaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: _buildTextTheme(ThemeData.light().textTheme, _onBackgroundColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _errorColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _errorColor, width: 2.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _primaryColor,
        onPrimary: _onPrimaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: _primaryColor,
        side: const BorderSide(color: _primaryColor, width: 1.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: _primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surfaceColor,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EB), // Gray-200
      thickness: 1.0,
      space: 1.0,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: _darkPrimaryColor,
    primaryColorLight: _darkPrimaryVariant,
    primaryColorDark: _darkPrimaryVariant,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _darkPrimaryColor,
      primaryVariant: _darkPrimaryVariant,
      secondary: _darkSecondaryColor,
      secondaryVariant: _darkSecondaryVariant,
      surface: _darkSurfaceColor,
      background: _darkBackgroundColor,
      error: _darkErrorColor,
      onPrimary: _darkOnPrimaryColor,
      onSecondary: _darkOnSecondaryColor,
      onSurface: _darkOnSurfaceColor,
      onBackground: _darkOnBackgroundColor,
      onError: _darkOnErrorColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      color: _darkSurfaceColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _darkOnSurfaceColor),
      titleTextStyle: TextStyle(
        color: _darkOnSurfaceColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: _buildTextTheme(ThemeData.dark().textTheme, _darkOnSurfaceColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _darkPrimaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _darkErrorColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: _darkErrorColor, width: 2.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _darkPrimaryColor,
        onPrimary: _darkOnPrimaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: _darkPrimaryColor,
        side: const BorderSide(color: _darkPrimaryColor, width: 1.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: _darkPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: _darkSurfaceColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _darkSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSurfaceColor,
      selectedItemColor: _darkPrimaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF374151), // Gray-700
      thickness: 1.0,
      space: 1.0,
    ),
  );
}
