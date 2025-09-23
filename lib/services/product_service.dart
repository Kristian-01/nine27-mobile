// lib/services/product_service.dart
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/product.dart';

class ProductService {
  final Dio _dio = ApiClient.instance.dio;

  Future<ProductResponse> fetchProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? inStockOnly,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null) queryParams['search'] = search;
      if (category != null) queryParams['category'] = category;
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;
      if (inStockOnly != null) queryParams['in_stock_only'] = inStockOnly;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;
      queryParams['page'] = page;
      queryParams['per_page'] = perPage;

      final response = await _dio.get('/products', queryParameters: queryParams);

      // response.data may be:
      // 1) a List (raw list of products)
      // 2) a Map with 'data' that is a List (typical Laravel Resource or pagination)
      // 3) a Map with 'products' list
      // 4) single product object
      final raw = response.data;

      dynamic dataField;
      if (raw is List) {
        dataField = raw;
      } else if (raw is Map<String, dynamic>) {
        // check common keys
        if (raw.containsKey('data')) {
          dataField = raw['data'];
          // sometimes Laravel pagination nests data under data => data
          if (dataField is Map && dataField.containsKey('data')) {
            dataField = dataField['data'];
          }
        } else if (raw.containsKey('products')) {
          dataField = raw['products'];
        } else {
          // fallback to entire map
          dataField = raw;
        }
      } else {
        dataField = raw;
      }

      List<Product> products = [];

      if (dataField is List) {
        products = dataField
            .map<Product>((item) {
              if (item is Product) return item;
              if (item is Map<String, dynamic>) return Product.fromJson(item);
              return Product.fromJson(Map<String, dynamic>.from(item));
            })
            .toList();
      } else if (dataField is Map<String, dynamic>) {
        // Single product or wrapper with 'products' etc.
        if (dataField.containsKey('products') && dataField['products'] is List) {
          products = (dataField['products'] as List)
              .map((i) => Product.fromJson(Map<String, dynamic>.from(i)))
              .toList();
        } else if (dataField.containsKey('id')) {
          // single product object
          products = [Product.fromJson(dataField)];
        } else {
          // unknown structure -> return empty list
          products = [];
        }
      } else {
        products = [];
      }

      return ProductResponse(
        success: true,
        message: 'Products fetched successfully',
        data: products,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = (e.response!.data is Map && e.response!.data['message'] != null)
            ? e.response!.data['message'].toString()
            : 'Request failed with status ${e.response?.statusCode}';
        return ProductResponse(success: false, message: msg);
      }
      return ProductResponse(success: false, message: e.message ?? 'Network error');
    } catch (e) {
      return ProductResponse(success: false, message: 'An unexpected error occurred: $e');
    }
  }

  Future<ProductResponse> fetchProduct(String slug) async {
    try {
      final response = await _dio.get('/products/$slug');
      final raw = response.data;
      dynamic dataField;
      if (raw is Map && raw.containsKey('data')) {
        dataField = raw['data'];
        // nested data -> unwrap
        if (dataField is Map && dataField.containsKey('data')) dataField = dataField['data'];
      } else {
        dataField = raw;
      }

      // If single product object
      if (dataField is Map<String, dynamic>) {
        final product = Product.fromJson(Map<String, dynamic>.from(dataField));
        return ProductResponse(success: true, message: 'Product fetched', data: product);
      }

      return ProductResponse(success: false, message: 'Unexpected product format');
    } on DioException catch (e) {
      return ProductResponse(success: false, message: e.response?.data?['message']?.toString() ?? e.message ?? 'Error');
    } catch (e) {
      return ProductResponse(success: false, message: 'Failed to fetch product: $e');
    }
  }

  Future<ProductResponse> fetchFeaturedProducts() async {
    try {
      final response = await _dio.get('/products/featured');
      final raw = response.data;
      dynamic dataField;
      if (raw is Map && raw.containsKey('data')) dataField = raw['data'];
      else dataField = raw;

      List<Product> products = [];
      if (dataField is List) {
        products = dataField.map((i) => Product.fromJson(Map<String, dynamic>.from(i))).toList();
      } else if (dataField is Map && dataField['products'] is List) {
        products = (dataField['products'] as List).map((i) => Product.fromJson(Map<String, dynamic>.from(i))).toList();
      }

      return ProductResponse(success: true, message: 'Featured fetched', data: products);
    } catch (e) {
      return ProductResponse(success: false, message: 'Failed to fetch featured: $e');
    }
  }

  Future<ProductResponse> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      final raw = response.data;
      // keep raw as-is, your UI code can handle it
      return ProductResponse(success: true, message: 'Categories fetched', data: raw['data'] ?? raw);
    } catch (e) {
      return ProductResponse(success: false, message: 'Failed to fetch categories: $e');
    }
  }

  Future<ProductResponse> fetchCategoryWithProducts(String slug) async {
    try {
      final response = await _dio.get('/categories/$slug');
      final raw = response.data;
      dynamic dataField;
      if (raw is Map && raw.containsKey('data')) dataField = raw['data'];
      else dataField = raw;

      List<Product> products = [];
      if (dataField is Map && dataField['products'] is List) {
        products = (dataField['products'] as List).map((i) => Product.fromJson(Map<String, dynamic>.from(i))).toList();
      } else if (dataField is List) {
        products = dataField.map((i) => Product.fromJson(Map<String, dynamic>.from(i))).toList();
      }

      return ProductResponse(success: true, message: 'Category products fetched', data: products);
    } catch (e) {
      return ProductResponse(success: false, message: 'Failed to fetch category products: $e');
    }
  }
}

class ProductResponse {
  final bool success;
  final String message;
  final dynamic data;

  ProductResponse({
    required this.success,
    required this.message,
    this.data,
  });
}
