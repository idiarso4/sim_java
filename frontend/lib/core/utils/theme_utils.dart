import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';

class ThemeUtils {
  // Get brightness from theme
  static Brightness getBrightness(BuildContext context) {
    return Theme.of(context).brightness;
  }

  // Check if dark mode is enabled
  static bool isDarkMode(BuildContext context) {
    return getBrightness(context) == Brightness.dark;
  }

  // Get text theme
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  // Get color scheme
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  // Get primary color
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  // Get accent color
  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  // Get background color
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  // Get card color
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  // Get text color based on background color
  static Color getTextColorForBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  // Get contrast color for text based on background color
  static Color getContrastTextColor(BuildContext context, Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  // Get disabled color
  static Color getDisabledColor(BuildContext context) {
    return Theme.of(context).disabledColor;
  }

  // Get divider color
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  // Get error color
  static Color getErrorColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  // Get success color
  static Color getSuccessColor(BuildContext context) {
    return Colors.green;
  }

  // Get warning color
  static Color getWarningColor(BuildContext context) {
    return Colors.orange;
  }

  // Get info color
  static Color getInfoColor(BuildContext context) {
    return Colors.blue;
  }

  // Get text color with opacity
  static Color getTextColorWithOpacity(
    BuildContext context, {
    double opacity = 0.7,
  }) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge!.color!.withOpacity(opacity);
  }

  // Get primary color with opacity
  static Color getPrimaryColorWithOpacity(
    BuildContext context, {
    double opacity = 0.7,
  }) {
    return Theme.of(context).primaryColor.withOpacity(opacity);
  }

  // Get card elevation based on theme
  static double getCardElevation(BuildContext context) {
    return isDarkMode(context) ? 4.0 : 2.0;
  }

  // Get app bar elevation based on theme
  static double getAppBarElevation(BuildContext context) {
    return isDarkMode(context) ? 0.0 : 2.0;
  }

  // Get border radius
  static BorderRadius getBorderRadius(BuildContext context) {
    return BorderRadius.circular(8.0);
  }

  // Get small border radius
  static BorderRadius getSmallBorderRadius(BuildContext context) {
    return BorderRadius.circular(4.0);
  }

  // Get medium border radius
  static BorderRadius getMediumBorderRadius(BuildContext context) {
    return BorderRadius.circular(8.0);
  }

  // Get large border radius
  static BorderRadius getLargeBorderRadius(BuildContext context) {
    return BorderRadius.circular(16.0);
  }

  // Get circular border radius
  static BorderRadius getCircularBorderRadius(BuildContext context) {
    return BorderRadius.circular(100.0);
  }

  // Get input border
  static InputBorder getInputBorder(
    BuildContext context, {
    Color? borderColor,
    double width = 1.0,
    double radius = 8.0,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? Theme.of(context).dividerColor,
        width: width,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // Get enabled input border
  static InputBorder getEnabledBorder(
    BuildContext context, {
    Color? borderColor,
    double width = 1.0,
    double radius = 8.0,
  }) {
    return getInputBorder(
      context,
      borderColor: borderColor ?? Theme.of(context).dividerColor,
      width: width,
      radius: radius,
    );
  }

  // Get focused input border
  static InputBorder getFocusedBorder(
    BuildContext context, {
    Color? borderColor,
    double width = 2.0,
    double radius = 8.0,
  }) {
    return getInputBorder(
      context,
      borderColor: borderColor ?? Theme.of(context).primaryColor,
      width: width,
      radius: radius,
    );
  }

  // Get error input border
  static InputBorder getErrorBorder(
    BuildContext context, {
    Color? borderColor,
    double width = 2.0,
    double radius = 8.0,
  }) {
    return getInputBorder(
      context,
      borderColor: borderColor ?? Theme.of(context).colorScheme.error,
      width: width,
      radius: radius,
    );
  }

  // Get input decoration
  static InputDecoration getInputDecoration(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    bool filled = false,
    EdgeInsetsGeometry? contentPadding,
    BorderRadius? borderRadius,
    Color? borderColor,
    double borderWidth = 1.0,
  }) {
    final isDark = isDarkMode(context);
    
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: fillColor ?? (isDark ? Colors.grey[900] : Colors.grey[100]),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: borderRadius ?? getBorderRadius(context),
        borderSide: BorderSide(
          color: borderColor ?? (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          width: borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? getBorderRadius(context),
        borderSide: BorderSide(
          color: borderColor ?? (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          width: borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? getBorderRadius(context),
        borderSide: BorderSide(
          color: borderColor ?? Theme.of(context).primaryColor,
          width: borderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? getBorderRadius(context),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? getBorderRadius(context),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: borderWidth,
        ),
      ),
    );
  }

  // Get button style
  static ButtonStyle getButtonStyle(
    BuildContext context, {
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    BorderSide? side,
    double? borderRadius,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: minimumSize ?? const Size(64, 48),
      side: side,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
      ),
    );
  }

  // Get outlined button style
  static ButtonStyle getOutlinedButtonStyle(
    BuildContext context, {
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    double? borderRadius,
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? Theme.of(context).primaryColor,
      side: BorderSide(
        color: borderColor ?? Theme.of(context).primaryColor,
        width: borderWidth ?? 1.0,
      ),
      elevation: elevation ?? 0,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      minimumSize: minimumSize ?? const Size(64, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
      ),
    );
  }

  // Get text button style
  static ButtonStyle getTextButtonStyle(
    BuildContext context, {
    Color? foregroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    double? borderRadius,
  }) {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? Theme.of(context).primaryColor,
      elevation: elevation ?? 0,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      minimumSize: minimumSize ?? const Size(64, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
      ),
    );
  }

  // Get card theme
  static CardTheme getCardTheme(BuildContext context) {
    return CardTheme(
      elevation: getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: getBorderRadius(context),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8.0),
    );
  }

  // Get app bar theme
  static AppBarTheme getAppBarTheme(BuildContext context) {
    return AppBarTheme(
      elevation: getAppBarElevation(context),
      centerTitle: true,
      titleSpacing: 0.0,
      scrolledUnderElevation: 0.0,
    );
  }

  // Get bottom navigation bar theme
  static BottomNavigationBarThemeData getBottomNavigationBarTheme(
    BuildContext context,
  ) {
    return BottomNavigationBarThemeData(
      elevation: 8.0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
    );
  }

  // Get dialog theme
  static DialogTheme getDialogTheme(BuildContext context) {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: getBorderRadius(context),
      ),
      elevation: 4.0,
    );
  }

  // Get snack bar theme
  static SnackBarThemeData getSnackBarTheme(BuildContext context) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: getBorderRadius(context),
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium,
    );
  }

  // Get tooltip theme
  static TooltipThemeData getTooltipTheme(BuildContext context) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: getSmallBorderRadius(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.white,
      ),
    );
  }

  // Get chip theme
  static ChipThemeData getChipTheme(BuildContext context) {
    return ChipThemeData(
      backgroundColor: Colors.transparent,
      disabledColor: Colors.grey[300],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
      secondarySelectedColor: Theme.of(context).primaryColor,
      padding: EdgeInsets.zero,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      secondaryLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.white,
      ),
      brightness: Theme.of(context).brightness,
    );
  }

  // Get divider theme
  static DividerThemeData getDividerTheme(BuildContext context) {
    return DividerThemeData(
      color: Theme.of(context).dividerColor,
      thickness: 1.0,
      space: 1.0,
    );
  }
}
