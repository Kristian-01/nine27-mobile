import 'package:flutter/material.dart';
import '../../services/notification_manager.dart';
import '../../theme/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NotificationManager _notificationManager = NotificationManager();
  
  // Sample notifications for demonstration
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'type': 'order',
      'title': 'Order Confirmed',
      'message': 'Your order #12345 has been confirmed and is being processed.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'read': false,
      'order_id': '12345',
    },
    {
      'type': 'promotion',
      'title': 'Weekend Sale!',
      'message': 'Get 20% off on all products this weekend.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'read': true,
    },
    {
      'type': 'reminder',
      'title': 'Medication Reminder',
      'message': 'Time to take your evening medication.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'read': false,
    },
    {
      'type': 'general',
      'title': 'Welcome to Nine27',
      'message': 'Thank you for choosing Nine27 for your pharmacy needs.',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'read': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              _showClearConfirmationDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Orders'),
            Tab(text: 'Promotions'),
            Tab(text: 'Reminders'),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(_allNotifications),
          _buildNotificationList(_allNotifications.where((n) => n['type'] == 'order').toList()),
          _buildNotificationList(_allNotifications.where((n) => n['type'] == 'promotion').toList()),
          _buildNotificationList(_allNotifications.where((n) => n['type'] == 'reminder').toList()),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final IconData icon;
    final Color color;

    switch (notification['type']) {
      case 'order':
        icon = Icons.shopping_bag;
        color = Colors.blue;
        break;
      case 'promotion':
        icon = Icons.local_offer;
        color = Colors.purple;
        break;
      case 'reminder':
        icon = Icons.alarm;
        color = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.green;
    }

    final DateTime timestamp = notification['timestamp'];
    final String timeAgo = _getTimeAgo(timestamp);

    return Dismissible(
      key: Key(notification['title'] + timestamp.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Remove notification logic would go here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification removed'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification['message']),
              const SizedBox(height: 4),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: notification['read']
              ? null
              : Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
          onTap: () {
            // Mark as read and handle notification tap
            setState(() {
              notification['read'] = true;
            });

            // Handle notification based on type
            _notificationManager.handleNotification(context, notification);
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // Clear notifications
              setState(() {
                _allNotifications.clear();
              });
              _notificationManager.clearAllNotifications();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
  }
}