import 'package:dio/dio.dart';
import 'api_client.dart';

class ProductService {
<<<<<<< HEAD
    final Dio _dio = ApiClient.instance.dio;
=======
  final Dio _dio = ApiClient.instance.dio;
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614

  Future<Response<dynamic>> fetchProducts() {
    return _dio.get('/api/products');
  }

<<<<<<< HEAD
  Future<Response<dynamic>> fetchCategories(){
    return _dio.get('/api/categories');
  }

  Future<Response<dynamic>> fetchCategoriesWithProducts({required String slug}){
    return _dio.get('/api/categories/$slug');
  }




=======
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
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
<<<<<<< HEAD
        if (categoryIds !=null) 'category_ids':categoryIds,
      },
    );
  }
}
=======
        if (categoryIds != null) 'category_ids': categoryIds,
      },
    );
  }
}

>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
