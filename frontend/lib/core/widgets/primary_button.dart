import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double elevation;
  final bool hasShadow;
  final BorderSide? side;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.elevation = 0,
    this.hasShadow = false,
    this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: textColor ?? theme.colorScheme.onPrimary,
      elevation: elevation,
      padding: padding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
        side: side ?? BorderSide.none,
      ),
      shadowColor: hasShadow ? theme.shadowColor.withOpacity(0.2) : Colors.transparent,
    );

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: isLoading
          ? SizedBox(
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  textColor ?? theme.colorScheme.onPrimary,
                ),
              ),
            )
          : child,
    );

    if (width != null || isFullWidth) {
      button = SizedBox(
        width: isFullWidth ? double.infinity : width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}
