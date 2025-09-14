import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsConditionsWidget extends StatefulWidget {
  final bool isAccepted;
  final Function(bool) onAcceptanceChanged;

  const TermsConditionsWidget({
    super.key,
    required this.isAccepted,
    required this.onAcceptanceChanged,
  });

  @override
  State<TermsConditionsWidget> createState() => _TermsConditionsWidgetState();
}

class _TermsConditionsWidgetState extends State<TermsConditionsWidget> {
  bool _showFullTerms = false;

  final String _termsText = """
TERMS AND CONDITIONS

1. ACCEPTANCE OF TERMS
By placing an order through MediCart, you agree to be bound by these Terms and Conditions.

2. PRESCRIPTION MEDICATIONS
- Valid prescription required for prescription medications
- Prescription verification may take 24-48 hours
- We reserve the right to refuse orders without valid prescriptions

3. PAYMENT AND DELIVERY
- Cash on Delivery (COD) is our primary payment method
- Payment must be made in full upon delivery
- Delivery charges apply as per current rates

4. PRODUCT INFORMATION
- All product information is provided for reference only
- Consult healthcare professionals before use
- We are not liable for misuse of medications

5. RETURNS AND REFUNDS
- Unopened medications can be returned within 7 days
- Prescription medications are non-returnable
- Refunds processed within 5-7 business days

6. PRIVACY POLICY
- Your personal information is protected
- Medical information is kept confidential
- Data used only for order processing and delivery

7. LIABILITY
- MediCart is not liable for adverse reactions
- Consult doctors for medical advice
- Use medications as prescribed only

8. CONTACT INFORMATION
For any queries, contact us at:
Email: support@medicart.com
Phone: 1-800-MEDICART
""";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'gavel',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Terms & Conditions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: widget.isAccepted,
                  onChanged: (value) {
                    widget.onAcceptanceChanged(value ?? false);
                  },
                  activeColor: AppTheme.lightTheme.primaryColor,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onAcceptanceChanged(!widget.isAccepted);
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(
                                text: ' *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.errorLight,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFullTerms = !_showFullTerms;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              _showFullTerms ? 'Hide Terms' : 'Read Full Terms',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            SizedBox(width: 1.w),
                            CustomIconWidget(
                              iconName: _showFullTerms
                                  ? 'expand_less'
                                  : 'expand_more',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showFullTerms) ...[
              SizedBox(height: 2.h),
              Container(
                height: 30.h,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _termsText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ),
              ),
            ],
            if (!widget.isAccepted) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.errorLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.errorLight,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Please accept the terms and conditions to proceed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.errorLight,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
