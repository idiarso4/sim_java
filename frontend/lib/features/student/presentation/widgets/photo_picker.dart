import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_java_frontend/core/utils/permission_handler_utils.dart';

class PhotoPicker extends StatefulWidget {
  final String? initialImageUrl;
  final Function(XFile?)? onImagePicked;
  final double size;
  final bool showEditIcon;

  const PhotoPicker({
    Key? key,
    this.initialImageUrl,
    this.onImagePicked,
    this.size = 120,
    this.showEditIcon = true,
  }) : super(key: key);

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.size.r;
    final hasImage = _pickedImage != null || widget.initialImageUrl != null;

    return Stack(
      children: [
        // Image Container
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceVariant,
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 1.5.r,
              ),
              image: _buildImageDecoration(),
            ),
            child: _isLoading
                ? Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5.r,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  )
                : !hasImage
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: 32.r,
                        color: theme.colorScheme.onSurfaceVariant,
                      )
                    : null,
          ),
        ),
        
        // Edit Icon
        if (widget.showEditIcon && hasImage)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2.r,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 16.r,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
      ],
    );
  }

  DecorationImage? _buildImageDecoration() {
    if (_pickedImage != null) {
      return DecorationImage(
        image: FileImage(File(_pickedImage!.path)),
        fit: BoxFit.cover,
      );
    } else if (widget.initialImageUrl != null) {
      return DecorationImage(
        image: NetworkImage(widget.initialImageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  Future<void> _pickImage() async {
    final permissionStatus = await PermissionHandlerUtils.requestPhotosPermission(context);
    if (!permissionStatus) return;

    try {
      setState(() => _isLoading = true);
      
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _pickedImage = pickedFile);
        widget.onImagePicked?.call(pickedFile);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
