import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderTimeline extends StatefulWidget {
  final String currentStatus;

  const OrderTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  State<OrderTimeline> createState() => _OrderTimelineState();
}

class _OrderTimelineState extends State<OrderTimeline>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> timelineSteps = [
    {
      "title": "Order Placed",
      "subtitle": "Your order has been confirmed",
      "icon": "check_circle",
      "status": "pending"
    },
    {
      "title": "Processing",
      "subtitle": "Preparing your medicines",
      "icon": "inventory_2",
      "status": "processing"
    },
    {
      "title": "Shipped",
      "subtitle": "On the way to your location",
      "icon": "local_shipping",
      "status": "shipped"
    },
    {
      "title": "Delivered",
      "subtitle": "Order delivered successfully",
      "icon": "done_all",
      "status": "delivered"
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ...timelineSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == timelineSteps.length - 1;

            return _buildTimelineStep(
              context,
              step,
              index,
              isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context,
    Map<String, dynamic> step,
    int index,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final stepStatus = step["status"] as String;
    final currentStatusIndex = _getStatusIndex(widget.currentStatus);
    final stepIndex = _getStatusIndex(stepStatus);

    final isCompleted = stepIndex <= currentStatusIndex;
    final isCurrent = stepIndex == currentStatusIndex;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildTimelineIcon(context, step, isCompleted, isCurrent),
            if (!isLast)
              Container(
                width: 2,
                height: 6.h,
                color: isCompleted
                    ? AppTheme.lightTheme.primaryColor
                    : theme.dividerColor.withValues(alpha: 0.3),
              ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step["title"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  step["subtitle"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (!isLast) SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineIcon(
    BuildContext context,
    Map<String, dynamic> step,
    bool isCompleted,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget iconWidget = CustomIconWidget(
      iconName: step["icon"] as String,
      color: isCompleted
          ? Colors.white
          : colorScheme.onSurface.withValues(alpha: 0.4),
      size: 20,
    );

    if (isCurrent) {
      iconWidget = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.primaryColor
            : colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted
              ? AppTheme.lightTheme.primaryColor
              : theme.dividerColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: iconWidget,
    );
  }

  int _getStatusIndex(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0;
      case 'processing':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }
}
