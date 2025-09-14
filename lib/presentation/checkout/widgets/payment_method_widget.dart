import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatefulWidget {
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentMethodWidget({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  bool _isExpanded = true;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cod',
      'name': 'Cash on Delivery',
      'description': 'Pay when your order is delivered',
      'icon': 'payments',
      'isRecommended': true,
      'securityBadges': ['Secure', 'No prepayment required'],
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'description': 'Pay securely with your card',
      'icon': 'credit_card',
      'isRecommended': false,
      'securityBadges': ['SSL Encrypted', 'PCI Compliant'],
      'isComingSoon': true,
    },
    {
      'id': 'upi',
      'name': 'UPI Payment',
      'description': 'Pay instantly with UPI',
      'icon': 'account_balance_wallet',
      'isRecommended': false,
      'securityBadges': ['Instant', 'Secure'],
      'isComingSoon': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'payment',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Payment Method',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(height: 1, color: AppTheme.lightTheme.dividerColor),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: _paymentMethods.map((method) {
                  final isSelected =
                      widget.selectedPaymentMethod == method['id'];
                  final isComingSoon = method['isComingSoon'] == true;

                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: isComingSoon
                          ? null
                          : () {
                              widget.onPaymentMethodChanged(
                                  method['id'] as String);
                            },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.05)
                              : isComingSoon
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.05)
                                  : Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                            .withValues(alpha: 0.1)
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: method['icon'] as String,
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            method['name'] as String,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: isComingSoon
                                                      ? AppTheme.lightTheme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.5)
                                                      : null,
                                                ),
                                          ),
                                          if (method['isRecommended'] ==
                                              true) ...[
                                            SizedBox(width: 2.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w,
                                                  vertical: 0.5.h),
                                              decoration: BoxDecoration(
                                                color: AppTheme.successLight,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'RECOMMENDED',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 8.sp,
                                                    ),
                                              ),
                                            ),
                                          ],
                                          if (isComingSoon) ...[
                                            SizedBox(width: 2.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w,
                                                  vertical: 0.5.h),
                                              decoration: BoxDecoration(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSurface
                                                    .withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'COMING SOON',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: AppTheme
                                                          .lightTheme
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 8.sp,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        method['description'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: isComingSoon
                                                  ? AppTheme.lightTheme
                                                      .colorScheme.onSurface
                                                      .withValues(alpha: 0.4)
                                                  : AppTheme.lightTheme
                                                      .colorScheme.onSurface
                                                      .withValues(alpha: 0.7),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Radio<String>(
                                  value: method['id'] as String,
                                  groupValue: widget.selectedPaymentMethod,
                                  onChanged: isComingSoon
                                      ? null
                                      : (value) {
                                          if (value != null) {
                                            widget
                                                .onPaymentMethodChanged(value);
                                          }
                                        },
                                  activeColor: AppTheme.lightTheme.primaryColor,
                                ),
                              ],
                            ),
                            if (method['securityBadges'] != null &&
                                !isComingSoon) ...[
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 2.w,
                                      runSpacing: 1.h,
                                      children: (method['securityBadges']
                                              as List<String>)
                                          .map((badge) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 0.5.h),
                                          decoration: BoxDecoration(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.05),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface
                                                  .withValues(alpha: 0.1),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomIconWidget(
                                                iconName: 'verified_user',
                                                color: AppTheme.successLight,
                                                size: 12,
                                              ),
                                              SizedBox(width: 1.w),
                                              Text(
                                                badge,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color:
                                                          AppTheme.successLight,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
