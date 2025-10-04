import 'package:flutter/material.dart';
import 'notifications_service.dart';

enum NotificationType {
  order,
  promotion,
  reminder,
  general,
}

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final NotificationsService _notificationsService = NotificationsService();

  // Initialize notification manager
  Future<void> initialize() async {
    await _notificationsService.initialize();
    
    // Get and save FCM token
    final token = await _notificationsService.getToken();
    if (token != null) {
      await _notificationsService.saveToken(token);
    }
    
    // Subscribe to default topics
    await _notificationsService.subscribeToTopic('general');
  }

  // Handle notification based on type
  void handleNotification(BuildContext context, Map<String, dynamic> data) {
    final String type = data['type'] ?? 'general';
    final String title = data['title'] ?? 'Notification';
    final String message = data['message'] ?? '';
    
    switch (type) {
      case 'order':
        _handleOrderNotification(context, title, message, data);
        break;
      case 'promotion':
        _handlePromotionNotification(context, title, message, data);
        break;
      case 'reminder':
        _handleReminderNotification(context, title, message, data);
        break;
      default:
        _handleGeneralNotification(context, title, message, data);
        break;
    }
  }

  // Send notification
  Future<void> sendNotification({
    required NotificationType type,
    required String title,
    required String message,
    Map<String, dynamic>? additionalData,
  }) async {
    // Prepare payload
    final Map<String, dynamic> payload = {
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      ...?additionalData,
    };
    
    // Show local notification
    await _notificationsService.showLocalNotification(
      title: title,
      body: message,
      payload: payload.toString(),
    );
  }

  // Handle order notification
  void _handleOrderNotification(
    BuildContext context,
    String title,
    String message,
    Map<String, dynamic> data,
  ) {
    // Extract order ID if available
    final String? orderId = data['order_id'];
    
    // Show notification with order-specific styling
    _showInAppNotification(
      context,
      title: title,
      message: message,
      icon: Icons.shopping_bag,
      backgroundColor: Colors.blue,
      onTap: () {
        if (orderId != null) {
          // Navigate to order details page
          Navigator.of(context).pushNamed(
            '/order-tracking',
            arguments: {'order_id': orderId},
          );
        }
      },
    );
  }

  // Handle promotion notification
  void _handlePromotionNotification(
    BuildContext context,
    String title,
    String message,
    Map<String, dynamic> data,
  ) {
    // Show notification with promotion-specific styling
    _showInAppNotification(
      context,
      title: title,
      message: message,
      icon: Icons.local_offer,
      backgroundColor: Colors.purple,
      onTap: () {
        // Navigate to promotions page or specific promotion
        Navigator.of(context).pushNamed('/promotions');
      },
    );
  }

  // Handle reminder notification
  void _handleReminderNotification(
    BuildContext context,
    String title,
    String message,
    Map<String, dynamic> data,
  ) {
    // Show notification with reminder-specific styling
    _showInAppNotification(
      context,
      title: title,
      message: message,
      icon: Icons.alarm,
      backgroundColor: Colors.orange,
      onTap: () {
        // Handle reminder tap action
      },
    );
  }

  // Handle general notification
  void _handleGeneralNotification(
    BuildContext context,
    String title,
    String message,
    Map<String, dynamic> data,
  ) {
    // Show notification with general styling
    _showInAppNotification(
      context,
      title: title,
      message: message,
      icon: Icons.notifications,
      backgroundColor: Colors.green,
      onTap: () {
        // Handle general notification tap
      },
    );
  }

  // Show in-app notification
  void _showInAppNotification(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    VoidCallback? onTap,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildNotificationWidget(
          title: title,
          message: message,
          icon: icon,
          onTap: onTap,
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Build notification widget
  Widget _buildNotificationWidget({
    required String title,
    required String message,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get notification stream
  Stream<Map<String, dynamic>> get notificationStream => 
      _notificationsService.notificationStream;

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    await _notificationsService.clearAllNotifications();
  }
}