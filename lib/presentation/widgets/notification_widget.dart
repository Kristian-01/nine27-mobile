import 'package:flutter/material.dart';
import '../../services/notifications_service.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;
  final VoidCallback? onTap;

  const NotificationWidget({
    Key? key,
    required this.title,
    required this.message,
    this.icon = Icons.notifications,
    this.backgroundColor = Colors.green,
    this.duration = const Duration(seconds: 3),
    this.onTap,
  }) : super(key: key);

  static void showNotification(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.notifications,
    Color backgroundColor = Colors.green,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showLocalNotification = false,
  }) {
    // Show in-app notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: NotificationWidget(
          title: title,
          message: message,
          icon: icon,
          backgroundColor: backgroundColor,
          duration: duration,
          onTap: onTap,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );

    // Also show local notification if requested
    if (showLocalNotification) {
      NotificationsService().showLocalNotification(
        title: title,
        body: message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
      ),
    );
  }
}