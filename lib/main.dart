// lib/main.dart - Updated with proper authentication routing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'core/app_export.dart';
import 'core/api_client.dart';
import 'services/auth_service.dart';
import 'widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client first
  ApiClient.instance.initialize();

  // Initialize auth service
  final authService = AuthService();
  await authService.initializeAuth();

  bool _hasShownError = false;

  // Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!_hasShownError) {
      _hasShownError = true;

      // Reset flag after 5 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        _hasShownError = false;
      });

      return CustomErrorWidget(
        errorDetails: details,
      );
    }
    return SizedBox.shrink();
  };

  // Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Nine27-Pharmacy',
        theme: AppTheme.lightTheme.copyWith(
          // Customize theme for Nine27-Pharmacy
          primaryColor: const Color(0xFF00C853),
          colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
            primary: const Color(0xFF00C853),
            secondary: const Color(0xFF00E676),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C853),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial, // This starts with splash screen
        // Add navigation observer for auth state management
        navigatorObservers: [
          AuthNavigatorObserver(),
        ],
      );
    });
  }
}

// Observer to handle authentication-based navigation
class AuthNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkAuthenticationStatus(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _checkAuthenticationStatus(previousRoute);
    }
  }

  void _checkAuthenticationStatus(Route<dynamic> route) async {
    // Skip auth check for splash, login, signup, and forgot password screens
    final publicRoutes = [
      AppRoutes.initial, // splash screen
      AppRoutes.login,
      AppRoutes.signup,
      '/forgot-password-screen',
    ];

    if (publicRoutes.contains(route.settings.name)) {
      return;
    }

    // For protected routes, verify authentication
    final authService = AuthService();
    final isLoggedIn = await authService.isUserLoggedIn();

    if (!isLoggedIn && route.navigator != null) {
      // User is not authenticated, redirect to login
      route.navigator!.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }
}