// lib/utils/constants.dart - Fixed
class AppConstants {
  static const String appName = 'Medicart';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const int connectionTimeout = 10000;
  static const int receiveTimeout = 15000;
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isFirstRunKey = 'is_first_run';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderProcessing = 'processing';
  static const String orderShipped = 'shipped';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
  
  // Payment Methods
  static const String paymentCash = 'cash_on_delivery';
  static const String paymentCard = 'credit_card';
  static const String paymentPayPal = 'paypal';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 255;
  static const int maxEmailLength = 255;
  static const int maxPhoneLength = 20;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 0.0;
}
