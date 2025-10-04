// lib/main.dart - FIXED VERSION WITHOUT AUTH OBSERVER CRASHES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/app_export.dart';
import 'core/api_client.dart';
import 'services/auth_service.dart';
import 'widgets/custom_error_widget.dart';
import 'services/notification_manager.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue app startup even if Firebase fails
  }

  // Initialize API client
  try {
    ApiClient.instance.initialize();
  } catch (e) {
    print('API client initialization error: $e');
  }

  // Initialize auth service with error handling
  try {
    final authService = AuthService();
    await authService.initializeAuth();
  } catch (e) {
    print('Auth service initialization error: $e');
    // Continue app startup even if auth init fails
  }

  // Initialize notification manager with error handling
  try {
    await NotificationManager().initialize();
  } catch (e) {
    print('Notification manager initialization error: $e');
  }

  bool _hasShownError = false;

  // Custom error handling
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!_hasShownError) {
      _hasShownError = true;

      Future.delayed(Duration(seconds: 5), () {
        _hasShownError = false;
      });

      return CustomErrorWidget(
        errorDetails: details,
      );
    }
    return SizedBox.shrink();
  };

  // Device orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  const bool kDevicePreviewEnabled = false;
  final bool useDevicePreview = kDevicePreviewEnabled && const bool.fromEnvironment('dart.vm.product') != true;
  
  if (!useDevicePreview) {
    runApp(MyApp(useDevicePreview: false));
  } else {
    runApp(
      DevicePreview(
        enabled: true,
        tools: [...DevicePreview.defaultTools],
        builder: (context) => MyApp(useDevicePreview: true),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool useDevicePreview;
  
  const MyApp({Key? key, this.useDevicePreview = false}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Nine27-Pharmacy',
        useInheritedMediaQuery: useDevicePreview,
        locale: useDevicePreview ? DevicePreview.locale(context) : null,
        builder: (context, child) {
          if (useDevicePreview) {
            child = DevicePreview.appBuilder(context, child);
          }
          
          child = MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
          
          return child;
        },
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
        theme: AppTheme.lightTheme.copyWith(
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
        debugShowCheckedModeBanner: false,
        // REMOVED AuthNavigatorObserver - this was causing the crash
      );
    });
  }
}