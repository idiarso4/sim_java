import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DeviceUtils {
  // Private constructor
  DeviceUtils._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static PackageInfo? _packageInfo;

  // Initialize device info
  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  // Check if platform is Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  // Check if platform is iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  // Check if platform is web
  static bool get isWeb => kIsWeb;

  // Check if platform is macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  // Check if platform is Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  // Check if platform is Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  // Check if platform is desktop (Windows, macOS, Linux)
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  // Check if platform is mobile (Android, iOS)
  static bool get isMobile => isAndroid || isIOS;

  // Get device info
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    if (isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return {
        'platform': 'Android',
        'model': androidInfo.model,
        'device': androidInfo.device,
        'id': androidInfo.id,
        'manufacturer': androidInfo.manufacturer,
        'version': androidInfo.version.release,
        'sdk': androidInfo.version.sdkInt,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
      };
    } else if (isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return {
        'platform': 'iOS',
        'model': iosInfo.model,
        'device': iosInfo.name,
        'id': iosInfo.identifierForVendor,
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
      };
    } else if (isWeb) {
      final webInfo = await _deviceInfoPlugin.webBrowserInfo;
      return {
        'platform': 'Web',
        'browser': webInfo.browserName.name,
        'userAgent': webInfo.userAgent,
        'vendor': webInfo.vendor,
        'language': webInfo.language,
      };
    } else if (isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      return {
        'platform': 'macOS',
        'computerName': macInfo.computerName,
        'hostName': macInfo.hostName,
        'arch': macInfo.arch,
        'model': macInfo.model,
        'kernelVersion': macInfo.kernelVersion,
        'osRelease': macInfo.osRelease,
        'activeCPUs': macInfo.activeCPUs,
      };
    } else if (isWindows) {
      final windowsInfo = await _deviceInfoPlugin.windowsInfo;
      return {
        'platform': 'Windows',
        'computerName': windowsInfo.computerName,
        'numberOfCores': windowsInfo.numberOfCores,
        'systemMemoryInMegabytes': windowsInfo.systemMemoryInMegabytes,
        'userName': windowsInfo.userName,
        'majorVersion': windowsInfo.version.major,
        'minorVersion': windowsInfo.version.minor,
        'buildNumber': windowsInfo.version.buildNumber,
      };
    } else if (isLinux) {
      final linuxInfo = await _deviceInfoPlugin.linuxInfo;
      return {
        'platform': 'Linux',
        'name': linuxInfo.name,
        'version': linuxInfo.version,
        'id': linuxInfo.id,
        'idLike': linuxInfo.idLike,
        'versionCodename': linuxInfo.versionCodename,
        'versionId': linuxInfo.versionId,
        'prettyName': linuxInfo.prettyName,
      };
    }
    return {'platform': 'Unknown'};
  }

  // Get app info
  static Map<String, String>? get appInfo {
    if (_packageInfo == null) return null;
    return {
      'appName': _packageInfo!.appName,
      'packageName': _packageInfo!.packageName,
      'version': _packageInfo!.version,
      'buildNumber': _packageInfo!.buildNumber,
    };
  }

  // Get app version
  static String get appVersion => _packageInfo?.version ?? '1.0.0';

  // Get build number
  static String get buildNumber => _packageInfo?.buildNumber ?? '1';

  // Get package name
  static String get packageName => _packageInfo?.packageName ?? '';

  // Get app name
  static String get appName => _packageInfo?.appName ?? 'SIM Java';

  // Check if app is running in debug mode
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  // Check if app is running in release mode
  static bool get isReleaseMode => !isDebugMode;

  // Check if app is running in profile mode
  static bool get isProfileMode => isProfileMode;

  // Get screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get screen aspect ratio
  static double getAspectRatio(BuildContext context) {
    return MediaQuery.of(context).size.aspectRatio;
  }

  // Get pixel ratio
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // Get status bar height
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // Get bottom safe area height
  static double getBottomSafeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // Get keyboard height
  static double getKeyboardHeight(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return viewInsets > 0 ? viewInsets : 0;
  }

  // Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return getKeyboardHeight(context) > 0;
  }

  // Hide keyboard
  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  // Launch URL
  static Future<bool> launchURL(
    String url, {
    bool forceWebView = false,
    bool enableJavaScript = false,
    bool enableDomStorage = false,
    bool universalLinksOnly = false,
    Map<String, String> headers = const {},
    String? webOnlyWindowName,
  }) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return false;

      final launchMode = forceWebView
          ? LaunchMode.inAppWebView
          : (universalLinksOnly
              ? LaunchMode.externalNonBrowserApplication
              : LaunchMode.platformDefault);

      final result = await launchUrlString(
        url,
        mode: launchMode,
        webViewConfiguration: WebViewConfiguration(
          headers: headers,
          enableJavaScript: enableJavaScript,
          enableDomStorage: enableDomStorage,
        ),
        webOnlyWindowName: webOnlyWindowName,
      );

      return result;
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }

  // Make a phone call
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    return await launchURL(url);
  }

  // Send an email
  static Future<bool> sendEmail({
    required String to,
    String? subject,
    String? body,
  }) async {
    final params = <String, String>{};
    if (subject != null) params['subject'] = subject;
    if (body != null) params['body'] = body;

    final queryString = params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final url = 'mailto:$to${queryString.isNotEmpty ? '?$queryString' : ''}';
    return await launchURL(url);
  }

  // Open app settings
  static Future<bool> openAppSettings() async {
    const url = 'app-settings:';
    return await launchURL(url);
  }

  // Open device settings
  static Future<bool> openDeviceSettings() async {
    const url = 'app-settings:';
    return await launchURL(url);
  }

  // Open app store
  static Future<bool> openAppStore({
    String? appId,
    String? appStoreLink,
  }) async {
    if (appId == null && appStoreLink == null) {
      throw ArgumentError('Either appId or appStoreLink must be provided');
    }

    String url;
    if (isIOS) {
      url = appStoreLink ?? 'https://apps.apple.com/app/id$appId';
    } else if (isAndroid) {
      url = appStoreLink ?? 'market://details?id=$appId';
    } else {
      url = appStoreLink ?? 'https://play.google.com/store/apps/details?id=$appId';
    }

    return await launchURL(url);
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    return shortestSide > 600;
  }

  // Check if device is phone
  static bool isPhone(BuildContext context) {
    return !isTablet(context);
  }

  // Get device orientation
  static Orientation getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  // Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }

  // Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return getOrientation(context) == Orientation.portrait;
  }

  // Get device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  // Check if device has notch
  static bool hasNotch(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.top > 24.0 || padding.bottom > 0.0;
  }

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  // Get view padding
  static EdgeInsets getViewPadding(BuildContext context) {
    return MediaQuery.of(context).viewPadding;
  }

  // Get view insets
  static EdgeInsets getViewInsets(BuildContext context) {
    return MediaQuery.of(context).viewInsets;
  }

  // Get system gesture insets
  static EdgeInsets getSystemGestureInsets(BuildContext context) {
    return MediaQuery.of(context).systemGestureInsets;
  }

  // Get padding for keyboard
  static EdgeInsets getKeyboardPadding(BuildContext context) {
    return EdgeInsets.only(bottom: getKeyboardHeight(context));
  }

  // Get device locale
  static String getDeviceLocale(BuildContext context) {
    return Localizations.localeOf(context).toString();
  }

  // Get device language code
  static String getDeviceLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  // Get device country code
  static String? getDeviceCountryCode(BuildContext context) {
    return Localizations.localeOf(context).countryCode;
  }

  // Check if dark mode is enabled
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Get platform brightness
  static Brightness getPlatformBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }

  // Check if platform is using dark mode
  static bool isPlatformDarkMode(BuildContext context) {
    return getPlatformBrightness(context) == Brightness.dark;
  }
}
