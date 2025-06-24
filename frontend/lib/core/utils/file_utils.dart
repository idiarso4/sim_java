import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class FileUtils {
  // Pick a single file
  static Future<FilePickerResult?> pickFile({
    List<String>? allowedExtensions,
    String? type,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    try {
      return await FilePicker.platform.pickFiles(
        type: type != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: withData,
        withReadStream: withReadStream,
      );
    } catch (e) {
      debugPrint('Error picking file: $e');
      rethrow;
    }
  }

  // Pick multiple files
  static Future<List<File>?> pickFiles({
    List<String>? allowedExtensions,
    String? type,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withData: withData,
        withReadStream: withReadStream,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.map((file) => File(file.path!)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error picking files: $e');
      rethrow;
    }
  }

  // Get file size in human readable format
  static String getFileSizeString({required int bytes, int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  // Get file extension from path
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  // Get file name from path
  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  // Get file name without extension
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  // Get file mime type
  static String? getMimeType(String filePath) {
    return lookupMimeType(filePath);
  }

  // Check if file is an image
  static bool isImage(String filePath) {
    final mimeType = getMimeType(filePath);
    return mimeType?.startsWith('image/') ?? false;
  }

  // Check if file is a video
  static bool isVideo(String filePath) {
    final mimeType = getMimeType(filePath);
    return mimeType?.startsWith('video/') ?? false;
  }

  // Check if file is a PDF
  static bool isPdf(String filePath) {
    final mimeType = getMimeType(filePath);
    return mimeType == 'application/pdf';
  }

  // Compress image file
  static Future<File?> compressImage({
    required File file,
    int quality = 70,
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf('.');
      final targetPath = filePath.substring(0, lastIndex) + '_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }

  // Save file to app's documents directory
  static Future<File> saveFileLocally(File file, {String? fileName}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final name = fileName ?? path.basename(file.path);
      final newPath = '${directory.path}/$name';
      
      if (await file.exists()) {
        return await file.copy(newPath);
      }
      
      throw Exception('Source file does not exist');
    } catch (e) {
      debugPrint('Error saving file locally: $e');
      rethrow;
    }
  }

  // Save Uint8List to file
  static Future<File> saveUint8ListToFile({
    required Uint8List bytes,
    required String fileName,
    String? directoryPath,
  }) async {
    try {
      Directory directory;
      if (directoryPath != null) {
        directory = Directory(directoryPath);
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      
      return await file.writeAsBytes(bytes);
    } catch (e) {
      debugPrint('Error saving Uint8List to file: $e');
      rethrow;
    }
  }

  // Download file from URL
  static Future<File> downloadFile({
    required String url,
    required String fileName,
    String? directoryPath,
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);
      
      final bytes = await http.Response.fromStream(response).then((res) => res.bodyBytes);
      
      Directory directory;
      if (directoryPath != null) {
        directory = Directory(directoryPath);
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      
      return await file.writeAsBytes(bytes);
    } catch (e) {
      debugPrint('Error downloading file: $e');
      rethrow;
    }
  }

  // Open file with default app
  static Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      debugPrint('Open file result: ${result.message}');
    } catch (e) {
      debugPrint('Error opening file: $e');
      rethrow;
    }
  }

  // Get temporary directory path
  static Future<String> getTemporaryDirectoryPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  // Get application documents directory path
  static Future<String> getApplicationDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Check if file exists
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  // Delete file
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }

  // Get file size in bytes
  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting file size: $e');
      return 0;
    }
  }

  // Read file as string
  static Future<String> readFileAsString(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      throw Exception('File does not exist');
    } catch (e) {
      debugPrint('Error reading file as string: $e');
      rethrow;
    }
  }

  // Read file as bytes
  static Future<Uint8List> readFileAsBytes(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      throw Exception('File does not exist');
    } catch (e) {
      debugPrint('Error reading file as bytes: $e');
      rethrow;
    }
  }

  // Get all files in a directory
  static Future<List<FileSystemEntity>> getFilesInDirectory(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      if (await directory.exists()) {
        return directory.list().toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting files in directory: $e');
      return [];
    }
  }

  // Create a directory
  static Future<Directory> createDirectory(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory;
    } catch (e) {
      debugPrint('Error creating directory: $e');
      rethrow;
    }
  }

  // Delete a directory
  static Future<bool> deleteDirectory(String path) async {
    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting directory: $e');
      return false;
    }
  }

  // Get file name from URL
  static String getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return path.basename(uri.path);
    } catch (e) {
      debugPrint('Error getting file name from URL: $e');
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  // Get file extension from URL
  static String getFileExtensionFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return path.extension(uri.path).toLowerCase();
    } catch (e) {
      debugPrint('Error getting file extension from URL: $e');
      return '';
    }
  }

  // Check if directory exists
  static Future<bool> directoryExists(String path) async {
    try {
      return await Directory(path).exists();
    } catch (e) {
      debugPrint('Error checking if directory exists: $e');
      return false;
    }
  }

  // Get free disk space
  static Future<int> getFreeDiskSpace() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final stat = await FileSystemEntity.stat(directory.path);
      return stat.fileSystem.freeSpace;
    } catch (e) {
      debugPrint('Error getting free disk space: $e');
      return 0;
    }
  }

  // Get total disk space
  static Future<int> getTotalDiskSpace() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final stat = await FileSystemEntity.stat(directory.path);
      return stat.fileSystem.totalSpace;
    } catch (e) {
      debugPrint('Error getting total disk space: $e');
      return 0;
    }
  }
}
