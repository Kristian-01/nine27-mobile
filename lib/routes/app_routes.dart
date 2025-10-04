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
import '../presentation/notification_screen/notification_screen.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import 'route_transition_helper.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String initial = splash; // Start with splash screen
  static const String welcome = '/welcome';
  static const String main = '/main';
  static const String onboarding = '/onboarding';
  static const String searchResults = '/search-results';
  static const String shoppingCart = '/shopping-cart';
  static const String home = '/home-screen';
  static const String products = '/products';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String productCategories = '/product-categories';
  static const String userProfile = '/user-profile';
  static const String notifications = '/notifications';

  // Custom page route for smooth transitions with loading indicators
  static Route<dynamic> _createRoute(Widget page) {
    return RouteTransitionHelper.createRoute(page);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _createRoute(const SplashScreen());
      case welcome:
        return _createRoute(const WelcomeScreen());
      case login:
        return _createRoute(const LoginScreen());
      case signup:
        return _createRoute(const SignupScreen());
      case forgotPassword:
        return _createRoute(const ForgotPasswordScreen());
      case onboarding:
        return _createRoute(const OnboardingScreen());
      case main:
        return _createRoute(const MainWrapper());
      case home:
        return _createRoute(const MainWrapper(initialIndex: 0));
      case productCategories:
        return _createRoute(const MainWrapper(initialIndex: 1));
      case userProfile:
        return _createRoute(const MainWrapper(initialIndex: 2));
      case shoppingCart:
        return _createRoute(const MainWrapper(initialIndex: 3));
      case orderTracking:
        return _createRoute(const MainWrapper(initialIndex: 4));
      case products:
        return _createRoute(const ProductsScreen());
      case searchResults:
        return _createRoute(const SearchResults());
      case checkout:
        return _createRoute(const Checkout());
      case notifications:
        return _createRoute(const NotificationScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }

  // Routes map removed as we're using generateRoute instead
  // This avoids conflicts between routes and onGenerateRoute
}