import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartSummaryCard extends StatefulWidget {
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;

  const CartSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
  });

  @override
  State<CartSummaryCard> createState() => _CartSummaryCardState();
}

class _CartSummaryCardState extends State<CartSummaryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
      child: Column(
        children: [
          _buildSummaryHeader(colorScheme),
          if (_isExpanded) ...[
            SizedBox(height: 2.h),
            _buildDetailedBreakdown(colorScheme),
          ],
          SizedBox(height: 2.h),
          _buildTotalSection(colorScheme),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              Text(
                _isExpanded ? 'Hide Details' : 'View Details',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 1.w),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBreakdown(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildSummaryRow(
          'Subtotal',
          '\$${widget.subtotal.toStringAsFixed(2)}',
          colorScheme,
        ),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          'Tax',
          '\$${widget.tax.toStringAsFixed(2)}',
          colorScheme,
        ),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          'Delivery Fee',
          widget.deliveryFee > 0
              ? '\$${widget.deliveryFee.toStringAsFixed(2)}'
              : 'FREE',
          colorScheme,
          isDeliveryFree: widget.deliveryFee == 0,
        ),
        SizedBox(height: 1.h),
        Container(
          height: 1,
          color: AppTheme.borderLight.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    ColorScheme colorScheme, {
    bool isDeliveryFree = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color:
                isDeliveryFree ? AppTheme.successLight : colorScheme.onSurface,
            fontWeight: isDeliveryFree ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSection(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.borderLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            '\$${widget.total.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
