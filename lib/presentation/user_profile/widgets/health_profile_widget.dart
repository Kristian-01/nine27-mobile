import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthProfileWidget extends StatelessWidget {
  final Map<String, dynamic> healthData;
  final Function(Map<String, dynamic>) onUpdateHealth;

  const HealthProfileWidget({
    super.key,
    required this.healthData,
    required this.onUpdateHealth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(colorScheme),
        SizedBox(height: 3.h),
        _buildHealthSection(
          'Medical Conditions',
          healthData['conditions'] ?? [],
          'health',
          colorScheme,
        ),
        SizedBox(height: 3.h),
        _buildHealthSection(
          'Allergies',
          healthData['allergies'] ?? [],
          'warning',
          colorScheme,
        ),
        SizedBox(height: 3.h),
        _buildHealthSection(
          'Current Medications',
          healthData['medications'] ?? [],
          'pill',
          colorScheme,
        ),
        SizedBox(height: 3.h),
        _buildUpdateButton(colorScheme),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Text(
      'Health Profile',
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildHealthSection(
    String title,
    List<dynamic> items,
    String iconName,
    ColorScheme colorScheme,
  ) {
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
          Row(
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
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (items.isEmpty)
            Text(
              'No ${title.toLowerCase()} recorded',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: items
                  .map((item) => _buildHealthChip(item, colorScheme))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildHealthChip(String item, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderLight.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        item,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildUpdateButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showUpdateHealthDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 2.w),
            Text(
              'Update Health Profile',
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

  void _showUpdateHealthDialog() {
    // This would show a dialog to update health information
    // For now, just trigger the callback with existing data
    onUpdateHealth(healthData);
  }
}
