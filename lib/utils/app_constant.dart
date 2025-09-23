// lib/utils/app_constants.dart
class AppConstants {
  // Authentication constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  
  // Validation constants
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^(\+63|0)?[0-9]{10}$'; // Philippines phone format
  static const String nameRegex = r'^[a-zA-Z\s]+$';
  
  // API constants
  static const String baseUrl = 'https://api.nine27.com';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  
  // App settings
  static const String appName = 'Nine27';
  static const String appVersion = '1.0.0';
  
  // Cache constants
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Order constants
  static const double minOrderAmount = 100.0;
  static const double maxOrderAmount = 50000.0;
  static const int maxItemsPerOrder = 50;
  
  // File upload constants
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['.jpg', '.jpeg', '.png', '.gif'];
  static const List<String> allowedDocumentTypes = ['.pdf', '.doc', '.docx'];
}