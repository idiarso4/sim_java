import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityUtils {
  static final Connectivity _connectivity = Connectivity();
  static StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  static Stream<bool> get connectionStatus => _connectionStatusController.stream;
  
  static bool _isInitialized = false;
  static bool _lastStatus = true; // Assume connected by default

  // Initialize connectivity monitoring
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initial check
      await _checkConnectivity();
      
      // Listen for connectivity changes
      _connectivity.onConnectivityChanged.listen((_) => _checkConnectivity());
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing connectivity: $e');
    }
  }

  // Check connectivity status
  static Future<bool> _checkConnectivity() async {
    try {
      bool isConnected;
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.none) {
        isConnected = false;
      } else {
        // Check if we can reach the internet
        isConnected = await _checkInternetConnection();
      }
      
      // Only notify listeners if status changed
      if (_lastStatus != isConnected) {
        _lastStatus = isConnected;
        _connectionStatusController.add(isConnected);
      }
      
      return isConnected;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  // Check internet connection by pinging a reliable server
  static Future<bool> _checkInternetConnection() async {
    try {
      // Try multiple reliable servers
      final hosts = [
        'google.com',
        'cloudflare.com',
        'microsoft.com',
      ];

      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(host);
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {
          continue;
        }
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Error checking internet connection: $e');
      return false;
    }
  }

  // Check if currently connected to the internet
  static Future<bool> get isConnected async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) return false;
      return await _checkInternetConnection();
    } catch (e) {
      debugPrint('Error checking if connected: $e');
      return false;
    }
  }

  // Check if connected to WiFi
  static Future<bool> get isWifiConnected async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.wifi;
    } catch (e) {
      debugPrint('Error checking WiFi connection: $e');
      return false;
    }
  }

  // Check if connected to mobile data
  static Future<bool> get isMobileConnected async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile;
    } catch (e) {
      debugPrint('Error checking mobile connection: $e');
      return false;
    }
  }

  // Get connection type (WiFi, Mobile, None)
  static Future<String> get connectionType async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.toString().split('.').last;
    } catch (e) {
      debugPrint('Error getting connection type: $e');
      return 'none';
    }
  }

  // Dispose the controller when not needed
  static void dispose() {
    _connectionStatusController.close();
    _connectionStatusController = StreamController<bool>.broadcast();
    _isInitialized = false;
  }
}

// Usage example:
/*
// Initialize in main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConnectivityUtils.initialize();
  
  runApp(MyApp());
}

// Listen to connectivity changes
StreamBuilder<bool>(
  stream: ConnectivityUtils.connectionStatus,
  builder: (context, snapshot) {
    if (snapshot.hasData && snapshot.data == false) {
      // Show offline UI
      return const OfflineBanner();
    }
    return const SizedBox.shrink();
  },
)

// Check connectivity
final isConnected = await ConnectivityUtils.isConnected;

// Get connection type
final type = await ConnectivityUtils.connectionType;
*/
