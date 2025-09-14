import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsSection extends StatelessWidget {
  final String orderStatus;
  final String? deliveryPersonPhone;

  const ActionButtonsSection({
    super.key,
    required this.orderStatus,
    this.deliveryPersonPhone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canModifyOrder = orderStatus.toLowerCase() == 'pending';
    final canCallDelivery = orderStatus.toLowerCase() == 'out for delivery' &&
        deliveryPersonPhone != null;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          if (canCallDelivery)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _callDeliveryPerson(context),
                icon: CustomIconWidget(
                  iconName: 'phone',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Call Delivery Person'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successLight,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          if (canCallDelivery) SizedBox(height: 2.h),
          Row(
            children: [
              if (canModifyOrder) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _modifyOrder(context),
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 18,
                    ),
                    label: const Text('Modify Order'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _reportIssue(context),
                  icon: CustomIconWidget(
                    iconName: 'report_problem',
                    color: AppTheme.warningLight,
                    size: 18,
                  ),
                  label: const Text('Report Issue'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.warningLight,
                    side: const BorderSide(color: AppTheme.warningLight),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _callDeliveryPerson(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Call Delivery Person',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Would you like to call the delivery person at $deliveryPersonPhone?',
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: "Calling delivery person...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              icon: CustomIconWidget(
                iconName: 'phone',
                color: Colors.white,
                size: 16,
              ),
              label: const Text('Call'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successLight,
              ),
            ),
          ],
        );
      },
    );
  }

  void _modifyOrder(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Modify Order',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You can modify your order while it\'s still pending. Would you like to go to your cart?',
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
                Navigator.pushNamed(context, '/shopping-cart');
              },
              child: const Text('Go to Cart'),
            ),
          ],
        );
      },
    );
  }

  void _reportIssue(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Report Issue',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What type of issue would you like to report?',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildIssueOption(
                  context, 'Wrong items delivered', 'inventory_2'),
              _buildIssueOption(context, 'Delayed delivery', 'schedule'),
              _buildIssueOption(context, 'Damaged packaging', 'broken_image'),
              _buildIssueOption(context, 'Other issue', 'help_outline'),
            ],
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
          ],
        );
      },
    );
  }

  Widget _buildIssueOption(
      BuildContext context, String title, String iconName) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Issue reported: $title",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.warningLight,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
