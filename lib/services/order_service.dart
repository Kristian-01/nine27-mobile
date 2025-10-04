// lib/services/order_service.dart - Fixed
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class OrderService {
  final Dio _dio = ApiClient.instance.dio;
  final AuthService _authService = AuthService();

  Future<OrderResponse> getOrders({int page = 1}) async {
    try {
      // Verify user is authenticated before fetching orders
      final token = await _authService.getToken();
      if (token == null) {
        return OrderResponse(
          success: false,
          message: 'Authentication required',
        );
      }
      
      final response = await _dio.get('/orders', queryParameters: {
        'page': page,
      });

      return OrderResponse(
        success: true,
        message: 'Orders fetched successfully',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return OrderResponse(
        success: false,
        message: 'Failed to fetch orders',
      );
    }
  }

  Future<OrderResponse> getOrder(int orderId) async {
    try {
      // Verify user is authenticated before fetching order details
      final token = await _authService.getToken();
      if (token == null) {
        return OrderResponse(
          success: false,
          message: 'Authentication required',
        );
      }
      
      final response = await _dio.get('/orders/$orderId');

      return OrderResponse(
        success: true,
        message: 'Order fetched successfully',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return OrderResponse(
        success: false,
        message: 'Failed to fetch order',
      );
    }
  }

  Future<OrderResponse> createOrder({
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      final payload = {
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'payment_method': paymentMethod,
      };
      if (items != null && items.isNotEmpty) {
        payload['items'] = items;
      }

      final response = await _dio.post('/orders', data: payload);

      return OrderResponse(
        success: response.statusCode == 201,
        message: response.data['message'] ?? 'Order placed successfully',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return OrderResponse(
        success: false,
        message: 'Failed to place order',
      );
    }
  }

  Future<OrderResponse> cancelOrder(int orderId) async {
    try {
      final response = await _dio.patch('/orders/$orderId/cancel');

      return OrderResponse(
        success: true,
        message: response.data['message'] ?? 'Order cancelled successfully',
        data: response.data['data'],
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return OrderResponse(
        success: false,
        message: 'Failed to cancel order',
      );
    }
  }

  OrderResponse _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      String message = 'An error occurred';

      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
      }

      return OrderResponse(
        success: false,
        message: message,
      );
    } else {
      return OrderResponse(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }
}

class OrderResponse {
  final bool success;
  final String message;
  final dynamic data;

  OrderResponse({
    required this.success,
    required this.message,
    this.data,
  });
}