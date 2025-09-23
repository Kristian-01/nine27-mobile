// lib/models/product.dart

class Product {
  final dynamic id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int? stock;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.stock,
  });

  /// Factory constructor to build Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // --- Handle price ---
    final rawPrice = json['price'] ?? json['price_amount'] ?? json['amount'];
    double parsedPrice = 0.0;
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice != null) {
      parsedPrice = double.tryParse(rawPrice.toString()) ?? 0.0;
    }

    // --- Handle image ---
    String? image;
    if (json['imageUrl'] != null) {
      image = json['imageUrl'].toString();
    } else if (json['image_url'] != null) {
      image = json['image_url'].toString();
    } else if (json['image'] != null) {
      image = json['image'].toString();
    }

    // --- Handle stock ---
    int? parsedStock;
    if (json['stock'] != null) {
      final s = json['stock'];
      parsedStock = s is int ? s : int.tryParse(s.toString());
    }

    return Product(
      id: json['id'] ?? json['product_id'] ?? json['uuid'],
      name: (json['name'] ?? json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      price: parsedPrice,
      imageUrl: image,
      stock: parsedStock,
    );
  }

  /// Convert Product to JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }

  @override
  String toString() => 'Product{id: $id, name: $name, price: $price}';
}
