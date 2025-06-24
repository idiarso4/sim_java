import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPickerField extends StatefulWidget {
  final String label;
  final String? initialImageUrl;
  final String? Function(File?)? validator;
  final ValueChanged<File?>? onPhotoChanged;
  final VoidCallback? onRemovePhoto;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final bool enabled;
  final bool showLabel;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? removeIcon;
  final String? removeTooltip;
  final String? pickImageTooltip;
  final String? takePhotoTooltip;
  final bool showRemoveButton;
  final bool showPickImageButton;
  final bool showTakePhotoButton;
  final double elevation;
  final Color? shadowColor;
  final double? borderWidth;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final ImageErrorListener? onImageError;
  final LoadingBuilder? loadingBuilder;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? imageLoadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final FilterQuality filterQuality;
  final bool excludeFromSemantics;
  final Map<String, String>? httpHeaders;
  final int? cacheWidth;
  final int? cacheHeight;
  final bool isAntiAlias;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit? imageFit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String? semanticLabel;
  final bool excludeFromSemanticsImage;
  final bool isAntiAliasImage;
  final int? filterQualityImage;
  final bool isAntiAliasPlaceholder;
  final int? filterQualityPlaceholder;
  final ImageProvider? placeholderImage;
  final Widget? placeholderWidget;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final Duration fadeOutDuration;
  final Curve fadeOutCurve;
  final double? placeholderCacheWidth;
  final double? placeholderCacheHeight;
  final bool placeholderExcludeFromSemantics;
  final String? placeholderSemanticLabel;
  final bool placeholderGaplessPlayback;
  final ImageErrorWidgetBuilder? placeholderErrorBuilder;
  final FilterQuality placeholderFilterQuality;
  final ImageFrameBuilder? placeholderFrameBuilder;
  final ImageLoadingBuilder? placeholderLoadingBuilder;
  final ImageProvider? errorImage;
  final Widget? errorWidget;
  final double? errorCacheWidth;
  final double? errorCacheHeight;
  final bool errorExcludeFromSemantics;
  final String? errorSemanticLabel;
  final bool errorGaplessPlayback;
  final ImageErrorWidgetBuilder? errorErrorBuilder;
  final FilterQuality errorFilterQuality;
  final ImageFrameBuilder? errorFrameBuilder;
  final ImageLoadingBuilder? errorLoadingBuilder;

  const PhotoPickerField({
    Key? key,
    required this.label,
    this.initialImageUrl,
    this.validator,
    this.onPhotoChanged,
    this.onRemovePhoto,
    this.size = 100.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.enabled = true,
    this.showLabel = true,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.removeIcon,
    this.removeTooltip,
    this.pickImageTooltip,
    this.takePhotoTooltip,
    this.showRemoveButton = true,
    this.showPickImageButton = true,
    this.showTakePhotoButton = true,
    this.elevation = 0.0,
    this.shadowColor,
    this.borderWidth,
    this.borderColor,
    this.boxShadow,
    this.onImageError,
    this.loadingBuilder,
    this.frameBuilder,
    this.imageLoadingBuilder,
    this.errorBuilder,
    this.filterQuality = FilterQuality.low,
    this.excludeFromSemantics = false,
    this.httpHeaders,
    this.cacheWidth,
    this.cacheHeight,
    this.isAntiAlias = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.imageFit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.semanticLabel,
    this.excludeFromSemanticsImage = false,
    this.isAntiAliasImage = false,
    this.filterQualityImage,
    this.isAntiAliasPlaceholder = false,
    this.filterQualityPlaceholder,
    this.placeholderImage,
    this.placeholderWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.fadeOutCurve = Curves.easeInOut,
    this.placeholderCacheWidth,
    this.placeholderCacheHeight,
    this.placeholderExcludeFromSemantics = false,
    this.placeholderSemanticLabel,
    this.placeholderGaplessPlayback = false,
    this.placeholderErrorBuilder,
    this.placeholderFilterQuality = FilterQuality.low,
    this.placeholderFrameBuilder,
    this.placeholderLoadingBuilder,
    this.errorImage,
    this.errorWidget,
    this.errorCacheWidth,
    this.errorCacheHeight,
    this.errorExcludeFromSemantics = false,
    this.errorSemanticLabel,
    this.errorGaplessPlayback = false,
    this.errorErrorBuilder,
    this.errorFilterQuality = FilterQuality.low,
    this.errorFrameBuilder,
    this.errorLoadingBuilder,
  }) : super(key: key);

  @override
  _PhotoPickerFieldState createState() => _PhotoPickerFieldState();
}

