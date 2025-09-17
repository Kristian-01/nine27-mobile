import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';

class ForgotPasswordHeaderWidget extends StatelessWidget {
  final bool emailSent;

  const ForgotPasswordHeaderWidget({
    Key? key,
    required this.emailSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: CustomImageWidget(
              imageUrl: 'assets/images/logo-1757725973211.png',
              width: 12.w,
              height: 12.w,
              fit: BoxFit.contain,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Title
        Text(
          emailSent ? 'Check Your Email' : 'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryLight,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 2.h),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            emailSent
                ? 'We\'ve sent a password reset link to your email address. Please check your inbox and spam folder.'
                : 'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondaryLight,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}