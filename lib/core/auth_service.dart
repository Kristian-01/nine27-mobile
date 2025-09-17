import 'package:dio/dio.dart';
import 'package:medicart/core/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Response<dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return _dio.post(
      '/api/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<Response<dynamic>> login({
    required String email,
    required String password,
    bool remember = false,
  }) async {
    return _dio.post(
      '/api/login',
      data: {
        'email': email,
        'password': password,
        'remember': remember,
      },
    );
  }
}