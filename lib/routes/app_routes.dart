import 'package:flutter/material.dart';
import '../presentation/search_results/search_results.dart';
import '../presentation/shopping_cart/shopping_cart.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/checkout/checkout.dart';
import '../presentation/order_tracking/order_tracking.dart';
import '../presentation/product_categories/product_categories.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/signup_screen/signup_screen.dart';

class AppRoutes {
  // ✅ Correct type names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String initial = login; // Start at login, change to home if needed
  static const String searchResults = '/search-results';
  static const String shoppingCart = '/shopping-cart';
  static const String home = '/home-screen';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String productCategories = '/product-categories';
  static const String userProfile = '/user-profile';

  // ✅ Route mapping
  static Map<String, WidgetBuilder> routes = {
  login: (context) => const LoginScreen(),
  signup: (context) => const SignupScreen(),
  home: (context) => const HomeScreen(),
  searchResults: (context) => const SearchResults(),
  shoppingCart: (context) => const ShoppingCart(),
  checkout: (context) => const Checkout(),
  orderTracking: (context) => const OrderTracking(),
  productCategories: (context) => const ProductCategories(),
  userProfile: (context) => const UserProfile(),

   '/login-screen': (context) => const LoginScreen(),
  '/signup-screen': (context) => const SignupScreen(),
};
}
