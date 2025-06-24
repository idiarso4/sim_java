import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/constants/strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double elevation;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.textColor,
    this.elevation = 0.0,
    this.leading,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? (isDarkMode ? Colors.white : Colors.black87),
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
      leading: _buildLeading(context),
      actions: actions,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showBackButton,
      iconTheme: IconThemeData(
        color: textColor ?? (isDarkMode ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    
    if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20.0),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
