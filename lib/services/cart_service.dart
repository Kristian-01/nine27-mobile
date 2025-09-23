import '../models/product.dart';

class CartService {
  // Singleton instance
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // List of cart items
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> product) {
    final index = _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (index >= 0) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({...product, "quantity": 1});
    }
  }

  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item['id'] == id);
  }

  void updateQuantity(int id, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _cartItems[index]['quantity'] = newQuantity;
    }
  }

  void clearCart() {
    _cartItems.clear();
  }

  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + ((item["price"] as double) * (item["quantity"] as int));
    });
  }
}
