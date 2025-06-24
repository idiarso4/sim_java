import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationUtils {
  // Singleton pattern
  static final NavigationUtils _instance = NavigationUtils._internal();
  factory NavigationUtils() => _instance;
  NavigationUtils._internal();

  // Navigation key for global navigation
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  // Get current state
  NavigatorState? get currentState => navigatorKey.currentState;

  // Push a named route
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Object? arguments,
    bool replace = false,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) async {
    if (replace) {
      return await currentState?.pushReplacementNamed(
        name,
        arguments: arguments,
        result: (Route<dynamic> route) => false,
      );
    }
    return await currentState?.pushNamed(
      name,
      arguments: arguments,
    );
  }

  // Push a route
  Future<T?> push<T extends Object?>(
    Route<T> route, {
    bool replace = false,
  }) async {
    if (replace) {
      return await currentState?.pushReplacement(route);
    }
    return await currentState?.push(route);
  }

  // Pop the current route
  void pop<T extends Object?>([T? result]) {
    if (currentState?.canPop() ?? false) {
      currentState?.pop<T>(result);
    }
  }

  // Pop until a named route
  void popUntil(String routeName) {
    currentState?.popUntil(ModalRoute.withName(routeName));
  }

  // Push and remove all routes
  Future<T?> pushAndRemoveAll<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    return await currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Push and replace current route
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) async {
    return await currentState?.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  // Push and remove until a named route
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    String untilRouteName, {
    Object? arguments,
  }) async {
    return await currentState?.pushNamedAndRemoveUntil<T>(
      newRouteName,
      ModalRoute.withName(untilRouteName),
      arguments: arguments,
    );
  }

  // Show a dialog
  Future<T?> showDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) async {
    return await showDialog<T>(
      context: currentContext!,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  // Show a bottom sheet
  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) async {
    return await showModalBottomSheet<T>(
      context: currentContext!,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
    );
  }

  // Show a snackbar
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    DismissDirection dismissDirection = DismissDirection.down,
    Clip clipBehavior = Clip.hardEdge,
    bool showCloseIcon = false,
    Color? closeIconColor,
    void Function()? onVisible,
  }) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
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

  // Check if can pop
  bool canPop() {
    return currentState?.canPop() ?? false;
  }

  // Go to a named route
  void go(String location, {Object? extra}) {
    currentContext?.go(location, extra: extra);
  }

  // Push a named route with GoRouter
  void pushNamedGo(String name, {Map<String, String> params = const {}, Map<String, dynamic> queryParams = const {}}) {
    currentContext?.pushNamed(name, pathParameters: params, queryParameters: queryParams);
  }

  // Pop with result
  void popWithResult<T>(T result) {
    currentState?.pop<T>(result);
  }

  // Show error dialog
  Future<void> showErrorDialog({
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    return await showDialog(
      context: currentContext!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog
  Future<bool> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// Global navigation helper
final navUtils = NavigationUtils();

// Extension for BuildContext
extension NavigationExtension on BuildContext {
  // Push a named route
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    return Navigator.of(this).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  // Pop the current route
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  // Check if can pop
  bool get canPop => Navigator.of(this).canPop();

  // Push and remove all routes
  Future<T?> pushAndRemoveAll<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
