// lib/routes/app_routes.dart - Updated with splash screen
import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/search_results/search_results.dart';
import '../presentation/checkout/checkout.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/products/products_screen.dart';
import '../presentation/main_wrapper.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String initial = splash; // Start with splash screen
  static const String main = '/main';
  static const String searchResults = '/search-results';
  static const String shoppingCart = '/shopping-cart';
  static const String home = '/home-screen';
  static const String products = '/products';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String productCategories = '/product-categories';
  static const String userProfile = '/user-profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    
    // Main wrapper for bottom navigation
    main: (context) => const MainWrapper(),
    
    // Individual screens via MainWrapper
    home: (context) => const MainWrapper(initialIndex: 0),
    productCategories: (context) => const MainWrapper(initialIndex: 1),
    userProfile: (context) => const MainWrapper(initialIndex: 2),
    shoppingCart: (context) => const MainWrapper(initialIndex: 3),
    orderTracking: (context) => const MainWrapper(initialIndex: 4),
    
    // Standalone screens
    products: (context) => const ProductsScreen(),
    searchResults: (context) => const SearchResults(),
    checkout: (context) => const Checkout(),
    
    // Legacy routes
    '/login-screen': (context) => const LoginScreen(),
    '/signup-screen': (context) => const SignupScreen(),
  };
}