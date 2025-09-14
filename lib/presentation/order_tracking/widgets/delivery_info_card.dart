import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryInfoCard extends StatelessWidget {
  final Map<String, dynamic> deliveryInfo;
  final bool canEdit;

  const DeliveryInfoCard({
    super.key,
    required this.deliveryInfo,
    required this.canEdit,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (canEdit)
                TextButton(
                  onPressed: () {
                    _showEditDialog(context);
                  },
                  child: Text(
                    'Edit',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInfoRow(
            context,
            'location_on',
            'Address',
            deliveryInfo["address"] as String,
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
            context,
            'person',
            'Contact Person',
            deliveryInfo["contactName"] as String,
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
            context,
            'phone',
            'Phone Number',
            deliveryInfo["phoneNumber"] as String,
          ),
          if (deliveryInfo["deliveryInstructions"] != null &&
              (deliveryInfo["deliveryInstructions"] as String).isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildInfoRow(
              context,
              'note',
              'Delivery Instructions',
              deliveryInfo["deliveryInstructions"] as String,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String iconName,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
                maxLines: label == 'Address' || label == 'Delivery Instructions'
                    ? 3
                    : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Delivery Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You can modify your delivery information for pending orders. Would you like to proceed?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to edit delivery info screen
                Navigator.pushNamed(context, '/checkout');
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }
}
