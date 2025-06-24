import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final bool withBackground;
  final double backgroundSize;

  const LoadingIndicator({
    Key? key,
    this.size = 24.0,
    this.strokeWidth = 2.5,
    this.color,
    this.withBackground = false,
    this.backgroundSize = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicator = SizedBox(
      width: size.r,
      height: size.r,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth.r,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.colorScheme.primary,
        ),
      ),
    );

    if (!withBackground) return indicator;

    return Center(
      child: Container(
        width: backgroundSize.r,
        height: backgroundSize.r,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: indicator,
      ),
    );
  }
}
