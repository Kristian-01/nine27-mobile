import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key('cart_item_${item["id"]}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderLight.withValues(alpha: 0.3),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildProductDetails(colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.borderLight.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageWidget(
          imageUrl: item["image"] as String,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item["isPrescriptionRequired"] == true) ...[
                    SizedBox(height: 1.h),
                    _buildPrescriptionBadge(),
                  ],
                  SizedBox(height: 1.h),
                  Text(
                    item["category"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(1.w),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textSecondaryLight,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuantityControls(colorScheme),
            _buildPriceSection(colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildPrescriptionBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'medical_services',
            color: AppTheme.warningLight,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            'Prescription Required',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.warningLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              final currentQuantity = item["quantity"] as int;
              if (currentQuantity > 1) {
                onQuantityChanged(currentQuantity - 1);
              }
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'remove',
                color: (item["quantity"] as int) > 1
                    ? colorScheme.primary
                    : AppTheme.textSecondaryLight,
                size: 16,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
            child: Text(
              (item["quantity"] as int).toString(),
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final currentQuantity = item["quantity"] as int;
              final maxStock = item["stock"] as int;
              if (currentQuantity < maxStock) {
                onQuantityChanged(currentQuantity + 1);
              }
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'add',
                color: (item["quantity"] as int) < (item["stock"] as int)
                    ? colorScheme.primary
                    : AppTheme.textSecondaryLight,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(ColorScheme colorScheme) {
    final unitPrice = item["price"] as double;
    final quantity = item["quantity"] as int;
    final totalPrice = unitPrice * quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${totalPrice.toStringAsFixed(2)}',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        Text(
          '\$${unitPrice.toStringAsFixed(2)} each',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
