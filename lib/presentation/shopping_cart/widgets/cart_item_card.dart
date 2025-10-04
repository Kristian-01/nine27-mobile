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
        child: const CustomIconWidget(
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
    final img = (item["image"] as String?)?.isNotEmpty == true ? item["image"] as String : null;
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
          imageUrl: img,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails(ColorScheme colorScheme) {
    final name = (item["name"] ?? '') as String;
    final category = (item["category"] as String?) ?? '';

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
                    name,
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
                  if (category.isNotEmpty)
                    Text(
                      category,
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
                child: const CustomIconWidget(
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
          const CustomIconWidget(
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
    final qty = (item["quantity"] as int?) ?? 1;
    final maxStock = (item["stock"] as int?) ?? 999;

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
              if (qty > 1) {
                onQuantityChanged(qty - 1);
              }
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'remove',
                color: qty > 1 ? colorScheme.primary : AppTheme.textSecondaryLight,
                size: 16,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
            child: Text(
              qty.toString(),
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (qty < maxStock) {
                onQuantityChanged(qty + 1);
              }
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'add',
                color: qty < maxStock ? colorScheme.primary : AppTheme.textSecondaryLight,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(ColorScheme colorScheme) {
    final unitPrice = (item["price"] as num?)?.toDouble() ?? 0.0;
    final quantity = (item["quantity"] as int?) ?? 1;
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
