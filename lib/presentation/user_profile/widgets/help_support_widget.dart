import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HelpSupportWidget extends StatelessWidget {
  final VoidCallback onContactSupport;
  final VoidCallback onViewFAQ;

  const HelpSupportWidget({
    super.key,
    required this.onContactSupport,
    required this.onViewFAQ,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(colorScheme),
          SizedBox(height: 3.h),
          _buildSupportOption(
            'Frequently Asked Questions',
            'Find answers to common questions',
            'help_outline',
            onViewFAQ,
            colorScheme,
          ),
          SizedBox(height: 2.h),
          _buildSupportOption(
            'Contact Support',
            'Get help from our support team',
            'support_agent',
            onContactSupport,
            colorScheme,
          ),
          SizedBox(height: 2.h),
          _buildSupportOption(
            'Report an Issue',
            'Report bugs or technical problems',
            'bug_report',
            _handleReportIssue,
            colorScheme,
          ),
          SizedBox(height: 2.h),
          _buildSupportOption(
            'Rate Our App',
            'Share your feedback on the app store',
            'star_rate',
            _handleRateApp,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'help',
          size: 24,
          color: colorScheme.primary,
        ),
        SizedBox(width: 2.w),
        Text(
          'Help & Support',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportOption(
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderLight.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                size: 5.w,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              size: 16,
              color: AppTheme.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }

  void _handleReportIssue() {
    // Implement issue reporting
  }

  void _handleRateApp() {
    // Implement app rating
  }
}
