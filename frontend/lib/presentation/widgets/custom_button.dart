import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/constants/strings.dart';

enum ButtonType { primary, secondary, outlined, text, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget? icon;
  final bool disabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? elevation;
  final BorderSide? borderSide;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height = 48.0,
    this.icon,
    this.disabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.elevation,
    this.borderSide,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Determine button colors based on type
    late final Color buttonColor;
    late final Color buttonTextColor;
    late final Color disabledColor;
    late final Color? buttonBorderColor;
    
    switch (type) {
      case ButtonType.primary:
        buttonColor = backgroundColor ?? theme.primaryColor;
        buttonTextColor = textColor ?? Colors.white;
        disabledColor = theme.disabledColor;
        buttonBorderColor = null;
        break;
      case ButtonType.secondary:
        buttonColor = backgroundColor ?? theme.colorScheme.secondary;
        buttonTextColor = textColor ?? Colors.white;
        disabledColor = theme.disabledColor;
        buttonBorderColor = null;
        break;
      case ButtonType.outlined:
        buttonColor = Colors.transparent;
        buttonTextColor = textColor ?? (isDarkMode ? Colors.white : theme.primaryColor);
        disabledColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
        buttonBorderColor = isDarkMode ? Colors.grey[600] : theme.primaryColor;
        break;
      case ButtonType.text:
        buttonColor = Colors.transparent;
        buttonTextColor = textColor ?? (isDarkMode ? Colors.white : theme.primaryColor);
        disabledColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
        buttonBorderColor = null;
        break;
      case ButtonType.danger:
        buttonColor = backgroundColor ?? theme.colorScheme.error;
        buttonTextColor = textColor ?? Colors.white;
        disabledColor = theme.disabledColor;
        buttonBorderColor = null;
        break;
    }

    final buttonChild = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary || type == ButtonType.danger
                    ? Colors.white
                    : theme.primaryColor,
              ),
              strokeWidth: 2.0,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon,
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: textStyle ??
                    theme.textTheme.button?.copyWith(
                      color: disabled
                          ? isDarkMode
                              ? Colors.grey[500]
                              : Colors.grey[600]
                          : buttonTextColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          );

    final buttonStyle = ElevatedButton.styleFrom(
      primary: disabled ? disabledColor : buttonColor,
      onPrimary: buttonTextColor,
      elevation: elevation ?? (type == ButtonType.primary ? 2.0 : 0.0),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        side: borderSide ??
            (buttonBorderColor != null
                ? BorderSide(color: buttonBorderColor, width: 1.0)
                : BorderSide.none),
      ),
      minimumSize: Size(
        isFullWidth ? double.infinity : (width ?? 0.0),
        height ?? 48.0,
      ),
    );

    return ElevatedButton(
      onPressed: (disabled || isLoading) ? null : onPressed,
      style: buttonStyle,
      child: buttonChild,
    );
  }
}
