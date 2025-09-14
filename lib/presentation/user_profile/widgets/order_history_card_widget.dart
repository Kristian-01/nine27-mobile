import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderHistoryCardWidget extends StatelessWidget {
  final VoidCallback onViewAllOrders;
  final Function(int) onReorder;

  const OrderHistoryCardWidget({
    super.key,
    required this.onViewAllOrders,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock recent orders data
    final recentOrders = [
      {
        'id': 1001,
        'date': '2025-01-10',
        'status': 'Delivered',
        'total': 45.99,
        'itemCount': 3,
        'items': ['Paracetamol 500mg', 'Vitamin D3', 'Bandages'],
      },
      {
        'id': 1002,
        'date': '2025-01-05',
        'status': 'Processing',
        'total': 78.50,
        'itemCount': 5,
        'items': ['Cough Syrup', 'Amoxicillin', 'Pain Relief Gel'],
      },
      {
        'id': 1003,
        'date': '2024-12-28',
        'status': 'Delivered',
        'total': 32.25,
        'itemCount': 2,
        'items': ['Aspirin', 'Thermometer'],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(colorScheme),
        SizedBox(height: 3.h),
        ...recentOrders.map((order) => _buildOrderCard(order, colorScheme)),
        SizedBox(height: 2.h),
        _buildViewAllButton(colorScheme),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Orders',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: onViewAllOrders,
          child: Text(
            'View All',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, ColorScheme colorScheme) {
    final status = order['status'] as String;
    final statusColor = status == 'Delivered'
        ? AppTheme.successLight
        : status == 'Processing'
            ? AppTheme.warningLight
            : AppTheme.errorLight;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
              Text(
                'Order #${order['id']}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calendar',
                size: 16,
                color: AppTheme.textSecondaryLight,
              ),
              SizedBox(width: 1.w),
              Text(
                order['date'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'shopping_bag',
                size: 16,
                color: AppTheme.textSecondaryLight,
              ),
              SizedBox(width: 1.w),
              Text(
                '${order['itemCount']} items',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            (order['items'] as List<String>).take(2).join(', ') +
                (order['itemCount'] > 2 ? '...' : ''),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${order['total'].toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              if (status == 'Delivered')
                OutlinedButton(
                  onPressed: () => onReorder(order['id']),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'refresh',
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Reorder',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onViewAllOrders,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'history',
              size: 20,
              color: colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'View All Orders',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
