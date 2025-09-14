import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppLogoWidget extends StatelessWidget {
  final double? size;
  final bool showTitle;

  const AppLogoWidget({
    Key? key,
    this.size,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 20.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Logo Image
        ClipRRect(
          borderRadius: BorderRadius.circular(logoSize * 0.2), // optional
          child: Image.asset(
            'assets/images/logo.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.cover,
          ),
        ),

        if (showTitle) ...[
          SizedBox(height: 2.h),

          // App Title
          Text(
            'Nine27-Pharmacy',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
          ),

          SizedBox(height: 0.5.h),

          // App Subtitle
          Text(
            'Your Trusted Healthcare Partner',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