class _PhotoPickerFieldState extends State<PhotoPickerField> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!widget.enabled) return;

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
        widget.onPhotoChanged?.call(_pickedImage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  void _removeImage() {
    if (!widget.enabled) return;

    setState(() {
      _pickedImage = null;
    });
    widget.onPhotoChanged?.call(null);
    widget.onRemovePhoto?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8.r);
    final backgroundColor = widget.backgroundColor ??
        (isDark ? colorScheme.surfaceVariant : colorScheme.surface);
    final iconColor = widget.iconColor ?? colorScheme.onSurfaceVariant;
    final borderColor = widget.borderColor ?? colorScheme.outline;
    final borderWidth = widget.borderWidth ?? 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withOpacity(0.87),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Center(
          child: Stack(
            children: [
              // Photo container
              Container(
                width: widget.size.w,
                height: widget.size.h,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth,
                  ),
                  boxShadow: widget.boxShadow ??
                      [
                        BoxShadow(
                          color: (widget.shadowColor ??
                                  Colors.black)
                              .withOpacity(0.1),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: _buildImage(),
                ),
              ),

              // Action buttons
              if (widget.enabled)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: borderRadius,
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top actions
                            if (widget.showPickImageButton ||
                                widget.showTakePhotoButton)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (widget.showPickImageButton)
                                    _buildActionButton(
                                      icon: Icons.photo_library_outlined,
                                      tooltip: widget.pickImageTooltip ?? 'Choose from gallery',
                                      onPressed: () => _pickImage(ImageSource.gallery),
                                    ),
                                  if (widget.showTakePhotoButton)
                                    _buildActionButton(
                                      icon: Icons.photo_camera_outlined,
                                      tooltip: widget.takePhotoTooltip ?? 'Take photo',
                                      onPressed: () =>
                                          _pickImage(ImageSource.camera),
                                    ),
                                ],
                              ),

                            // Bottom actions
                            if (widget.showRemoveButton &&
                                (_pickedImage != null ||
                                    widget.initialImageUrl != null))
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: _buildActionButton(
                                    icon: Icons.delete_outline,
                                    tooltip: widget.removeTooltip ?? 'Remove photo',
                                    onPressed: _removeImage,
                                    backgroundColor: colorScheme.errorContainer,
                                    foregroundColor: colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (_pickedImage != null) {
      return Image.file(
        _pickedImage!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        alignment: widget.alignment,
        repeat: widget.repeat,
        centerSlice: widget.centerSlice,
        matchTextDirection: widget.matchTextDirection,
        gaplessPlayback: widget.gaplessPlayback,
        isAntiAlias: widget.isAntiAlias,
        filterQuality: widget.filterQuality,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
        excludeFromSemantics: widget.excludeFromSemantics,
        semanticLabel: widget.semanticLabel,
      );
    } else if (widget.initialImageUrl != null &&
        widget.initialImageUrl!.isNotEmpty) {
      return Image.network(
        widget.initialImageUrl!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        alignment: widget.alignment,
        repeat: widget.repeat,
        centerSlice: widget.centerSlice,
        matchTextDirection: widget.matchTextDirection,
        gaplessPlayback: widget.gaplessPlayback,
        isAntiAlias: widget.isAntiAliasImage,
        filterQuality: widget.filterQualityImage ?? widget.filterQuality,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
        excludeFromSemantics:
            widget.excludeFromSemanticsImage || widget.excludeFromSemantics,
        semanticLabel: widget.semanticLabel,
        headers: widget.httpHeaders,
        frameBuilder: widget.frameBuilder,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }

    return Center(
      child: Icon(
        Icons.person_rounded,
        size: widget.size * 0.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: widget.size * 0.3,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load image',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Container(
        margin: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: backgroundColor ??
              (isDark
                  ? colorScheme.surfaceVariant.withOpacity(0.8)
                  : colorScheme.surface.withOpacity(0.9)),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, size: widget.iconSize),
          color: foregroundColor ?? colorScheme.onSurfaceVariant,
          iconSize: widget.iconSize,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 32.r,
            minHeight: 32.r,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
