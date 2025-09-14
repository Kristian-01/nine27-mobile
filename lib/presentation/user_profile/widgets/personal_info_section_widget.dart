import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEdit;

  const PersonalInfoSectionWidget({
    super.key,
    required this.userData,
    required this.onEdit,
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
          _buildSectionHeader(colorScheme),
          SizedBox(height: 3.h),
          _buildInfoField(
            'Phone Number',
            userData['phone'] ?? 'Not provided',
            'phone',
            colorScheme,
          ),
          SizedBox(height: 2.h),
          _buildInfoField(
            'Email Address',
            userData['email'] ?? 'Not provided',
            'email',
            colorScheme,
          ),
          SizedBox(height: 2.h),
          _buildInfoField(
            'Emergency Contact',
            userData['emergencyContact'] ?? 'Not provided',
            'emergency_contact',
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Personal Information',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: CustomIconWidget(
            iconName: 'edit',
            size: 20,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(
    String label,
    String value,
    String iconName,
    ColorScheme colorScheme,
  ) {
    return Container(
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
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
