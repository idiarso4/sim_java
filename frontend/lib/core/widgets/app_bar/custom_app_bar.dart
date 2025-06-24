import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final double? titleSpacing;
  final TextStyle? titleStyle;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.titleSpacing,
    this.titleStyle,
    this.bottom,
    this.toolbarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    
    return AppBar(
      title: Text(
        title,
        style: titleStyle ??
            appBarTheme.titleTextStyle ??
            theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.r,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation,
      titleSpacing: titleSpacing,
      bottom: bottom,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      automaticallyImplyLeading: showBackButton,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
