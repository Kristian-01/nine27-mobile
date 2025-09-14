import 'package:dio/dio.dart';
import 'api_client.dart';

class ProductService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Response<dynamic>> fetchProducts() {
    return _dio.get('/api/products');
  }

  Future<Response<dynamic>> createProduct({
    required String name,
    required String slug,
    String? description,
    required double price,
    required int stock,
    String? imageUrl,
    List<int>? categoryIds,
  }) {
    return _dio.post(
      '/api/products',
      data: {
        'name': name,
        'slug': slug,
        'description': description,
        'price': price,
        'stock': stock,
        'image_url': imageUrl,
        if (categoryIds != null) 'category_ids': categoryIds,
      },
    );
  }
}

