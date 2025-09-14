import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/signup_prompt_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@nine27pharmacy.com': 'admin123',
    'user@nine27pharmacy.com': 'user123',
    'demo@nine27pharmacy.com': 'demo123',
  };

  Future<void> _handleLogin(
      String email, String password, bool rememberMe) async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email.toLowerCase()) &&
          _mockCredentials[email.toLowerCase()] == password) {
        // Provide haptic feedback for success
        HapticFeedback.lightImpact();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login successful! Welcome back.'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate to main app (simulate)
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/splash-screen');
          }
        }
      } else {
        // Show error for invalid credentials
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  const Text('Invalid email or password. Please try again.'),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Handle network or other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Login failed. Please check your connection and try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBackNavigation() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: _isLoading ? null : _handleBackNavigation,
                          icon: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 6.w,
                          ),
                          padding: EdgeInsets.all(2.w),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // App Logo and Title
                      Center(
                        child: AppLogoWidget(
                          size: 18.w,
                          showTitle: true,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Welcome Text
                      Text(
                        'Welcome Back',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        'Sign in to your account to continue',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 4.h),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),

                      const Spacer(),

                      // Signup Prompt
                      SignupPromptWidget(
                        onSignupTap: _isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, AppRoutes.signup);
                              },
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
