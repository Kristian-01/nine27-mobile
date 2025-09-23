// lib/services/auth_service.dart - ENHANCED VERSION WITH IMPROVED REMEMBER ME
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  static const String _lastLoginKey = 'last_login_time';
  
  // Use secure storage for sensitive data
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Check if user is logged in and should stay logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getToken();
      final rememberMe = await isRememberMeEnabled();
      final lastLogin = await _getLastLoginTime();
      
      if (token == null || token.isEmpty) return false;
      
      // If remember me is enabled, check if login is still valid (within 30 days)
      if (rememberMe && lastLogin != null) {
        final now = DateTime.now();
        final loginTime = DateTime.fromMillisecondsSinceEpoch(lastLogin);
        final daysDifference = now.difference(loginTime).inDays;
        
        // Keep user logged in for 30 days if remember me was checked
        return daysDifference <= 30;
      }
      
      // If remember me is not enabled, check if session is recent (1 day)
      if (lastLogin != null) {
        final now = DateTime.now();
        final loginTime = DateTime.fromMillisecondsSinceEpoch(lastLogin);
        final hoursDifference = now.difference(loginTime).inHours;
        
        return hoursDifference <= 24; // 1 day session without remember me
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      // Fallback to regular preferences if secure storage fails
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    }
  }

  // Save token and remember me data
  Future<void> _saveToken(String token, {bool rememberMe = false}) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      // Fallback to regular preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
    await prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
    
    // Update dio header with new token
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Get last login time
  Future<int?> _getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastLoginKey);
  }

  // Save remember me credentials securely
  Future<void> _saveCredentials(String email, String password) async {
    try {
      await _secureStorage.write(key: 'saved_email', value: email);
      await _secureStorage.write(key: 'saved_password', value: password);
    } catch (e) {
      // If secure storage fails, don't save passwords in regular storage
      // Only save email in regular preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
    }
  }

  // Get saved credentials
  Future<Map<String, String?>> getSavedCredentials() async {
    final rememberMe = await isRememberMeEnabled();
    
    if (!rememberMe) {
      return {'email': null, 'password': null};
    }
    
    try {
      final email = await _secureStorage.read(key: 'saved_email');
      final password = await _secureStorage.read(key: 'saved_password');
      return {'email': email, 'password': password};
    } catch (e) {
      // Fallback - only get email from regular preferences
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('saved_email');
      return {'email': email, 'password': null};
    }
  }

  // Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // Save user data
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData.toString());
  }

  // Clear stored data with option to keep remember me
  Future<void> _clearStoredData({bool keepRememberMe = false}) async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      if (!keepRememberMe) {
        await _secureStorage.delete(key: 'saved_email');
        await _secureStorage.delete(key: 'saved_password');
      }
    } catch (e) {
      // Fallback cleanup
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      if (!keepRememberMe) {
        await prefs.remove('saved_email');
      }
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_lastLoginKey);
    
    if (!keepRememberMe) {
      await prefs.remove(_rememberMeKey);
    }
    
    _dio.options.headers.remove('Authorization');
  }

  // Initialize auth headers if token exists and is valid
  Future<void> initializeAuth() async {
    final isLoggedIn = await isUserLoggedIn();
    if (isLoggedIn) {
      final token = await getToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
    } else {
      // Clear invalid session data
      await _clearStoredData(keepRememberMe: true);
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
        await _saveToken(data['token'], rememberMe: false); // Don't auto-remember on register
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
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // LOGIN METHOD - Enhanced with better remember me
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
        
        // Save credentials only if remember me is enabled
        if (remember) {
          await _saveCredentials(email, password);
        } else {
          // Clear any previously saved credentials if not remembering
          try {
            await _secureStorage.delete(key: 'saved_email');
            await _secureStorage.delete(key: 'saved_password');
          } catch (e) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('saved_email');
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
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // LOGOUT METHOD
  Future<AuthResponse> logout({bool clearRememberMe = false}) async {
    try {
      await _dio.post('/auth/logout');
      await _clearStoredData(keepRememberMe: !clearRememberMe);

      return AuthResponse(
        success: true,
        message: 'Logged out successfully',
      );
    } on DioException catch (e) {
      // Clear local data even if server call fails
      await _clearStoredData(keepRememberMe: !clearRememberMe);
      return AuthResponse(
        success: true,
        message: 'Logged out successfully',
      );
    }
  }

  // FORGOT PASSWORD METHOD - Enhanced
  Future<AuthResponse> forgotPassword(String email) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        return AuthResponse(
          success: true,
          message: response.data['message'] ?? 'Password reset link sent to your email',
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
        message: 'Network error. Please check your connection and try again.',
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
      // If unauthorized, clear stored auth data
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
          message: response.data['message'] ?? 'Profile updated successfully',
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

  // RESET PASSWORD METHOD
  Future<AuthResponse> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post('/auth/reset-password', data: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      return AuthResponse(
        success: response.statusCode == 200,
        message: response.data['message'] ?? 'Password reset successfully',
        data: response.data,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
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
        message: 'Connection timeout. Please check your internet connection.',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return AuthResponse(
        success: false,
        message: 'Request timeout. Please try again.',
      );
    } else {
      return AuthResponse(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Invalid credentials. Please try again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Service not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
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