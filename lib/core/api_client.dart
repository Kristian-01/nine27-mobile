import 'package:dio/dio.dart';
import 'config.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
<<<<<<< HEAD
}
=======
}

>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
