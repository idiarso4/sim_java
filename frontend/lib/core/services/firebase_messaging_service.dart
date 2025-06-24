import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../utils/logger_utils.dart';

/// Define a top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  
  FirebaseMessagingService._internal();
  
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  bool _isInitialized = false;
  
  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Request permission
      await _requestPermission();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Configure message handling
      _configureMessageHandling();
      
      // Register FCM token with backend
      await registerToken();
      
      _isInitialized = true;
      print('Firebase Messaging initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }
  
  /// Request notification permissions
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    
    print('User notification permission status: ${settings.authorizationStatus}');
  }
  
  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle iOS foreground notification
      },
    );
    
    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        final String? payload = response.payload;
        if (payload != null) {
          print('Notification payload: $payload');
          // Navigate based on payload
        }
      },
    );
    
    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }
  
  /// Configure message handling for different app states
  void _configureMessageHandling() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });
    
    // Handle when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state with message: ${message.data}');
        _handleMessage(message);
      }
    });
    
    // Handle when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background state with message: ${message.data}');
      _handleMessage(message);
    });
  }
  
  /// Show a local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    if (notification != null && android != null && !kIsWeb) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            icon: android.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }
  
  /// Handle incoming message
  void _handleMessage(RemoteMessage message) {
    // Extract data from message
    final data = message.data;
    
    // Navigate based on message data
    if (data.containsKey('type')) {
      final type = data['type'];
      switch (type) {
        case 'attendance':
          // Navigate to attendance page
          break;
        case 'announcement':
          // Navigate to announcement page
          break;
        case 'grade':
          // Navigate to grade page
          break;
        default:
          // Default handling
          break;
      }
    }
  }
  
  /// Get the FCM token
  Future<String?> getToken() async {
    try {
      String? token = await _messaging.getToken();
      print('FCM Token: $token');
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
  
  /// Register FCM token with backend
  Future<bool> registerToken() async {
    try {
      String? token = await getToken();
      if (token == null) return false;
      
      // Save token to shared preferences
      final prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString('fcm_token');
      
      // Only register if token is new or changed
      if (oldToken != token) {
        // Register with backend
        final response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/notifications/token'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'token': token,
            'deviceInfo': Platform.operatingSystem,
          }),
        );
        
        if (response.statusCode == 200) {
          // Save the new token
          await prefs.setString('fcm_token', token);
          print('FCM token registered with backend');
          return true;
        } else {
          print('Failed to register FCM token with backend: ${response.body}');
          return false;
        }
      }
      
      return true;
    } catch (e) {
      print('Error registering FCM token: $e');
      return false;
    }
  }
  
  /// Subscribe to a topic
  Future<bool> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
      return true;
    } catch (e) {
      print('Error subscribing to topic: $topic - $e');
      return false;
    }
  }
  
  /// Unsubscribe from a topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      print('Error unsubscribing from topic: $topic - $e');
      return false;
    }
  }
} 