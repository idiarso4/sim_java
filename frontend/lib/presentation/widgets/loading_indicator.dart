import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/constants/strings.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String? message;
  final bool showMessage;
  final Color? color;
  final double size;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;
  final bool showBackground;
  final Color? backgroundColor;
  final double borderRadius;
  final BoxConstraints? constraints;
  final bool centerInScreen;
  final Axis direction;
  final double spacing;

  const CustomLoadingIndicator({
    Key? key,
    this.message,
    this.showMessage = true,
    this.color,
    this.size = 32.0,
    this.strokeWidth = 3.0,
    this.padding = const EdgeInsets.all(16.0),
    this.showBackground = false,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.constraints,
    this.centerInScreen = false,
    this.direction = Axis.vertical,
    this.spacing = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final loadingWidget = Center(
      child: Container(
        padding: padding,
        constraints: constraints,
        decoration: showBackground
            ? BoxDecoration(
                color: backgroundColor ?? 
                      (isDarkMode ? Colors.grey[900]!.withOpacity(0.8) : Colors.white.withOpacity(0.9)),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              )
            : null,
        child: direction == Axis.vertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLoadingIndicator(context),
                  if (showMessage && (message != null || message?.isNotEmpty == true)) ...[
                    SizedBox(height: spacing),
                    _buildMessageText(context),
                  ],
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLoadingIndicator(context),
                  if (showMessage && (message != null || message?.isNotEmpty == true)) ...[
                    SizedBox(width: spacing),
                    _buildMessageText(context),
                  ],
                ],
              ),
      ),
    );

    return centerInScreen
        ? Scaffold(
            body: loadingWidget,
          )
        : loadingWidget;
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.primaryColor,
        ),
        strokeWidth: strokeWidth,
      ),
    );
  }

  Widget _buildMessageText(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Text(
      message ?? AppStrings.loading,
      style: theme.textTheme.subtitle2?.copyWith(
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Shorthand constructors
  factory CustomLoadingIndicator.small({
    Key? key,
    String? message,
    bool showMessage = true,
    Color? color,
    EdgeInsetsGeometry? padding,
    bool showBackground = false,
    Color? backgroundColor,
    double borderRadius = 8.0,
    BoxConstraints? constraints,
    bool centerInScreen = false,
    Axis direction = Axis.horizontal,
    double spacing = 8.0,
  }) {
    return CustomLoadingIndicator(
      key: key,
      message: message,
      showMessage: showMessage,
      color: color,
      size: 20.0,
      strokeWidth: 2.0,
      padding: padding ?? const EdgeInsets.all(8.0),
      showBackground: showBackground,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      constraints: constraints,
      centerInScreen: centerInScreen,
      direction: direction,
      spacing: spacing,
    );
  }

  factory CustomLoadingIndicator.medium({
    Key? key,
    String? message,
    bool showMessage = true,
    Color? color,
    EdgeInsetsGeometry? padding,
    bool showBackground = false,
    Color? backgroundColor,
    double borderRadius = 8.0,
    BoxConstraints? constraints,
    bool centerInScreen = false,
    Axis direction = Axis.vertical,
    double spacing = 12.0,
  }) {
    return CustomLoadingIndicator(
      key: key,
      message: message,
      showMessage: showMessage,
      color: color,
      size: 32.0,
      strokeWidth: 3.0,
      padding: padding ?? const EdgeInsets.all(16.0),
      showBackground: showBackground,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      constraints: constraints,
      centerInScreen: centerInScreen,
      direction: direction,
      spacing: spacing,
    );
  }

  factory CustomLoadingIndicator.large({
    Key? key,
    String? message,
    bool showMessage = true,
    Color? color,
    EdgeInsetsGeometry? padding,
    bool showBackground = false,
    Color? backgroundColor,
    double borderRadius = 12.0,
    BoxConstraints? constraints,
    bool centerInScreen = true,
    Axis direction = Axis.vertical,
    double spacing = 16.0,
  }) {
    return CustomLoadingIndicator(
      key: key,
      message: message,
      showMessage: showMessage,
      color: color,
      size: 48.0,
      strokeWidth: 4.0,
      padding: padding ?? const EdgeInsets.all(24.0),
      showBackground: showBackground,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      constraints: constraints,
      centerInScreen: centerInScreen,
      direction: direction,
      spacing: spacing,
    );
  }
}
