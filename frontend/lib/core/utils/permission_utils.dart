import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  // Check if a permission is granted
  static Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Request a single permission
  static Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status;
  }

  // Check and request permission if not granted
  static Future<bool> checkAndRequestPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }
    return status.isGranted;
  }

  // Check if location permission is granted
  static Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  // Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    if (await Permission.storage.isRestricted) {
      return true; // On some devices, storage permission is always granted
    }
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  // Request storage permission
  static Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isRestricted) {
      return true; // On some devices, storage permission is always granted
    }
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // Check if microphone permission is granted
  static Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  // Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // Check if contacts permission is granted
  static Future<bool> hasContactsPermission() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  // Request contacts permission
  static Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  // Check if calendar permission is granted
  static Future<bool> hasCalendarPermission() async {
    final status = await Permission.calendar.status;
    return status.isGranted;
  }

  // Request calendar permission
  static Future<bool> requestCalendarPermission() async {
    final status = await Permission.calendar.request();
    return status.isGranted;
  }

  // Check if SMS permission is granted
  static Future<bool> hasSmsPermission() async {
    final status = await Permission.sms.status;
    return status.isGranted;
  }

  // Request SMS permission
  static Future<bool> requestSmsPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  // Check if phone permission is granted
  static Future<bool> hasPhonePermission() async {
    final status = await Permission.phone.status;
    return status.isGranted;
  }

  // Request phone permission
  static Future<bool> requestPhonePermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  // Check if notification permission is granted
  static Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Request notification permission
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // Check if location is always allowed (background location)
  static Future<bool> hasLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.status;
    return status.isGranted;
  }

  // Request location always permission (background location)
  static Future<bool> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  // Check if location when in use is allowed
  static Future<bool> hasLocationWhenInUsePermission() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  // Request location when in use permission
  static Future<bool> requestLocationWhenInUsePermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  // Open app settings
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Check if app has specific service enabled (e.g., location services)
  static Future<bool> isServiceEnabled(ServiceStatus service) async {
    switch (service) {
      case ServiceStatus.location:
        return await Permission.location.serviceStatus.isEnabled;
      case ServiceStatus.bluetooth:
        return await Permission.bluetooth.serviceStatus.isEnabled;
      case ServiceStatus.nfc:
        return await Permission.nfc.serviceStatus.isEnabled;
      case ServiceStatus.notification:
        return await Permission.notification.serviceStatus.isEnabled;
      default:
        return false;
    }
  }

  // Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  // Check if all permissions are granted
  static Future<bool> checkPermissions(List<Permission> permissions) async {
    for (final permission in permissions) {
      if (!(await permission.status.isGranted)) {
        return false;
      }
    }
    return true;
  }

  // Check and request multiple permissions if not granted
  static Future<Map<Permission, PermissionStatus>> checkAndRequestPermissions(
    List<Permission> permissions,
  ) async {
    final Map<Permission, PermissionStatus> statuses = {};
    for (final permission in permissions) {
      if (!(await permission.status.isGranted)) {
        statuses[permission] = await permission.request();
      } else {
        statuses[permission] = PermissionStatus.granted;
      }
    }
    return statuses;
  }

  // Check if all permissions in a map are granted
  static bool areAllPermissionsGranted(Map<Permission, PermissionStatus> statuses) {
    return statuses.values.every((status) => status.isGranted);
  }

  // Get permission status
  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }

  // Check if permission is permanently denied
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  // Check if permission is restricted (iOS)
  static Future<bool> isRestricted(Permission permission) async {
    final status = await permission.status;
    return status.isRestricted;
  }

  // Check if permission is limited (iOS 14+)
  static Future<bool> isLimited(Permission permission) async {
    final status = await permission.status;
    return status.isLimited;
  }

  // Check if permission is provisional (iOS 12+)
  static Future<bool> isProvisional(Permission permission) async {
    final status = await permission.status;
    return status.isProvisional;
  }
}

enum ServiceStatus {
  location,
  bluetooth,
  nfc,
  notification,
}
