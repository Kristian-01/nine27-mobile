import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderStatusCard extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderStatusCard({
    super.key,
    required this.orderData,
  });

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${orderData["orderId"]}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Placed on ${orderData["orderDate"]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  orderData["estimatedDelivery"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  orderData["deliveryAddress"] as String,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final status = orderData["status"] as String;

    Color badgeColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        badgeColor = AppTheme.warningLight.withValues(alpha: 0.1);
        textColor = AppTheme.warningLight;
        break;
      case 'processing':
        badgeColor = AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.primaryColor;
        break;
      case 'out for delivery':
        badgeColor = AppTheme.successLight.withValues(alpha: 0.1);
        textColor = AppTheme.successLight;
        break;
      case 'delivered':
        badgeColor = AppTheme.successLight.withValues(alpha: 0.1);
        textColor = AppTheme.successLight;
        break;
      default:
        badgeColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurface;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
