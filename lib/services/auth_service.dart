// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  // Update this to match your Laravel server URL
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For production or if using different IP/domain:
  // static const String baseUrl = 'http://192.168.1.100:8000/api'; // Local network
  // static const String baseUrl = 'https://yourdomain.com/api'; // Production

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Send forgot password email
  static Future<AuthResponse> sendForgotPasswordEmail(String email) async {
    try {
      print('Sending forgot password request to: $baseUrl/forgot-password');
      print('Email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: headers,
        body: jsonEncode({
          'email': email,
        }),
      ).timeout(
        const Duration(seconds: 30), // 30 second timeout
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: data['message'] ?? 'Password reset link sent successfully!',
          data: data,
        );
      } else if (response.statusCode == 404) {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Email address not found.',
        );
      } else if (response.statusCode == 422) {
        // Validation errors
        String errorMessage = data['message'] ?? 'Validation failed';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          if (errors['email'] != null) {
            errorMessage = (errors['email'] as List).first;
          }
        }
        return AuthResponse(
          success: false,
          message: errorMessage,
          errors: data['errors'],
        );
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Failed to send reset link. Please try again.',
        );
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      return AuthResponse(
        success: false,
        message: 'Network error. Please check your internet connection.',
      );
    } on http.ClientException catch (e) {
      print('Client Exception: $e');
      return AuthResponse(
        success: false,
        message: 'Connection failed. Please check if the server is running.',
      );
    } on FormatException catch (e) {
      print('Format Exception: $e');
      return AuthResponse(
        success: false,
        message: 'Invalid response from server.',
      );
    } catch (e) {
      print('General Exception: $e');
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Reset password with token
  static Future<AuthResponse> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      print('Sending reset password request to: $baseUrl/reset-password');
      
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: headers,
        body: jsonEncode({
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      print('Reset password response status: ${response.statusCode}');
      print('Reset password response body: ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: data['message'] ?? 'Password reset successfully!',
          data: data,
        );
      } else if (response.statusCode == 400) {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Invalid or expired reset token.',
        );
      } else if (response.statusCode == 422) {
        // Validation errors
        String errorMessage = data['message'] ?? 'Validation failed';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          // Get the first error message
          for (var errorList in errors.values) {
            if (errorList is List && errorList.isNotEmpty) {
              errorMessage = errorList.first;
              break;
            }
          }
        }
        return AuthResponse(
          success: false,
          message: errorMessage,
          errors: data['errors'],
        );
      } else {
        return AuthResponse(
          success: false,
          message: data['message'] ?? 'Failed to reset password. Please try again.',
        );
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      return AuthResponse(
        success: false,
        message: 'Network error. Please check your internet connection.',
      );
    } on http.ClientException catch (e) {
      print('Client Exception: $e');
      return AuthResponse(
        success: false,
        message: 'Connection failed. Please check if the server is running.',
      );
    } on FormatException catch (e) {
      print('Format Exception: $e');
      return AuthResponse(
        success: false,
        message: 'Invalid response from server.',
      );
    } catch (e) {
      print('General Exception: $e');
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Test API connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? errors;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, data: $data, errors: $errors)';
  }
}