import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/signup_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isLoading = false;

  // Mock user data for validation
  final List<Map<String, dynamic>> _existingUsers = [
    {
      "email": "john.doe@example.com",
      "fullName": "John Doe",
    },
    {
      "email": "jane.smith@example.com",
      "fullName": "Jane Smith",
    },
    {
      "email": "admin@authflow.com",
      "fullName": "Admin User",
    },
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true && _isTermsAccepted;
  }

  Future<void> _handleSignup() async {
    if (!_isFormValid()) {
      if (!_isTermsAccepted) {
        _showErrorMessage(
            'Please accept the Terms of Service and Privacy Policy');
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email already exists
      final emailExists = (_existingUsers as List).any((dynamic user) =>
          (user as Map<String, dynamic>)['email']?.toString().toLowerCase() ==
          _emailController.text.trim().toLowerCase());

      if (emailExists) {
        _showErrorMessage('An account with this email already exists');
        return;
      }

      // Simulate successful registration
      _showSuccessMessage('Account created successfully! Welcome to AuthFlow!');

      // Navigate to login screen after success
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    } catch (e) {
      _showErrorMessage('Registration failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleTermsTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms of Service',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Text(
            'Welcome to AuthFlow. By creating an account, you agree to our terms and conditions. This includes responsible use of our services, protection of your account credentials, and compliance with applicable laws.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handlePrivacyTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. We collect and use your information to provide and improve our services. We do not sell your personal data to third parties and implement security measures to protect your information.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Create Account',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: CustomIconWidget(
                        iconName: 'person_add',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 10.w,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Nine27-Pharmacy',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Create your account to get started with secure authentication',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),

              // Signup Form
              SignupForm(
                formKey: _formKey,
                fullNameController: _fullNameController,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                isPasswordVisible: _isPasswordVisible,
                isConfirmPasswordVisible: _isConfirmPasswordVisible,
                isTermsAccepted: _isTermsAccepted,
                onPasswordVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                  HapticFeedback.lightImpact();
                },
                onConfirmPasswordVisibilityToggle: () {
                  setState(() =>
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                  HapticFeedback.lightImpact();
                },
                onTermsChanged: (value) {
                  setState(() => _isTermsAccepted = value ?? false);
                  HapticFeedback.selectionClick();
                },
                onTermsTap: _handleTermsTap,
                onPrivacyTap: _handlePrivacyTap,
              ),
              SizedBox(height: 6.h),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid()
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    foregroundColor: _isFormValid()
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Create Account',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 4.h),

              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushReplacementNamed(
                            context, '/login-screen');
                      },
                      child: Text(
                        'Sign In',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
