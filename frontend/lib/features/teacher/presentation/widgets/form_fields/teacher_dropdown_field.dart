import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool isExpanded;
  final bool isDense;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? icon;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final Color? dropdownColor;
  final double? iconSize;
  final bool autofocus;
  final FocusNode? focusNode;
  final double? itemHeight;
  final double? elevation;
  final TextStyle? style;
  final AlignmentGeometry alignment;
  final Color? focusColor;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final bool? enableFeedback;
  final bool? isDismissible;
  final double? menuMaxHeight;
  final double? dropdownMaxHeight;
  final double? dropdownWidth;
  final BorderRadius? borderRadius;
  final Color? hoverColor;
  final bool? dropdownHideUnderline;
  final Color? dropdownIconColor;
  final double? dropdownIconSize;
  final bool? dropdownIsDense;
  final bool? dropdownIsExpanded;
  final double? dropdownItemHeight;
  final Color? dropdownMenuMaxHeightColor;
  final double? dropdownMenuMaxHeight;
  final double? dropdownMenuMinWidth;
  final double? dropdownMenuMaxWidth;
  final Color? dropdownSelectedItemHighlightColor;
  final bool? dropdownSelectedItemHighlightEnabled;
  final double? dropdownSelectedItemHighlightElevation;
  final double? dropdownSelectedItemHighlightRadius;
  final Color? dropdownSelectedItemHighlightShadowColor;
  final double? dropdownSelectedItemHighlightSpreadRadius;
  final double? dropdownSelectedItemHighlightBlurRadius;

  const TeacherDropdownField({
    Key? key,
    required this.value,
    required this.label,
    required this.items,
    this.onChanged,
    this.validator,
    this.hintText,
    this.errorText,
    this.helperText,
    this.isExpanded = true,
    this.isDense = true,
    this.enabled = true,
    this.prefixIcon,
    this.icon,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.dropdownColor,
    this.iconSize = 24.0,
    this.autofocus = false,
    this.focusNode,
    this.itemHeight = kMinInteractiveDimension,
    this.elevation = 8,
    this.style,
    this.alignment = AlignmentDirectional.centerStart,
    this.focusColor,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.enableFeedback,
    this.isDismissible,
    this.menuMaxHeight,
    this.dropdownMaxHeight,
    this.dropdownWidth,
    this.borderRadius,
    this.hoverColor,
    this.dropdownHideUnderline = false,
    this.dropdownIconColor,
    this.dropdownIconSize,
    this.dropdownIsDense,
    this.dropdownIsExpanded,
    this.dropdownItemHeight,
    this.dropdownMenuMaxHeightColor,
    this.dropdownMenuMaxHeight,
    this.dropdownMenuMinWidth = 112.0,
    this.dropdownMenuMaxWidth = 0.8,
    this.dropdownSelectedItemHighlightColor,
    this.dropdownSelectedItemHighlightEnabled = true,
    this.dropdownSelectedItemHighlightElevation,
    this.dropdownSelectedItemHighlightRadius,
    this.dropdownSelectedItemHighlightShadowColor,
    this.dropdownSelectedItemHighlightSpreadRadius,
    this.dropdownSelectedItemHighlightBlurRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.87),
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: IconTheme(
                      data: IconThemeData(
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24.r,
                      ),
                      child: prefixIcon!,
                    ),
                  )
                : null,
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                    width: 1.0,
                  ),
                ),
            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                    width: 1.0,
                  ),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
            errorBorder: errorBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 1.0,
                  ),
                ),
            focusedErrorBorder: focusedErrorBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2.0,
                  ),
                ),
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
            helperText: helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            errorText: errorText,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: enabled
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withOpacity(0.5),
          ),
          style: style ??
              theme.textTheme.bodyLarge?.copyWith(
                color: enabled
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
          isDense: isDense,
          isExpanded: isExpanded,
          elevation: elevation!,
          dropdownColor: dropdownColor ?? theme.colorScheme.surface,
          focusColor: focusColor ?? theme.colorScheme.primary.withOpacity(0.1),
          hoverColor: hoverColor ?? theme.colorScheme.primary.withOpacity(0.04),
          focusNode: focusNode,
          autofocus: autofocus,
          menuMaxHeight: menuMaxHeight,
          icon: icon ??
              Icon(
                Icons.arrow_drop_down,
                color: enabled
                    ? (iconEnabledColor ?? theme.colorScheme.onSurfaceVariant)
                    : (iconDisabledColor ?? theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                size: iconSize,
              ),
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
          iconSize: iconSize!,
          itemHeight: itemHeight,
          alignment: alignment,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
          enableFeedback: enableFeedback,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((DropdownMenuItem<T> item) {
              return Align(
                alignment: alignment,
                child: Text(
                  item.value.toString(),
                  style: style?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ) ??
                      theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
