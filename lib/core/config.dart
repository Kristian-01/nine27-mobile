// lib/config.dart
import 'dart:io';

class ApiConfig {
  static final String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _getDefaultApiBaseUrl(),
  );

 static String _getDefaultApiBaseUrl() {
  if (Platform.isAndroid) {
    return "http://192.168.1.8:8000/api"; // Use LAN IP for Android phone
  } else if (Platform.isIOS) {
    return "http://192.168.1.8:8000/api"; // Use LAN IP for iOS device
  } else {
    return "http://192.168.1.8:8000/api"; // Fallback
  }
}
}
