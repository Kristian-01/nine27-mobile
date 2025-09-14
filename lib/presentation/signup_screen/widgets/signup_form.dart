import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './password_strength_indicator.dart';
import './terms_checkbox.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAccepted;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const SignupForm({
    Key? key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isTermsAccepted,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    required this.onTermsChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final Map<String, bool> _fieldValidation = {
    'fullName': false,
    'email': false,
    'password': false,
    'confirmPassword': false,
  };

  void _updateFieldValidation(String field, bool isValid) {
    setState(() {
      _fieldValidation[field] = isValid;
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      _updateFieldValidation('fullName', false);
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      _updateFieldValidation('fullName', false);
      return 'Full name must be at least 2 characters';
    }
    _updateFieldValidation('fullName', true);
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      _updateFieldValidation('email', false);
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      _updateFieldValidation('email', false);
      return 'Please enter a valid email address';
    }
    _updateFieldValidation('email', true);
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      _updateFieldValidation('password', false);
      return 'Password is required';
    }
    if (value.length < 8) {
      _updateFieldValidation('password', false);
      return 'Password must be at least 8 characters';
    }
    _updateFieldValidation('password', true);
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      _updateFieldValidation('confirmPassword', false);
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      _updateFieldValidation('confirmPassword', false);
      return 'Passwords do not match';
    }
    _updateFieldValidation('confirmPassword', true);
    return null;
  }

  Widget _buildValidationIcon(String field) {
    final isValid = _fieldValidation[field] ?? false;
    return isValid
        ? CustomIconWidget(
            iconName: 'check_circle',
            color: const Color(0xFF059669),
            size: 20,
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          TextFormField(
            controller: widget.fullNameController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: _validateFullName,
            onChanged: (value) => _validateFullName(value),
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              suffixIcon: _buildValidationIcon('fullName'),
            ),
          ),
          SizedBox(height: 3.h),

          // Email Field
          TextFormField(
            controller: widget.emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onChanged: (value) => _validateEmail(value),
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              suffixIcon: _buildValidationIcon('email'),
            ),
          ),
          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            textInputAction: TextInputAction.next,
            obscureText: !widget.isPasswordVisible,
            validator: _validatePassword,
            onChanged: (value) {
              _validatePassword(value);
              setState(() {}); // Trigger rebuild for strength indicator
            },
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildValidationIcon('password'),
                  IconButton(
                    onPressed: widget.onPasswordVisibilityToggle,
                    icon: CustomIconWidget(
                      iconName: widget.isPasswordVisible
                          ? 'visibility_off'
                          : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Password Strength Indicator
          PasswordStrengthIndicator(password: widget.passwordController.text),
          SizedBox(height: 3.h),

          // Confirm Password Field
          TextFormField(
            controller: widget.confirmPasswordController,
            textInputAction: TextInputAction.done,
            obscureText: !widget.isConfirmPasswordVisible,
            validator: _validateConfirmPassword,
            onChanged: (value) => _validateConfirmPassword(value),
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildValidationIcon('confirmPassword'),
                  IconButton(
                    onPressed: widget.onConfirmPasswordVisibilityToggle,
                    icon: CustomIconWidget(
                      iconName: widget.isConfirmPasswordVisible
                          ? 'visibility_off'
                          : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Terms and Privacy Policy Checkbox
          TermsCheckbox(
            isChecked: widget.isTermsAccepted,
            onChanged: widget.onTermsChanged,
            onTermsTap: widget.onTermsTap,
            onPrivacyTap: widget.onPrivacyTap,
          ),
        ],
      ),
    );
  }
}
