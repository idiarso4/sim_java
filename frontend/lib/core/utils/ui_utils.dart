import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/core/utils/localization_utils.dart';

class UIUtils {
  // Show a snackbar
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    String? actionLabel,
    VoidCallback? onActionPressed,
    SnackBarBehavior? behavior,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    double? width,
    DismissDirection dismissDirection = DismissDirection.down,
    bool showCloseIcon = false,
  }) {
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Hide any current snackbar
    scaffoldMessenger.hideCurrentSnackBar();
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor ?? theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: backgroundColor ?? theme.colorScheme.surface,
        duration: duration,
        behavior: behavior ?? SnackBarBehavior.fixed,
        elevation: elevation,
        shape: shape,
        margin: margin,
        width: width,
        dismissDirection: dismissDirection,
        showCloseIcon: showCloseIcon,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: theme.colorScheme.secondary,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }

  // Show error snackbar
  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final theme = Theme.of(context);
    showSnackBar(
      context: context,
      message: message,
      backgroundColor: theme.colorScheme.error,
      textColor: theme.colorScheme.onError,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final theme = Theme.of(context);
    showSnackBar(
      context: context,
      message: message,
      backgroundColor: theme.colorScheme.primary,
      textColor: theme.colorScheme.onPrimary,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  // Show loading dialog
  static void showLoadingDialog({
    required BuildContext context,
    String? message,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              Text(
                message ?? 'Loading...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hide current dialog
  static void hideDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Show confirmation dialog
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    bool barrierDismissible = true,
  }) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: cancelButtonColor ?? theme.colorScheme.error,
            ),
            child: Text(cancelText ?? 'Cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: confirmButtonColor ?? theme.colorScheme.primary,
            ),
            child: Text(confirmText ?? 'Confirm'.tr()),
          ),
        ],
      ),
    );
    return result;
  }

  // Show bottom sheet
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool isDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool useRootNavigator = false,
    bool isSafeArea = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    final theme = Theme.of(context);
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      builder: (context) => isSafeArea
          ? SafeArea(
              child: child,
            )
          : child,
    );
  }

  // Show error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String message,
    String? title,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    final theme = Theme.of(context);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText ?? 'OK'.tr()),
          ),
        ],
      ),
    );
  }

  // Show success dialog
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String message,
    String? title,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    final theme = Theme.of(context);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Success'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText ?? 'OK'.tr()),
          ),
        ],
      ),
    );
  }

  // Show image picker bottom sheet
  static Future<ImageSource?> showImageSourcePicker({
    required BuildContext context,
    bool allowGallery = true,
    bool allowCamera = true,
    String? title,
    String? cameraLabel,
    String? galleryLabel,
    String? cancelLabel,
  }) async {
    if (!allowCamera && !allowGallery) {
      throw ArgumentError('At least one image source must be allowed');
    }

    final result = await showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(height: 1),
            ],
            if (allowCamera)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(cameraLabel ?? 'Take Photo'.tr()),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            if (allowGallery)
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(galleryLabel ?? 'Choose from Gallery'.tr()),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(cancelLabel ?? 'Cancel'.tr()),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );

    return result;
  }

  // Show date picker
  static Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    Locale? locale,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    String? helpText,
    String? cancelText,
    String? confirmText,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    TextInputType? keyboardType,
    bool useSafeArea = true,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      initialDatePickerMode: initialDatePickerMode,
      locale: locale,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldHintText: fieldHintText,
      fieldLabelText: fieldLabelText,
      keyboardType: keyboardType,
      useSafeArea: useSafeArea,
    );
    return picked;
  }

  // Show time picker
  static Future<TimeOfDay?> showTimePickerDialog({
    required BuildContext context,
    required TimeOfDay initialTime,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TransitionBuilder? builder,
    bool useSafeArea = true,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
    String? helpTextMaxHeight = '100000',
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: builder,
      useSafeArea: useSafeArea,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorInvalidText: errorInvalidText,
      hourLabelText: hourLabelText,
      minuteLabelText: minuteLabelText,
      helpTextMaxHeight: helpTextMaxHeight,
    );
    return picked;
  }

  // Show bottom navigation bar with custom items
  static Widget buildBottomNavigationBar({
    required BuildContext context,
    required int currentIndex,
    required List<BottomNavigationBarItem> items,
    required ValueChanged<int> onTap,
    Color? backgroundColor,
    double elevation = 8.0,
    BottomNavigationBarType type = BottomNavigationBarType.fixed,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    double iconSize = 24.0,
    Color? selectedIconTheme,
    Color? unselectedIconTheme,
    double selectedFontSize = 14.0,
    double unselectedFontSize = 12.0,
    bool showSelectedLabels = true,
    bool showUnselectedLabels = true,
    bool enableFeedback = true,
    double? selectedLabelSpacing,
  }) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      type: type,
      selectedItemColor: selectedItemColor ?? theme.colorScheme.primary,
      unselectedItemColor: unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6),
      iconSize: iconSize,
      selectedIconTheme: IconThemeData(
        color: selectedIconTheme ?? theme.colorScheme.primary,
      ),
      unselectedIconTheme: IconThemeData(
        color: unselectedIconTheme ?? theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      enableFeedback: enableFeedback,
      selectedLabelStyle: TextStyle(
        fontSize: selectedFontSize,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: unselectedFontSize,
        fontWeight: FontWeight.normal,
      ),
      selectedLabelSpacing: selectedLabelSpacing,
    );
  }

  // Dismiss keyboard
  static void dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.unfocus();
    }
  }

  // Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get text theme
  static TextTheme textTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  // Get color scheme
  static ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  // Check if device is in dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Show a simple dialog with options
  static Future<T?> showOptionsDialog<T>({
    required BuildContext context,
    required List<OptionItem<T>> options,
    String? title,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (option) => ListTile(
                  leading: option.icon,
                  title: Text(option.label),
                  onTap: () => Navigator.of(context).pop(option.value),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// Option item for showOptionsDialog
class OptionItem<T> {
  final String label;
  final T value;
  final Widget? icon;

  const OptionItem({
    required this.label,
    required this.value,
    this.icon,
  });
}
