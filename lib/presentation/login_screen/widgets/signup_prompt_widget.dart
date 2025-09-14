import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SignupPromptWidget extends StatelessWidget {
  final VoidCallback? onSignupTap;

  const SignupPromptWidget({
    Key? key,
    this.onSignupTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user? ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
          GestureDetector(
            onTap: onSignupTap ??
                () {
                  Navigator.pushNamed(context, '/signup-screen');
                },
            child: Text(
              'Create Account',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
