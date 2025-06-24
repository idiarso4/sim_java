import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime?>? onDateSelected;
  final String? label;
  final String? hint;
  final FormFieldValidator<DateTime>? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const DatePickerField({
    Key? key,
    this.initialDate,
    this.onDateSelected,
    this.label,
    this.hint,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    
    return FormField<DateTime>(
      initialValue: initialDate,
      validator: validator,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            InkWell(
              onTap: !enabled ? null : () => _selectDate(context, formFieldState),
              borderRadius: BorderRadius.circular(4.r),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: hint ?? 'Select date',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                    size: 20.r,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: formFieldState.hasError
                          ? theme.colorScheme.error
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: formFieldState.hasError
                          ? theme.colorScheme.error
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: formFieldState.hasError
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  errorText: formFieldState.errorText,
                  errorStyle: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                child: Text(
                  formFieldState.value != null
                      ? DateFormat('dd MMMM yyyy').format(formFieldState.value!)
                      : '',
                  style: textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    FormFieldState<DateTime> formFieldState,
  ) async {
    final now = DateTime.now();
    final initialDate = formFieldState.value ?? now;
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(now.year + 100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      formFieldState.didChange(pickedDate);
      onDateSelected?.call(pickedDate);
    }
  }
}
