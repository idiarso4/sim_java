import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:sim_java_frontend/core/utils/dialog_utils.dart';
import 'package:sim_java_frontend/core/utils/logger_utils.dart';
import 'package:sim_java_frontend/core/utils/navigation_utils.dart';

/// A utility class to handle runtime permissions in a clean and efficient way
class PermissionHandlerUtils {
  // Singleton instance
  static final PermissionHandlerUtils _instance = PermissionHandlerUtils._internal();
  
  factory PermissionHandlerUtils() => _instance;
  
  PermissionHandlerUtils._internal();
  
  /// Check if a permission is granted
  Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }
  
  /// Check if a permission is permanently denied
  Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }
  
  /// Check if a permission is restricted
  Future<bool> isRestricted(Permission permission) async {
    final status = await permission.status;
    return status.isRestricted;
  }
  
  /// Request a single permission
  /// Returns true if granted, false otherwise
  Future<bool> requestPermission(Permission permission) async {
    try {
      final status = await permission.request();
      return status.isGranted;
    } catch (e, stackTrace) {
      LoggerUtils.e('Error requesting permission', e, stackTrace);
      return false;
    }
  }
  
  /// Request multiple permissions
  /// Returns a map of permission to its status
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    try {
      return await permissions.request();
    } catch (e, stackTrace) {
      LoggerUtils.e('Error requesting permissions', e, stackTrace);
      return {};
    }
  }
  
  /// Check and request permission with a rationale dialog if needed
  /// Returns true if permission is granted, false otherwise
  Future<bool> checkAndRequestPermission(
    BuildContext context, 
    Permission permission, 
    {
      String? title,
      String? message,
      String? denyButtonText,
      String? settingsButtonText,
      bool showRationale = true,
    }
  ) async {
    // Check if permission is already granted
    if (await isGranted(permission)) {
      return true;
    }
    
    // Check if we should show rationale
    if (showRationale) {
      final shouldRequest = await _showRationaleDialog(
        context,
        permission,
        title: title,
        message: message,
        denyButtonText: denyButtonText,
      );
      
      if (!shouldRequest) {
        return false;
      }
    }
    
    // Request permission
    final isGranted = await requestPermission(permission);
    
    // If permission is permanently denied, show settings dialog
    if (!isGranted && await isPermanentlyDenied(permission)) {
      return await _showSettingsDialog(
        context,
        permission,
        title: title,
        message: 'Please enable the permission in app settings to continue.',
        settingsButtonText: settingsButtonText,
      );
    }
    
    return isGranted;
  }
  
  /// Show a dialog explaining why the permission is needed
  Future<bool> _showRationaleDialog(
    BuildContext context,
    Permission permission, {
    String? title,
    String? message,
    String? denyButtonText,
  }) async {
    final permissionName = _getPermissionName(permission);
    
    return await DialogUtils.showConfirmationDialog(
      context,
      title: title ?? 'Permission Required',
      message: message ?? 'This app needs $permissionName permission to function properly.\n\nWould you like to grant this permission?',
      confirmText: 'Grant',
      cancelText: denyButtonText ?? 'Deny',
    );
  }
  
  /// Show a dialog to open app settings
  Future<bool> _showSettingsDialog(
    BuildContext context,
    Permission permission, {
    String? title,
    String? message,
    String? settingsButtonText,
  }) async {
    final permissionName = _getPermissionName(permission);
    
    final result = await DialogUtils.showAlertDialog(
      context,
      title: title ?? 'Permission Required',
      message: message ?? '$permissionName permission is required for this feature. Please enable it in the app settings.',
      actions: [
        DialogAction(
          text: 'Cancel',
          onPressed: () => NavigationUtils.pop(context, false),
        ),
        DialogAction(
          text: settingsButtonText ?? 'Open Settings',
          isDefaultAction: true,
          onPressed: () async {
            await openAppSettings();
            NavigationUtils.pop(context, true);
          },
        ),
      ],
    );
    
    return result ?? false;
  }
  
  /// Get a user-friendly name for the permission
  String _getPermissionName(Permission permission) {
    if (permission == Permission.camera) return 'Camera';
    if (permission == Permission.photos) return 'Photos';
    if (permission == Permission.storage) return 'Storage';
    if (permission == Permission.microphone) return 'Microphone';
    if (permission == Permission.location) return 'Location';
    if (permission == Permission.notification) return 'Notifications';
    if (permission == Permission.contacts) return 'Contacts';
    if (permission == Permission.calendar) return 'Calendar';
    if (permission == Permission.sms) return 'SMS';
    if (permission == Permission.phone) return 'Phone';
    return 'this';
  }
  
  // Common permission groups
  
  /// Camera permission
  Future<bool> checkCameraPermission(BuildContext context, {bool showRationale = true}) async {
    return await checkAndRequestPermission(
      context, 
      Permission.camera,
      title: 'Camera Access',
      message: 'This app needs access to your camera to take photos.',
      showRationale: showRationale,
    );
  }
  
  /// Photos/Gallery permission
  Future<bool> checkPhotosPermission(BuildContext context, {bool showRationale = true}) async {
    Permission permission;
    if (defaultTargetPlatform == TargetPlatform.android) {
      permission = Permission.storage;
    } else {
      permission = Permission.photos;
    }
    
    return await checkAndRequestPermission(
      context, 
      permission,
      title: 'Photo Library Access',
      message: 'This app needs access to your photo library to select images.',
      showRationale: showRationale,
    );
  }
  
  /// Location permission
  Future<bool> checkLocationPermission(
    BuildContext context, {
    bool showRationale = true,
    bool precise = true,
  }) async {
    final permission = precise ? Permission.locationWhenInUse : Permission.location;
    
    return await checkAndRequestPermission(
      context, 
      permission,
      title: 'Location Access',
      message: 'This app needs access to your location to provide location-based services.',
      showRationale: showRationale,
    );
  }
  
  /// Microphone permission
  Future<bool> checkMicrophonePermission(BuildContext context, {bool showRationale = true}) async {
    return await checkAndRequestPermission(
      context, 
      Permission.microphone,
      title: 'Microphone Access',
      message: 'This app needs access to your microphone for audio recording.',
      showRationale: showRationale,
    );
  }
  
  /// Contacts permission
  Future<bool> checkContactsPermission(BuildContext context, {bool showRationale = true}) async {
    return await checkAndRequestPermission(
      context, 
      Permission.contacts,
      title: 'Contacts Access',
      message: 'This app needs access to your contacts to share information.',
      showRationale: showRationale,
    );
  }
  
  /// Storage permission (for Android)
  Future<bool> checkStoragePermission(BuildContext context, {bool showRationale = true}) async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    
    return await checkAndRequestPermission(
      context, 
      Permission.storage,
      title: 'Storage Access',
      message: 'This app needs access to your storage to save and load files.',
      showRationale: showRationale,
    );
  }
  
  /// Check and request multiple permissions
  /// Returns a map of permission to its status
  Future<Map<Permission, bool>> checkAndRequestMultiplePermissions(
    BuildContext context,
    List<Permission> permissions, {
    String? title,
    String? message,
    bool showRationale = true,
  }) async {
    final Map<Permission, bool> results = {};
    
    for (final permission in permissions) {
      final isGranted = await checkAndRequestPermission(
        context,
        permission,
        title: title,
        message: message,
        showRationale: showRationale,
      );
      results[permission] = isGranted;
    }
    
    return results;
  }
  
  /// Check if all permissions in the list are granted
  Future<bool> areAllPermissionsGranted(List<Permission> permissions) async {
    for (final permission in permissions) {
      if (!await isGranted(permission)) {
        return false;
      }
    }
    return true;
  }
  
  /// Open app settings
  Future<bool> openAppSettings() async {
    try {
      await openAppSettings();
      return true;
    } catch (e, stackTrace) {
      LoggerUtils.e('Error opening app settings', e, stackTrace);
      return false;
    }
  }
  
  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e, stackTrace) {
      LoggerUtils.e('Error requesting notification permission', e, stackTrace);
      return false;
    }
  }
}

