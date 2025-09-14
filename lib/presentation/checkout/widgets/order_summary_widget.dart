import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final VoidCallback onEditCart;

  const OrderSummaryWidget({
    super.key,
    required this.cartItems,
    required this.onEditCart,
  });

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) {
      final price =
          double.tryParse(item['price'].toString().replaceAll('\$', '')) ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      return sum + (price * quantity);
    });
  }

  double get tax {
    return subtotal * 0.08; // 8% tax
  }

  double get deliveryFee {
    return subtotal > 50 ? 0.0 : 5.99;
  }

  double get total {
    return subtotal + tax + deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'receipt_long',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: onEditCart,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.lightTheme.dividerColor),
          Container(
            constraints: BoxConstraints(maxHeight: 30.h),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(4.w),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final price = double.tryParse(
                        item['price'].toString().replaceAll('\$', '')) ??
                    0.0;
                final quantity = item['quantity'] as int? ?? 1;

                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: item['image'] as String? ?? '',
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String? ?? 'Unknown Product',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Qty: $quantity',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                          ),
                          if (item['prescription_required'] == true) ...[
                            SizedBox(height: 0.5.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.warningLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Prescription Required',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.warningLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      '\$${(price * quantity).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1, color: AppTheme.lightTheme.dividerColor),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                _buildSummaryRow(
                    context, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                SizedBox(height: 1.h),
                _buildSummaryRow(
                    context, 'Tax (8%)', '\$${tax.toStringAsFixed(2)}'),
                SizedBox(height: 1.h),
                _buildSummaryRow(
                  context,
                  'Delivery Fee',
                  deliveryFee == 0
                      ? 'FREE'
                      : '\$${deliveryFee.toStringAsFixed(2)}',
                  isDeliveryFree: deliveryFee == 0,
                ),
                if (deliveryFee == 0) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Free delivery on orders over \$50',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.successLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.lightTheme.dividerColor),
                    ),
                  ),
                  child: _buildSummaryRow(
                    context,
                    'Total',
                    '\$${total.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    bool isDeliveryFree = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.primaryColor,
                  )
              : isDeliveryFree
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w600,
                      )
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
        ),
      ],
    );
  }
}
