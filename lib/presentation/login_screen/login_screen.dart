import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/signup_prompt_widget.dart';
import '../../core/auth_service.dart';
import 'package:dio/dio.dart';
<<<<<<< HEAD

=======
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  bool _isSubmittingLogin = false;
  bool _loginCompleted = false;

  Future<void> _handleLogin(
      String email, String password, bool rememberMe) async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_isSubmittingLogin) return;
    _isSubmittingLogin = true;
    _loginCompleted = false;

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await _authService.login(email: email.trim(), password: password);

<<<<<<< HEAD
        if (res.statusCode == 200){
        HapticFeedback.lightImpact();

=======
      if (res.statusCode == 200) {
        HapticFeedback.lightImpact();
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login successful! Welcome back.'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
<<<<<<< HEAD
          );   

=======
          );
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
          }
        }
        _loginCompleted = true;
<<<<<<< HEAD
        return;
=======
        return; // prevent fallthrough error message
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid email or password. Please try again.'),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
<<<<<<< HEAD
    }on DioException catch (e) {
      if (_loginCompleted) return;
      final msg = e.response?.data is Map && (e.response?.data['message'] is String)
      ? e.response?.data['message'] as String
      : 'Login failed. Please check your connection and try again.';
      if (mounted){
=======
    } on DioException catch (e) {
      if (_loginCompleted) return; // ignore errors after successful nav
      final msg = e.response?.data is Map && (e.response?.data['message'] is String)
          ? e.response?.data['message'] as String
          : 'Login failed. Please check your connection and try again.';
      if (mounted) {
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            duration: const Duration(seconds: 3),
<<<<<<< HEAD
          ),);
      }
    } catch (e) {
      if(_loginCompleted) return;
=======
          ),
        );
      }
    } catch (e) {
      if (_loginCompleted) return; // ignore errors after successful nav
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
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
      _isSubmittingLogin = false;
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Add this new method to handle forgot password navigation
  void _handleForgotPassword() {
    if (_isLoading) return;
    Navigator.pushNamed(context, AppRoutes.forgotPassword);
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

                      // Login Form - Updated to pass the forgot password callback
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        onForgotPassword: _handleForgotPassword, // Add this line
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