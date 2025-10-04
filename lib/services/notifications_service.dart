import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
}

class NotificationsService {
  static final NotificationsService _instance = NotificationsService._internal();
  factory NotificationsService() => _instance;
  NotificationsService._internal();

  bool _initialized = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Stream controller for notification clicks
  final StreamController<Map<String, dynamic>> _notificationStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  // Getter for the stream
  Stream<Map<String, dynamic>> get notificationStream => 
      _notificationStreamController.stream;

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Firebase is already initialized in main.dart
      
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Set up foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Request permission for iOS
      if (Platform.isIOS) {
        await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
      
      // Configure notification click handling
      _configureNotificationClickHandling();
      
      // Subscribe to topics
      await subscribeToTopic('general');
      
      _initialized = true;
      print('Notification service initialized successfully');
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }

  // This method is now called in initialize()
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    
    // Add message data to stream for handling in the app
    if (notification != null) {
      _notificationStreamController.add(message.data);
    }
  }
  
  void _configureNotificationClickHandling() {
    // Handle notification clicks when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked in background: ${message.messageId}');
      _notificationStreamController.add(message.data);
    });
    
    // Check for initial notification (app opened from terminated state)
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state by notification');
        _notificationStreamController.add(message.data);
      }
    });
  }
  
  // Get FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
  
  // Save token to shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }
  
  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
  
  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
  
  // Show local notification (stub implementation)
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Just add to stream for in-app handling
    if (payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(payload);
        _notificationStreamController.add(data);
      } catch (e) {
        _notificationStreamController.add({
          'title': title,
          'body': body,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } else {
      _notificationStreamController.add({
        'title': title,
        'body': body,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
  
  // Clear all notifications (stub implementation)
  Future<void> clearAllNotifications() async {
    // No-op since we don't have local notifications
  }
  
  // Dispose resources
  void dispose() {
    _notificationStreamController.close();
  }
}


