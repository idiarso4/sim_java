import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';

class SnackbarUtils {
  // Show a basic snackbar
  static void showBasic({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    EdgeInsetsGeometry? margin,
    double? width,
    ShapeBorder? shape,
    bool showCloseIcon = true,
    Color? closeIconColor,
  }) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        duration: duration,
        behavior: behavior ?? SnackBarBehavior.fixed,
        margin: margin,
        width: width,
        shape: shape,
        showCloseIcon: showCloseIcon,
        closeIconColor: closeIconColor,
      ),
    );
  }

  // Show a success snackbar
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    String actionLabel = 'OK',
    VoidCallback? onActionPressed,
  }) {
    _showColoredSnackbar(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.primary,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // Show an error snackbar
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 6),
    String actionLabel = 'DISMISS',
    VoidCallback? onActionPressed,
  }) {
    _showColoredSnackbar(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // Show a warning snackbar
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    String actionLabel = 'OK',
    VoidCallback? onActionPressed,
  }) {
    _showColoredSnackbar(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.8),
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // Show an info snackbar
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    String actionLabel = 'GOT IT',
    VoidCallback? onActionPressed,
  }) {
    _showColoredSnackbar(
      context: context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // Show a floating snackbar
  static void showFloating({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    bool showCloseIcon = true,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? theme.colorScheme.onSurface,
                size: iconSize ?? 24.0,
              ),
              const SizedBox(width: 12.0),
            ],
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor ??
            (isDark ? Colors.grey[800] : Colors.grey[900]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        showCloseIcon: showCloseIcon,
        closeIconColor: theme.colorScheme.onSurface,
      ),
    );
  }

  // Show a custom snackbar with action
  static void showCustom({
    required BuildContext context,
    required Widget content,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    DismissDirection dismissDirection = DismissDirection.down,
    Clip clipBehavior = Clip.hardEdge,
    bool showCloseIcon = true,
    Color? closeIconColor,
    void Function()? onVisible,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        duration: duration,
        backgroundColor: backgroundColor,
        elevation: elevation,
        margin: margin,
        padding: padding,
        width: width,
        shape: shape,
        behavior: behavior,
        dismissDirection: dismissDirection,
        clipBehavior: clipBehavior,
        showCloseIcon: showCloseIcon,
        closeIconColor: closeIconColor,
        onVisible: onVisible,
      ),
    );
  }

  // Clear current snackbar
  static void clearSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  // Show a snackbar with a button
  static void showWithAction({
    required BuildContext context,
    required String message,
    required String actionLabel,
    required VoidCallback onPressed,
    Duration duration = const Duration(seconds: 6),
    Color? backgroundColor,
    Color? actionTextColor,
  }) {
    final theme = Theme.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? theme.snackBarTheme.backgroundColor,
        action: SnackBarAction(
          label: actionLabel,
          textColor: actionTextColor ?? theme.colorScheme.secondary,
          onPressed: onPressed,
        ),
      ),
    );
  }

  // Show a loading snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 10),
    bool showProgressIndicator = true,
  }) {
    final theme = Theme.of(context);
    
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showProgressIndicator) ...[
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16.0),
            ],
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        duration: duration,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: theme.colorScheme.surface,
        elevation: 4.0,
      ),
    );
  }

  // Show a custom icon snackbar
  static void showWithIcon({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color? iconColor,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? theme.colorScheme.onSurface,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        duration: duration,
        backgroundColor: backgroundColor ?? theme.snackBarTheme.backgroundColor,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  // Private helper method for colored snackbars
  static void _showColoredSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Duration duration,
    required String actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final theme = Theme.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: SnackBarAction(
          label: actionLabel,
          textColor: theme.colorScheme.onPrimary,
          onPressed: onActionPressed ?? () {},
        ),
      ),
    );
  }
}

// Extension for BuildContext
extension SnackbarExtension on BuildContext {
  // Show a success snackbar
  void showSuccessSnackBar(String message, {Duration? duration}) {
    SnackbarUtils.showSuccess(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  // Show an error snackbar
  void showErrorSnackBar(String message, {Duration? duration}) {
    SnackbarUtils.showError(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 6),
    );
  }

  // Show a warning snackbar
  void showWarningSnackBar(String message, {Duration? duration}) {
    SnackbarUtils.showWarning(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 5),
    );
  }

  // Show an info snackbar
  void showInfoSnackBar(String message, {Duration? duration}) {
    SnackbarUtils.showInfo(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  // Show a loading snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoadingSnackBar(
    String message, {
    Duration? duration,
    bool showProgressIndicator = true,
  }) {
    return SnackbarUtils.showLoading(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 10),
      showProgressIndicator: showProgressIndicator,
    );
  }

  // Clear all snackbars
  void clearSnackBars() {
    SnackbarUtils.clearSnackBars(this);
  }
}
