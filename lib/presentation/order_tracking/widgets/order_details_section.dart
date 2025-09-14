import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderDetailsSection extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final Map<String, dynamic> orderSummary;

  const OrderDetailsSection({
    super.key,
    required this.orderItems,
    required this.orderSummary,
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
          Text(
            'Order Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderItems.length,
            separatorBuilder: (context, index) => Divider(
              height: 3.h,
              color: theme.dividerColor.withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return _buildOrderItem(context, item);
            },
          ),
          Divider(
            height: 4.h,
            color: theme.dividerColor.withValues(alpha: 0.2),
            thickness: 1,
          ),
          _buildOrderSummary(context),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: item["image"] as String,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["name"] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              if (item["isPrescription"] == true)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Prescription Required',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.errorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty: ${item["quantity"]}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    item["price"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        _buildSummaryRow(
          context,
          'Subtotal',
          orderSummary["subtotal"] as String,
          false,
        ),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          context,
          'Delivery Fee',
          orderSummary["deliveryFee"] as String,
          false,
        ),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          context,
          'Tax',
          orderSummary["tax"] as String,
          false,
        ),
        SizedBox(height: 2.h),
        _buildSummaryRow(
          context,
          'Total',
          orderSummary["total"] as String,
          true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isTotal,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isTotal
                ? AppTheme.lightTheme.primaryColor
                : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