// Extension for BuildContext to easily access permission utils
extension PermissionHandlerExtension on BuildContext {
  Future<bool> requestPermission(Permission permission) => 
      PermissionHandlerUtils().requestPermission(permission);
      
  Future<bool> checkAndRequestPermission(
    Permission permission, {
    String? title,
    String? message,
    bool showRationale = true,
  }) =>
      PermissionHandlerUtils().checkAndRequestPermission(
        this,
        permission,
        title: title,
        message: message,
        showRationale: showRationale,
      );
      
  Future<bool> checkCameraPermission({bool showRationale = true}) =>
      PermissionHandlerUtils().checkCameraPermission(this, showRationale: showRationale);
      
  Future<bool> checkPhotosPermission({bool showRationale = true}) =>
      PermissionHandlerUtils().checkPhotosPermission(this, showRationale: showRationale);
      
  Future<bool> checkLocationPermission({bool showRationale = true, bool precise = true}) =>
      PermissionHandlerUtils().checkLocationPermission(
        this, 
        showRationale: showRationale,
        precise: precise,
      );
      
  Future<bool> checkMicrophonePermission({bool showRationale = true}) =>
      PermissionHandlerUtils().checkMicrophonePermission(this, showRationale: showRationale);
      
  Future<bool> checkStoragePermission({bool showRationale = true}) =>
      PermissionHandlerUtils().checkStoragePermission(this, showRationale: showRationale);
      
  Future<Map<Permission, bool>> checkAndRequestMultiplePermissions(
    List<Permission> permissions, {
    String? title,
    String? message,
    bool showRationale = true,
  }) =>
      PermissionHandlerUtils().checkAndRequestMultiplePermissions(
        this,
        permissions,
        title: title,
        message: message,
        showRationale: showRationale,
      );
      
  Future<bool> areAllPermissionsGranted(List<Permission> permissions) =>
      PermissionHandlerUtils().areAllPermissionsGranted(permissions);
      
  Future<bool> openAppSettings() => PermissionHandlerUtils().openAppSettings();
  Future<bool> requestNotificationPermission() => 
      PermissionHandlerUtils().requestNotificationPermission();
}
