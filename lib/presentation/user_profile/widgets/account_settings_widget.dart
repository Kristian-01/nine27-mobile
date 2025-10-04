import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const AccountSettingsWidget({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<AccountSettingsWidget> createState() => _AccountSettingsWidgetState();
}

class _AccountSettingsWidgetState extends State<AccountSettingsWidget> {
  late Map<String, dynamic> _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = Map.from(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(colorScheme),
        SizedBox(height: 3.h),
        _buildNotificationSettings(colorScheme),
        SizedBox(height: 3.h),
        _buildPrivacySettings(colorScheme),
        SizedBox(height: 3.h),
        _buildThemeSettings(colorScheme),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Text(
      'Account Settings',
      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildNotificationSettings(ColorScheme colorScheme) {
    final notifications =
        _currentSettings['notifications'] as Map<String, dynamic>;

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
              CustomIconWidget(
                iconName: 'notifications',
                size: 24,
                color: colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notifications',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSwitchTile(
            'Order Updates',
            'Get notified about your order status',
            notifications['orderUpdates'] ?? true,
            (value) => _updateNotificationSetting('orderUpdates', value),
            colorScheme,
          ),
          _buildSwitchTile(
            'Promotions & Offers',
            'Receive deals and promotional offers',
            notifications['promotions'] ?? false,
            (value) => _updateNotificationSetting('promotions', value),
            colorScheme,
          ),
          _buildSwitchTile(
            'Health Reminders',
            'Medication and health checkup reminders',
            notifications['healthReminders'] ?? true,
            (value) => _updateNotificationSetting('healthReminders', value),
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings(ColorScheme colorScheme) {
    final privacy = _currentSettings['privacy'] as Map<String, dynamic>;

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
              CustomIconWidget(
                iconName: 'privacy',
                size: 24,
                color: colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Privacy',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSwitchTile(
            'Share Health Data',
            'Allow anonymous health data sharing for research',
            privacy['shareHealthData'] ?? false,
            (value) => _updatePrivacySetting('shareHealthData', value),
            colorScheme,
          ),
          _buildSwitchTile(
            'Marketing Emails',
            'Receive marketing emails and newsletters',
            privacy['marketingEmails'] ?? true,
            (value) => _updatePrivacySetting('marketingEmails', value),
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(ColorScheme colorScheme) {
    final currentTheme = _currentSettings['theme'] as String;

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
              CustomIconWidget(
                iconName: 'palette',
                size: 24,
                color: colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'App Theme',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Light'),
                  value: 'light',
                  groupValue: currentTheme,
                  onChanged: (value) => _updateTheme(value!),
                  activeColor: colorScheme.primary,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Dark'),
                  value: 'dark',
                  groupValue: currentTheme,
                  onChanged: (value) => _updateTheme(value!),
                  activeColor: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      _currentSettings['notifications'][key] = value;
    });
    widget.onSettingsChanged(_currentSettings);
  }

  void _updatePrivacySetting(String key, bool value) {
    setState(() {
      _currentSettings['privacy'][key] = value;
    });
    widget.onSettingsChanged(_currentSettings);
  }

  void _updateTheme(String theme) {
    setState(() {
      _currentSettings['theme'] = theme;
    });
    widget.onSettingsChanged(_currentSettings);
  }
}
