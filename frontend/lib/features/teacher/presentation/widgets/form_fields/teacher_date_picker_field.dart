import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TeacherDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final DateFormat? format;
  final String? Function(String?)? validator;
  final void Function(DateTime?)? onDateSelected;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final String? helperText;
  final String? errorText;

  const TeacherDatePickerField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.format,
    this.validator,
    this.onDateSelected,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon = const Icon(Icons.calendar_today_outlined, size: 20),
    this.contentPadding,
    this.helperText,
    this.errorText,
  }) : super(key: key);

  @override
  _TeacherDatePickerFieldState createState() => _TeacherDatePickerFieldState();
}

class _TeacherDatePickerFieldState extends State<TeacherDatePickerField> {
  late TextEditingController _controller;
  DateFormat get _dateFormat => widget.format ?? DateFormat('dd/MM/yyyy');
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _initializeDate();
  }

  @override
  void didUpdateWidget(TeacherDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller;
      _initializeDate();
    } else if (widget.initialValue != oldWidget.initialValue) {
      _initializeDate();
    }
  }

  void _initializeDate() {
    if (widget.initialValue?.isNotEmpty == true) {
      try {
        _selectedDate = _dateFormat.parse(widget.initialValue!);
        _controller.text = widget.initialValue!;
      } catch (e) {
        // If parsing fails, keep the text as is
        _selectedDate = null;
      }
    } else if (_controller.text.isNotEmpty) {
      try {
        _selectedDate = _dateFormat.parse(_controller.text);
      } catch (e) {
        _selectedDate = null;
      }
    } else {
      _selectedDate = null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.readOnly || !widget.enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.surface,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        final formattedDate = _dateFormat.format(picked);
        _controller.text = formattedDate;
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.87),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _controller,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: IconTheme(
                      data: IconThemeData(
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24.r,
                      ),
                      child: widget.prefixIcon!,
                    ),
                  )
                : null,
            suffixIcon: IconButton(
              icon: widget.suffixIcon ?? const Icon(Icons.calendar_today_outlined, size: 20),
              onPressed: () => _selectDate(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
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
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
            helperText: widget.helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            errorText: widget.errorText,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: widget.validator,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
        ),
      ],
    );
  }
}
