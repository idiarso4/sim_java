import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sim_java_frontend/core/constants/strings.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final Color? fillColor;
  final bool filled;
  final bool showErrorText;
  final String? errorText;
  final TextStyle? errorStyle;
  final double borderRadius;
  final double? height;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final AutovalidateMode? autovalidateMode;
  final Iterable<String>? autofillHints;
  final bool expands;
  final String? helperText;
  final TextStyle? helperStyle;
  final String? counterText;
  final TextStyle? counterStyle;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final bool? showCursor;
  final Color? cursorColor;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSavedValue;
  final List<String>? autofillHintsList;

  const CustomTextField({
    Key? key,
    this.controller,
    this.label,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.fillColor,
    this.filled = false,
    this.showErrorText = true,
    this.errorText,
    this.errorStyle,
    this.borderRadius = 8.0,
    this.height,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autovalidateMode,
    this.autofillHints,
    this.expands = false,
    this.helperText,
    this.helperStyle,
    this.counterText,
    this.counterStyle,
    this.prefixText,
    this.prefixStyle,
    this.suffixText,
    this.suffixStyle,
    this.showCursor,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.onEditingComplete,
    this.onSavedValue,
    this.autofillHintsList,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _obscureText = false;
  bool _isFocused = false;
  String? _errorText;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode!.addListener(_onFocusChange);
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode?.removeListener(_onFocusChange);
      _focusNode = widget.focusNode ?? _focusNode ?? FocusNode();
      _focusNode!.addListener(_onFocusChange);
    }
    if (widget.obscureText != oldWidget.obscureText) {
      setState(() {
        _obscureText = widget.obscureText;
      });
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode?.hasFocus ?? false;
    });
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
      });
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final border = widget.border ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        width: 1.0,
      ),
    );

    final enabledBorder = widget.enabledBorder ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        width: 1.0,
      ),
    );

    final focusedBorder = widget.focusedBorder ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: theme.primaryColor,
        width: 2.0,
      ),
    );

    final errorBorder = widget.errorBorder ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 1.0,
      ),
    );

    final focusedErrorBorder = widget.focusedErrorBorder ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 2.0,
      ),
    );

    final contentPadding = widget.contentPadding ?? const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    );

    Widget? suffixIcon = widget.suffixIcon;
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.subtitle2?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        SizedBox(
          height: widget.height,
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            style: theme.textTheme.bodyText2?.copyWith(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyText2?.copyWith(
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding,
              border: border,
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: focusedErrorBorder,
              filled: widget.filled,
              fillColor: widget.fillColor ?? (isDarkMode ? Colors.grey[900] : Colors.grey[50]),
              errorText: widget.showErrorText ? _errorText : null,
              errorStyle: widget.errorStyle ?? theme.textTheme.caption?.copyWith(
                color: theme.colorScheme.error,
              ),
              helperText: widget.helperText,
              helperStyle: widget.helperStyle ?? theme.textTheme.caption?.copyWith(
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),
              counterText: widget.counterText,
              counterStyle: widget.counterStyle,
              prefixText: widget.prefixText,
              prefixStyle: widget.prefixStyle,
              suffixText: widget.suffixText,
              suffixStyle: widget.suffixStyle,
            ),
            validator: _validate,
            onChanged: (value) {
              widget.onChanged?.call(value);
              if (_errorText != null) {
                _validate(value);
              }
            },
            onSaved: (value) {
              widget.onSaved?.call(value);
              widget.onSavedValue?.call(value);
            },
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            autocorrect: widget.autocorrect,
            enableSuggestions: widget.enableSuggestions,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            textCapitalization: widget.textCapitalization,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            autovalidateMode: widget.autovalidateMode,
            autofillHints: widget.autofillHints ?? widget.autofillHintsList,
            expands: widget.expands,
            showCursor: widget.showCursor,
            cursorColor: widget.cursorColor ?? theme.primaryColor,
            cursorWidth: widget.cursorWidth ?? 2.0,
            cursorRadius: widget.cursorRadius ?? const Radius.circular(2.0),
            enableInteractiveSelection: widget.enableInteractiveSelection,
            selectionControls: widget.selectionControls,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
          ),
        ),
        if (widget.showErrorText && _errorText != null) ...[
          const SizedBox(height: 4.0),
          Text(
            _errorText!,
            style: (widget.errorStyle ?? theme.textTheme.caption)?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
