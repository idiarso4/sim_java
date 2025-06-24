import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NetworkImageUtils {
  // Default cache manager instance
  static final CacheManager _cacheManager = DefaultCacheManager();
  
  // Default placeholder image
  static const String defaultPlaceholderPath = 'assets/images/placeholder.png';
  
  // Default error widget
  static const String defaultErrorPath = 'assets/images/error.png';
  
  // Get cached network image with placeholder and error widget
  static Widget getCachedNetworkImage({
    required String imageUrl,
    String? placeholderPath,
    String? errorPath,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
    Duration? placeholderFadeInDuration,
    Duration fadeInDuration = const Duration(milliseconds: 500),
    Duration fadeOutDuration = const Duration(milliseconds: 500),
    FilterQuality filterQuality = FilterQuality.medium,
    bool useOldImageOnUrlChange = false,
    Color? color,
    BlendMode? colorBlendMode,
    Alignment alignment = Alignment.center,
    Widget Function(BuildContext, String, DownloadProgress)? progressIndicatorBuilder,
    Map<String, String>? httpHeaders,
    bool memCacheWidthAndHeight = true,
    int? memCacheWidth,
    int? memCacheHeight,
    int? maxHeightDiskCache,
    int? maxWidthDiskCache,
    double? maxHeight,
    double? maxWidth,
  }) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholderOrError(
        placeholderPath: placeholderPath,
        errorPath: errorPath,
        fit: fit,
        width: width,
        height: height,
        borderRadius: borderRadius,
        placeholder: placeholder,
        errorWidget: errorWidget,
        isError: true,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: placeholder != null
            ? (context, url) => placeholder
            : (context, url) => _buildPlaceholderOrError(
                  placeholderPath: placeholderPath,
                  errorPath: errorPath,
                  fit: fit,
                  width: width,
                  height: height,
                  borderRadius: null, // Already clipped by parent
                  placeholder: null,
                  errorWidget: null,
                ),
        errorWidget: errorWidget != null
            ? (context, url, error) => errorWidget
            : (context, url, error) => _buildPlaceholderOrError(
                  placeholderPath: placeholderPath,
                  errorPath: errorPath,
                  fit: fit,
                  width: width,
                  height: height,
                  borderRadius: null, // Already clipped by parent
                  placeholder: null,
                  errorWidget: null,
                  isError: true,
                ),
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        placeholderFadeInDuration: placeholderFadeInDuration,
        filterQuality: filterQuality,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        progressIndicatorBuilder: progressIndicatorBuilder,
        httpHeaders: httpHeaders,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        maxHeightDiskCache: maxHeightDiskCache,
        maxWidthDiskCache: maxWidthDiskCache,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      ),
    );
  }

  // Get image from network or cache
  static Future<File> getImageFileFromNetwork(String url, {String? key}) async {
    final cacheKey = key ?? url;
    final file = await _cacheManager.getSingleFile(url, key: cacheKey);
    return file;
  }

  // Check if image exists in cache
  static Future<bool> isImageCached(String url, {String? key}) async {
    final cacheKey = key ?? url;
    final fileInfo = await _cacheManager.getFileFromCache(cacheKey);
    return fileInfo != null && fileInfo.file.existsSync();
  }

  // Clear all cached images
  static Future<void> clearImageCache() async {
    await _cacheManager.emptyCache();
  }

  // Remove a specific image from cache
  static Future<void> removeImageFromCache(String url, {String? key}) async {
    final cacheKey = key ?? url;
    await _cacheManager.removeFile(cacheKey);
  }

  // Precache an image
  static Future<void> precacheImage(String url, BuildContext context) async {
    try {
      await precacheImage(NetworkImage(url), context);
    } catch (e) {
      debugPrint('Error precaching image: $e');
    }
  }

  // Get image from assets with error handling
  static Widget getAssetImage(
    String path, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? color,
    BlendMode? colorBlendMode,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }

  // Download and save image to device
  static Future<File?> downloadAndSaveImage(
    String url, {
    String? fileName,
    String? dir,
  }) async {
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final directory = dir != null
            ? Directory(dir)
            : await getApplicationDocumentsDirectory();
            
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        
        final name = fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File('${directory.path}/$name');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      return null;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  // Get image size before loading
  static Future<ImageSize> getImageSize(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      final contentLength = response.contentLength;
      
      if (contentLength == null) {
        return ImageSize.unknown();
      }
      
      final completer = Completer<ImageSize>();
      
      final image = NetworkImage(url);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(
              ImageSize(
                width: info.image.width.toDouble(),
                height: info.image.height.toDouble(),
                size: contentLength.toDouble(),
              ),
            );
          },
          onError: (_, __) => completer.complete(ImageSize.unknown()),
        ),
      );
      
      return completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => ImageSize.unknown(),
      );
    } catch (e) {
      debugPrint('Error getting image size: $e');
      return ImageSize.unknown();
    }
  }

  // Get image from file with error handling
  static Widget getFileImage(
    String path, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? color,
    BlendMode? colorBlendMode,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        File(path),
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }

  // Build placeholder or error widget
  static Widget _buildPlaceholderOrError({
    String? placeholderPath,
    String? errorPath,
    bool isError = false,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    if (isError && errorWidget != null) return errorWidget;
    if (!isError && placeholder != null) return placeholder;

    final path = isError ? (errorPath ?? defaultErrorPath) : (placeholderPath ?? defaultPlaceholderPath);
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }

  // Build error widget
  static Widget _buildErrorWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  // Get memory image from Uint8List
  static ImageProvider getMemoryImage(Uint8List bytes) {
    return MemoryImage(bytes);
  }

  // Convert image to Uint8List
  static Future<Uint8List> imageToUint8List(String imagePath) async {
    final file = File(imagePath);
    return await file.readAsBytes();
  }

  // Get image dimensions from file
  static Future<ImageSize> getLocalImageSize(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return ImageSize.unknown();
      
      final bytes = await file.readAsBytes();
      final fileSize = bytes.lengthInBytes.toDouble();
      
      final completer = Completer<ImageSize>();
      
      final image = MemoryImage(bytes);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(
              ImageSize(
                width: info.image.width.toDouble(),
                height: info.image.height.toDouble(),
                size: fileSize,
              ),
            );
          },
          onError: (_, __) => completer.complete(ImageSize.unknown()),
        ),
      );
      
      return completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => ImageSize.unknown(),
      );
    } catch (e) {
      debugPrint('Error getting local image size: $e');
      return ImageSize.unknown();
    }
  }
}

// Class to hold image size information
class ImageSize {
  final double width;
  final double height;
  final double size; // in bytes
  final bool isUnknown;

  ImageSize({
    required this.width,
    required this.height,
    required this.size,
  }) : isUnknown = false;

  ImageSize.unknown()
      : width = 0,
        height = 0,
        size = 0,
        isUnknown = true;

  double get aspectRatio => width / height;
  String get formattedSize {
    if (size < 1024) return '${size.toStringAsFixed(2)} B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  String toString() => isUnknown
      ? 'ImageSize.unknown()'
      : 'ImageSize(width: $width, height: $height, size: $formattedSize)';
}
