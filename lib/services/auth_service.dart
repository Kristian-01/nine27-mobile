// lib/services/auth_service.dart - CRASH-SAFE VERSION
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/api_client.dart';
import 'dart:convert';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  static const String _lastLoginKey = 'last_login_time';
  
  // Use secure storage for sensitive data with error handling
  FlutterSecureStorage? _secureStorage;
  
  FlutterSecureStorage get secureStorage {
    try {
      _secureStorage ??= const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
      return _secureStorage!;
    } catch (e) {
      print('SecureStorage initialization error: $e');
      // Return a basic instance without options if that fails
      return const FlutterSecureStorage();
    }
  }

  // Check if user is logged in and should stay logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getToken();
      final rememberMe = await isRememberMeEnabled();
      final lastLogin = await _getLastLoginTime();
      
      if (token == null || token.isEmpty) return false;
      
      if (rememberMe && lastLogin != null) {
        final now = DateTime.now();
        final loginTime = DateTime.fromMillisecondsSinceEpoch(lastLogin);
        final daysDifference = now.difference(loginTime).inDays;
        return daysDifference <= 30;
      }
      
      if (lastLogin != null) {
        final now = DateTime.now();
        final loginTime = DateTime.fromMillisecondsSinceEpoch(lastLogin);
        final hoursDifference = now.difference(loginTime).inHours;
        return hoursDifference <= 8;
      }
      
      return false;
    } catch (e) {
      print('isUserLoggedIn error: $e');
      return false;
    }
  }

  // Get stored token with error handling
  Future<String?> getToken() async {
    try {
      final token = await secureStorage.read(key: _tokenKey);
      if (token != null) return token;
    } catch (e) {
      print('SecureStorage read error: $e');
    }
    
    // Fallback to regular preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('SharedPreferences read error: $e');
      return null;
    }
  }

  // Save token with error handling
  Future<void> _saveToken(String token, {bool rememberMe = false}) async {
    try {
      await secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      print('SecureStorage write error: $e');
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setBool(_rememberMeKey, rememberMe);
      await prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('SharedPreferences write error: $e');
    }
    
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } catch (e) {
      print('Dio header update error: $e');
    }
  }

  // Get last login time with error handling
  Future<int?> _getLastLoginTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_lastLoginKey);
    } catch (e) {
      print('Get last login time error: $e');
      return null;
    }
  }

  // Save credentials with error handling
  Future<void> _saveCredentials(String email, String password) async {
    try {
      await secureStorage.write(key: 'saved_email', value: email);
      await secureStorage.write(key: 'saved_password', value: password);
    } catch (e) {
      print('Save credentials error: $e');
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', email);
      } catch (e2) {
        print('Fallback save email error: $e2');
      }
    }
  }

  // Get saved credentials with comprehensive error handling
  Future<Map<String, String?>> getSavedCredentials() async {
    try {
      final rememberMe = await isRememberMeEnabled();
      
      if (!rememberMe) {
        return {'email': null, 'password': null};
      }
      
      try {
        final email = await secureStorage.read(key: 'saved_email');
        final password = await secureStorage.read(key: 'saved_password');
        return {'email': email, 'password': password};
      } catch (e) {
        print('SecureStorage read credentials error: $e');
        try {
          final prefs = await SharedPreferences.getInstance();
          final email = prefs.getString('saved_email');
          return {'email': email, 'password': null};
        } catch (e2) {
          print('Fallback read email error: $e2');
          return {'email': null, 'password': null};
        }
      }
    } catch (e) {
      print('getSavedCredentials error: $e');
      return {'email': null, 'password': null};
    }
  }

  // Check if remember me is enabled with error handling
  Future<bool> isRememberMeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      print('isRememberMeEnabled error: $e');
      return false;
    }
  }

  // Save user data with error handling
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(userData));
    } catch (e) {
      print('Save user data error: $e');
    }
  }
  
  // Get stored user data with error handling
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataStr = prefs.getString(_userKey);
      if (userDataStr != null) {
        return json.decode(userDataStr);
      }
    } catch (e) {
      print('getUserData error: $e');
    }
    return null;
  }

  // Clear stored data with error handling
  Future<void> _clearStoredData({bool keepRememberMe = false}) async {
    try {
      await secureStorage.delete(key: _tokenKey);
      if (!keepRememberMe) {
        await secureStorage.delete(key: 'saved_email');
        await secureStorage.delete(key: 'saved_password');
      }
    } catch (e) {
      print('SecureStorage delete error: $e');
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      await prefs.remove(_lastLoginKey);
      
      if (!keepRememberMe) {
        await prefs.remove(_rememberMeKey);
        await prefs.remove('saved_email');
      }
    } catch (e) {
      print('SharedPreferences clear error: $e');
    }
    
    try {
      _dio.options.headers.remove('Authorization');
    } catch (e) {
      print('Dio header remove error: $e');
    }
  }

  // Initialize auth with comprehensive error handling
  Future<void> initializeAuth() async {
    try {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        final isSessionValid = await isUserLoggedIn();
        
        if (isSessionValid) {
          try {
            _dio.options.headers['Authorization'] = 'Bearer $token';
          } catch (e) {
            print('Initialize auth header error: $e');
          }
        } else {
          await _clearStoredData(keepRememberMe: true);
        }
      }
    } catch (e) {
      print('initializeAuth error: $e');
      // Don't throw - just log and continue
    }
  }

  // LOGIN METHOD with better error handling
  Future<AuthResponse> login({
    required String email,
    required String password,
    bool remember = false,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'remember': remember,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _saveToken(data['token'], rememberMe: remember);
        await _saveUserData(data['user']);
        
        if (remember) {
          await _saveCredentials(email, password);
        } else {
          try {
            await secureStorage.delete(key: 'saved_email');
            await secureStorage.delete(key: 'saved_password');
          } catch (e) {
            print('Clear credentials error: $e');
          }
        }

        return AuthResponse(
          success: true,
          message: response.data['message'] ?? 'Login successful',
          data: data,
        );
      }

      return AuthResponse(
        success: false,
        message: response.data['message'] ?? 'Login failed',
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      print('Login error: $e');
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // REGISTER METHOD
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      if (response.statusCode == 201) {
        final data = response.data['data'];
        await _saveToken(data['token'], rememberMe: false);
        await _saveUserData(data['user']);

        return AuthResponse(
          success: true,
          message: response.data['message'] ?? 'Registration successful',
          data: data,
        );
      }

      return AuthResponse(
        success: false,
        message: response.data['message'] ?? 'Registration failed',
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // LOGOUT METHOD
  Future<AuthResponse> logout({bool clearRememberMe = false}) async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      print('Logout API error: $e');
    }
    
    await _clearStoredData(keepRememberMe: !clearRememberMe);
    return AuthResponse(
      success: true,
      message: 'Logged out successfully',
    );
  }

  // FORGOT PASSWORD METHOD
  Future<AuthResponse> forgotPassword(String email) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? 'Password reset link sent',
          data: response.data,
        );
      }

      return AuthResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to send reset link',
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }

  // GET PROFILE METHOD
  Future<AuthResponse> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');

      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: 'Profile fetched successfully',
          data: response.data['data'],
        );
      }

      return AuthResponse(
        success: false,
        message: 'Failed to fetch profile',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _clearStoredData(keepRememberMe: true);
      }
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Failed to fetch profile',
      );
    }
  }

  // UPDATE PROFILE METHOD
  Future<AuthResponse> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;

      final response = await _dio.put('/auth/profile', data: data);

      if (response.statusCode == 200) {
        await _saveUserData(response.data['data']);
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? 'Profile updated',
          data: response.data['data'],
        );
      }

      return AuthResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to update profile',
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Enhanced error handling
  AuthResponse _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      String message;
      Map<String, dynamic>? errors;

      if (data is Map<String, dynamic>) {
        message = data['message'] ?? _getDefaultErrorMessage(statusCode);
        errors = data['errors'];
      } else {
        message = _getDefaultErrorMessage(statusCode);
      }

      return AuthResponse(
        success: false,
        message: message,
        errors: errors,
      );
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return AuthResponse(
        success: false,
        message: 'Connection timeout. Check your internet.',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return AuthResponse(
        success: false,
        message: 'Request timeout. Try again.',
      );
    } else {
      return AuthResponse(
        success: false,
        message: 'Network error. Check your connection.',
      );
    }
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Check your input.';
      case 401:
        return 'Invalid credentials. Try again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Service not found.';
      case 422:
        return 'Validation error. Check your input.';
      case 500:
        return 'Server error. Try again later.';
      default:
        return 'An error occurred. Try again.';
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
    return 'AuthResponse(success: $success, message: $message)';
  }
}