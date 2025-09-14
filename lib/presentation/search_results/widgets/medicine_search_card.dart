import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class MedicineSearchCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onAddToWishlist;

  const MedicineSearchCard({
    super.key,
    required this.medicine,
    this.onTap,
    this.onAddToCart,
    this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final String name = medicine['name'] as String? ?? '';
    final String genericName = medicine['genericName'] as String? ?? '';
    final double price = (medicine['price'] as num?)?.toDouble() ?? 0.0;
    final String imageUrl = medicine['imageUrl'] as String? ?? '';
    final bool inStock = medicine['inStock'] as bool? ?? false;
    final bool prescriptionRequired =
        medicine['prescriptionRequired'] as bool? ?? false;
    final String manufacturer = medicine['manufacturer'] as String? ?? '';
    final int stockQuantity = medicine['stockQuantity'] as int? ?? 0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showQuickActions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(imageUrl),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildProductInfo(name, genericName, manufacturer, price,
                    inStock, stockQuantity),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl.isNotEmpty
            ? CustomImageWidget(
                imageUrl: imageUrl,
                width: 20.w,
                height: 20.w,
                fit: BoxFit.cover,
              )
            : Center(
                child: CustomIconWidget(
                  iconName: 'medical_services',
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.5),
                  size: 24,
                ),
              ),
      ),
    );
  }

  Widget _buildProductInfo(String name, String genericName, String manufacturer,
      double price, bool inStock, int stockQuantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (genericName.isNotEmpty) ...[
          SizedBox(height: 0.5.h),
          Text(
            'Generic: $genericName',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: 0.5.h),
        Text(
          manufacturer,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            _buildPrescriptionBadge(),
          ],
        ),
        SizedBox(height: 1.h),
        _buildStockStatus(inStock, stockQuantity),
      ],
    );
  }

  Widget _buildPrescriptionBadge() {
    final bool prescriptionRequired =
        medicine['prescriptionRequired'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: prescriptionRequired
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: prescriptionRequired
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        prescriptionRequired ? 'Rx' : 'OTC',
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: prescriptionRequired
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.tertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStockStatus(bool inStock, int stockQuantity) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: inStock
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          inStock
              ? stockQuantity > 10
                  ? 'In Stock'
                  : 'Limited Stock ($stockQuantity left)'
              : 'Out of Stock',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: inStock
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final bool inStock = medicine['inStock'] as bool? ?? false;

    return Column(
      children: [
        IconButton(
          onPressed: inStock ? onAddToCart : null,
          icon: CustomIconWidget(
            iconName: 'add_shopping_cart',
            color: inStock
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
            size: 20,
          ),
          tooltip: 'Add to Cart',
        ),
        IconButton(
          onPressed: onAddToWishlist,
          icon: CustomIconWidget(
            iconName: 'favorite_border',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
            size: 20,
          ),
          tooltip: 'Add to Wishlist',
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context) {
    final bool inStock = medicine['inStock'] as bool? ?? false;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'add_shopping_cart',
                color: inStock
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.3),
                size: 24,
              ),
              title: Text(
                'Add to Cart',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: inStock
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.3),
                ),
              ),
              onTap: inStock
                  ? () {
                      Navigator.pop(context);
                      onAddToCart?.call();
                    }
                  : null,
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Add to Wishlist',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onAddToWishlist?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'View Details',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onTap?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
