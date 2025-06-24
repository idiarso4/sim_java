import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogUtils {
  // Show a basic alert dialog
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Show a confirmation dialog
  static Future<bool> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Show a loading dialog
  static Future<void> showLoading({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16.0),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }


  // Show a bottom sheet dialog
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool useSafeArea = true,
    bool enableDrag = true,
    bool isDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
      builder: (BuildContext context) => child,
    );
  }


  // Show a dialog with custom content
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Color? barrierColor,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (BuildContext context) => child,
    );
  }

  // Show a dialog with a form
  static Future<T?> showFormDialog<T>({
    required BuildContext context,
    required String title,
    required List<Widget> formFields,
    String confirmText = 'Save',
    String cancelText = 'Cancel',
    required GlobalKey<FormState> formKey,
    required VoidCallback onConfirm,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: formFields,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                onConfirm();
              }
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }


  // Show a dialog with a list of options
  static Future<T?> showOptionsDialog<T>({
    required BuildContext context,
    required String title,
    required List<OptionItem<T>> options,
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((option) => ListTile(
                      leading: option.icon,
                      title: Text(option.label),
                      onTap: () => Navigator.of(context).pop(option.value),
                    ))
                .toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(cancelText),
          ),
        ],
      ),
    );
  }

  // Show a dialog for text input
  static Future<String?> showTextInputDialog({
    required BuildContext context,
    required String title,
    String hintText = '',
    String initialValue = '',
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    bool autoFocus = true,
    int? maxLines = 1,
    int? maxLength,
    bool barrierDismissible = true,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
  }) async {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofocus: autoFocus,
            maxLines: maxLines,
            maxLength: maxLength,
            validator: validator,
            inputFormatters: inputFormatters,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? true) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Show a full-screen dialog
  static Future<T?> showFullScreenDialog<T>({
    required BuildContext context,
    required Widget child,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) async {
    return await Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        settings: routeSettings,
        barrierDismissible: false,
        opaque: true,
        fullscreenDialog: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  // Show a dialog with a single action button
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // Show a dialog with a title, content and two buttons
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Show a dialog with a title, content and a list of actions
  static Future<T?> showActionDialog<T>({
    required BuildContext context,
    required String title,
    required String message,
    required List<DialogAction<T>> actions,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions
            .map(
              (action) => TextButton(
                onPressed: () => Navigator.of(context).pop(action.returnValue),
                child: Text(action.label),
              ),
            )
            .toList(),
      ),
    );
  }

  // Show a dialog with a title and a list of items
  static Future<T?> showListDialog<T>({
    required BuildContext context,
    required String title,
    required List<DialogListItem<T>> items,
    String? cancelText,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map(
                  (item) => ListTile(
                    leading: item.icon,
                    title: Text(item.label),
                    onTap: () => Navigator.of(context).pop(item.value),
                  ),
                )
                .toList(),
          ),
        ),
        actions: cancelText != null
            ? <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(cancelText),
                ),
              ]
            : null,
      ),
    );
  }
}

// Model for dialog action
class DialogAction<T> {
  final String label;
  final T? returnValue;

  DialogAction({
    required this.label,
    this.returnValue,
  });
}

// Model for dialog list item
class DialogListItem<T> {
  final String label;
  final Widget? icon;
  final T value;

  DialogListItem({
    required this.label,
    this.icon,
    required this.value,
  });
}

// Model for option item
class OptionItem<T> {
  final String label;
  final Widget? icon;
  final T value;

  OptionItem({
    required this.label,
    this.icon,
    required this.value,
  });
}
