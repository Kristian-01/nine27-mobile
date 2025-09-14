import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditAvatar;
  final VoidCallback onEditProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditAvatar,
    required this.onEditProfile,
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
        children: [
          _buildAvatarSection(colorScheme),
          SizedBox(height: 3.h),
          _buildUserInfo(colorScheme),
          SizedBox(height: 2.h),
          _buildEditButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(ColorScheme colorScheme) {
    return Stack(
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: userData['avatar'] ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.backgroundLight,
                child: CustomIconWidget(
                  iconName: 'person',
                  size: 12.w,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.backgroundLight,
                child: CustomIconWidget(
                  iconName: 'person',
                  size: 12.w,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEditAvatar,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'edit',
                size: 4.w,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          userData['name'] ?? 'User Name',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'star',
                size: 16,
                color: colorScheme.primary,
              ),
              SizedBox(width: 1.w),
              Text(
                userData['membershipStatus'] ?? 'Basic',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          userData['email'] ?? 'email@example.com',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEditButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onEditProfile,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              size: 18,
              color: colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Edit Profile',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
