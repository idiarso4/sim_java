import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool showCounter;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final String? initialValue;
  final bool enabled;
  final TextAlign textAlign;
  final String? helperText;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;

  const TeacherTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.showCounter = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.focusNode,
    this.initialValue,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.helperText,
    this.errorText,
    this.autovalidateMode,
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
        TextFormField(
          controller: controller,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
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
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
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
            counterText: showCounter ? null : '',
            helperText: helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            errorText: errorText,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          autofocus: autofocus,
          textCapitalization: textCapitalization,
          focusNode: focusNode,
          initialValue: initialValue,
          enabled: enabled,
          textAlign: textAlign,
          autovalidateMode: autovalidateMode,
        ),
      ],
    );
  }
}
