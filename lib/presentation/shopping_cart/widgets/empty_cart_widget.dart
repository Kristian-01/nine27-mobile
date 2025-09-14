import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback onContinueShopping;

  const EmptyCartWidget({
    super.key,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyCartIllustration(colorScheme),
            SizedBox(height: 4.h),
            _buildEmptyCartText(colorScheme),
            SizedBox(height: 4.h),
            _buildContinueShoppingButton(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCartIllustration(ColorScheme colorScheme) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'shopping_cart_outlined',
          color: colorScheme.primary.withValues(alpha: 0.6),
          size: 20.w,
        ),
      ),
    );
  }

  Widget _buildEmptyCartText(ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          'Your Cart is Empty',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          'Looks like you haven\'t added any medicines to your cart yet. Browse our categories to find what you need.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondaryLight,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContinueShoppingButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onContinueShopping,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'category',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Continue Shopping',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
