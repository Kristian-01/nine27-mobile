// lib/utils/app_utils.dart
import 'package:intl/intl.dart';


class AppUtils {
  // Format currency
  static String formatCurrency(double amount, [String symbol = '₱']) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // Format number with commas
  static String formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(number);
  }

  // Format integer with commas
  static String formatInteger(int number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // Format date with time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(date);
  }

  // Format time only
  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  // Format date for API (ISO format)
  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format datetime for API (ISO format)
  static String formatDateTimeForApi(DateTime date) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS\'Z\'').format(date.toUtc());
  }

  // Parse date from string
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Validate phone number (Philippines format)
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^(\+63|0)?[0-9]{10}$').hasMatch(phone);
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Generate random string
  static String generateId([int length = 10]) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => 
      chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length]
    ).join();
  }

  // Check if string is empty or null
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  // Safe parse double
  static double parseDouble(String? value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    return double.tryParse(value) ?? defaultValue;
  }

  // Safe parse int
  static int parseInt(String? value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  // Format percentage
  static String formatPercentage(double value) {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(value / 100);
  }
}