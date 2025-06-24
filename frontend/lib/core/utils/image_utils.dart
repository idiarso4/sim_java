import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_image_compress/esys_flutter_image_compress.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ImageUtils {
  // Image source options
  static const ImageSource gallerySource = ImageSource.gallery;
  static const ImageSource cameraSource = ImageSource.camera;

  // Image quality (0-100)
  static const int defaultQuality = 85;
  
  // Maximum image dimensions
  static const int maxWidth = 1920;
  static const int maxHeight = 1080;

  // Singleton instance
  static final ImageUtils _instance = ImageUtils._internal();
  factory ImageUtils() => _instance;
  ImageUtils._internal();

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  // Get image from gallery
  Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    bool compress = true,
    int quality = defaultQuality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: compress ? quality : 100,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
      );
      
      if (image == null) return null;
      
      final File imageFile = File(image.path);
      
      if (compress) {
        return await compressImage(
          imageFile,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      }
      
      return imageFile;
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }

  // Pick multiple images
  Future<List<File>> pickMultipleImages({
    bool compress = true,
    int quality = defaultQuality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: compress ? quality : 100,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
      );
      
      if (images.isEmpty) return [];
      
      final List<File> result = [];
      
      for (final image in images) {
        final File imageFile = File(image.path);
        
        if (compress) {
          final compressedImage = await compressImage(
            imageFile,
            quality: quality,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
          );
          
          if (compressedImage != null) {
            result.add(compressedImage);
          }
        } else {
          result.add(imageFile);
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      rethrow;
    }
  }

  // Compress image
  Future<File?> compressImage(
    File file, {
    int quality = defaultQuality,
    int? maxWidth,
    int? maxHeight,
    String? targetPath,
  }) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath ?? await _getTemporaryFilePath(),
        quality: quality,
        minWidth: 600,
        minHeight: 600,
        rotate: 0,
      );
      
      if (result == null) return null;
      
      // If max dimensions are provided, resize the image
      if (maxWidth != null || maxHeight != null) {
        return await resizeImage(
          File(result.path),
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      }
      
      return File(result.path);
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return file; // Return original if compression fails
    }
  }

  // Resize image
  Future<File> resizeImage(
    File file, {
    int? maxWidth,
    int? maxHeight,
    String? targetPath,
  }) async {
    try {
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());
      
      // Calculate new dimensions while maintaining aspect ratio
      int originalWidth = decodedImage.width;
      int originalHeight = decodedImage.height;
      
      if (maxWidth == null && maxHeight == null) {
        maxWidth = ImageUtils.maxWidth;
      }
      
      double ratio = 1.0;
      
      if (maxWidth != null && originalWidth > maxWidth) {
        ratio = maxWidth / originalWidth;
      }
      
      if (maxHeight != null && (originalHeight * ratio) > maxHeight) {
        ratio = maxHeight / originalHeight;
      }
      
      final int targetWidth = (originalWidth * ratio).round();
      final int targetHeight = (originalHeight * ratio).round();
      
      // Skip if no resizing is needed
      if (targetWidth == originalWidth && targetHeight == originalHeight) {
        return file;
      }
      
      // Create a paint object for resizing
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()..filterQuality = FilterQuality.high;
      
      // Draw the resized image
      canvas.drawImageRect(
        decodedImage,
        Rect.fromPoints(
          const Offset(0, 0),
          Offset(originalWidth.toDouble(), originalHeight.toDouble()),
        ),
        Rect.fromPoints(
          const Offset(0, 0),
          Offset(targetWidth.toDouble(), targetHeight.toDouble()),
        ),
        paint,
      );
      
      // Convert to image and save to file
      final picture = recorder.endRecording();
      final img = await picture.toImage(targetWidth, targetHeight);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();
      
      // Save to file
      final String outputPath = targetPath ?? await _getTemporaryFilePath();
      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(buffer);
      
      return outputFile;
    } catch (e) {
      debugPrint('Error resizing image: $e');
      return file; // Return original if resizing fails
    }
  }

  // Crop image
  Future<File?> cropImage({
    required File sourceFile,
    CropStyle cropStyle = CropStyle.rectangle,
    double aspectRatioX = 1.0,
    double aspectRatioY = 1.0,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    bool compress = true,
    int quality = defaultQuality,
  }) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: sourceFile.path,
        cropStyle: cropStyle,
        aspectRatio: CropAspectRatio(
          ratioX: aspectRatioX,
          ratioY: aspectRatioY,
        ),
        aspectRatioPresets: aspectRatioPresets ?? [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        compressQuality: compress ? quality : 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
          cancelButtonTitle: 'Cancel',
          doneButtonTitle: 'Done',
          resetButtonHidden: false,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
        ),
      );
      
      if (croppedFile == null) return null;
      
      return File(croppedFile.path);
    } catch (e) {
      debugPrint('Error cropping image: $e');
      rethrow;
    }
  }

  // Get file size in KB or MB
  static String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  // Get image dimensions
  static Future<Size> getImageDimensions(File file) async {
    try {
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());
      return Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );
    } catch (e) {
      debugPrint('Error getting image dimensions: $e');
      return Size.zero;
    }
  }

  // Get image aspect ratio
  static Future<double> getAspectRatio(File file) async {
    final size = await getImageDimensions(file);
    if (size.width == 0 || size.height == 0) return 1.0;
    return size.width / size.height;
  }

  // Download image from URL
  static Future<File> downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final String filePath = await _getTemporaryFilePath();
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      rethrow;
    }
  }

  // Get cached network image
  static Widget getCachedNetworkImage(
    String? imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    bool circular = false,
    BorderRadius? borderRadius,
    Map<String, String>? httpHeaders,
    bool useOldImageOnUrlChange = false,
    Color? color,
    BlendMode? colorBlendMode,
    Alignment alignment = Alignment.center,
    Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return errorWidget ?? _buildPlaceholder(placeholder, width, height);
    }

    return ClipRRect(
      borderRadius: circular
          ? BorderRadius.circular(1000)
          : borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        httpHeaders: httpHeaders,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        placeholder: (context, url) => progressIndicatorBuilder?.call(
              context,
              url,
              const DownloadProgress(
                downloadProgress: 0.5,
                expectedTotalBytes: 100,
              ),
            ) ??
            _buildPlaceholder(placeholder, width, height),
        errorWidget: (context, url, error) =>
            errorWidget ??
            _buildPlaceholder(placeholder, width, height, isError: true),
      ),
    );
  }

  // Helper method to build placeholder
  static Widget _buildPlaceholder(
    Widget? placeholder,
    double? width,
    double? height, {
    bool isError = false,
  }) {
    if (placeholder != null) return placeholder;
    
    return Container(
      width: width,
      height: height,
      color: isError ? Colors.grey[300] : Colors.grey[200],
      child: Icon(
        isError ? Icons.error_outline : Icons.image,
        size: width != null ? width / 3 : 24,
        color: isError ? Colors.red : Colors.grey[400],
      ),
    );
  }

  // Generate a temporary file path
  static Future<String> _getTemporaryFilePath() async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/${const Uuid().v4()}.jpg';
  }

  // Get file extension from path
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  // Check if file is an image
  static bool isImageFile(String filePath) {
    final ext = getFileExtension(filePath);
    return [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.tiff',
    ].contains(ext);
  }

  // Get image file from assets
  static Future<File> getImageFileFromAssets(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${path.basename(assetPath)}');
    await file.writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  // Convert image file to Uint8List
  static Future<Uint8List> fileToUint8List(File file) async {
    return await file.readAsBytes();
  }

  // Convert Uint8List to Image widget
  static Widget uint8ListToImage(
    Uint8List bytes, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.memory(
      bytes,
      width: width,
      height: height,
      fit: fit,
    );
  }

  // Get dominant color from image
  static Future<Color> getDominantColor(File imageFile) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final image = await decodeImageFromList(bytes);
      
      // Create a smaller version of the image for faster processing
      final width = image.width > 100 ? 100 : image.width;
      final height = (image.height * (width / image.width)).toInt();
      
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        Paint(),
      );
      
      final picture = recorder.endRecording();
      final img = await picture.toImage(width, height);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();
      
      // Get color data
      final colorCount = <Color, int>{};
      
      for (int i = 0; i < buffer.length; i += 4) {
        final r = buffer[i];
        final g = buffer[i + 1];
        final b = buffer[i + 2];
        final a = buffer[i + 3];
        
        // Skip transparent or mostly transparent pixels
        if (a < 50) continue;
        
        // Group similar colors
        final color = Color.fromARGB(
          255,
          (r ~/ 10) * 10,
          (g ~/ 10) * 10,
          (b ~/ 10) * 10,
        );
        
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
      
      if (colorCount.isEmpty) return Colors.grey;
      
      // Find the most common color
      Color dominantColor = colorCount.entries.first.key;
      int maxCount = 0;
      
      colorCount.forEach((color, count) {
        if (count > maxCount) {
          maxCount = count;
          dominantColor = color;
        }
      });
      
      return dominantColor;
    } catch (e) {
      debugPrint('Error getting dominant color: $e');
      return Colors.grey;
    }
  }

  // Generate a color palette from an image
  static Future<List<Color>> getColorPalette(File imageFile, {int numColors = 5}) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final image = await decodeImageFromList(bytes);
      
      // Create a smaller version of the image for faster processing
      final width = image.width > 100 ? 100 : image.width;
      final height = (image.height * (width / image.width)).toInt();
      
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        Paint(),
      );
      
      final picture = recorder.endRecording();
      final img = await picture.toImage(width, height);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();
      
      // Get color data
      final colorCount = <Color, int>{};
      
      for (int i = 0; i < buffer.length; i += 4) {
        final r = buffer[i];
        final g = buffer[i + 1];
        final b = buffer[i + 2];
        final a = buffer[i + 3];
        
        // Skip transparent or mostly transparent pixels
        if (a < 50) continue;
        
        // Group similar colors
        final color = Color.fromARGB(
          255,
          (r ~/ 10) * 10,
          (g ~/ 10) * 10,
          (b ~/ 10) * 10,
        );
        
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
      
      if (colorCount.isEmpty) return List.filled(numColors, Colors.grey);
      
      // Sort colors by frequency
      final sortedColors = colorCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      // Get top N colors
      return sortedColors
          .take(numColors)
          .map((entry) => entry.key)
          .toList();
    } catch (e) {
      debugPrint('Error generating color palette: $e');
      return List.filled(numColors, Colors.grey);
    }
  }
}
