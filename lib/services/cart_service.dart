import 'package:flutter/foundation.dart';

class CartService {
  // Singleton instance
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // List of cart items
  final List<Map<String, dynamic>> _cartItems = [];

  // Reactive cart item count (sum of quantities)
  final ValueNotifier<int> itemCountNotifier = ValueNotifier<int>(0);

  List<Map<String, dynamic>> get cartItems => _cartItems;

  int get totalItems => _cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

  void _notifyCountChanged() {
    itemCountNotifier.value = totalItems;
  }

  void addToCart(Map<String, dynamic> product) {
    final index = _cartItems.indexWhere((item) => item['id'] == product['id']);

    // Normalize and provide safe defaults
    final normalized = Map<String, dynamic>.from(product);

    // Ensure price is a double
    final rawPrice = normalized['price'];
    if (rawPrice is String) {
      final cleaned = rawPrice.replaceAll(RegExp(r'[^0-9\.]'), '');
      normalized['price'] = double.tryParse(cleaned) ?? 0.0;
    } else if (rawPrice is num) {
      normalized['price'] = rawPrice.toDouble();
    } else {
      normalized['price'] = 0.0;
    }

    // Defaults for fields used in UI/validation
    normalized['image'] = normalized['image']?.toString() ?? '';
    normalized['stock'] = (normalized['stock'] as int?) ?? 999;
    normalized['category'] = normalized['category']?.toString() ?? '';
    normalized['prescription_required'] =
        (normalized['prescription_required'] as bool?) ??
        (normalized['isPrescriptionRequired'] as bool?) ?? false;

    if (index >= 0) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({...normalized, "quantity": 1});
    }
    _notifyCountChanged();
  }

  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item['id'] == id);
    _notifyCountChanged();
  }

  void updateQuantity(int id, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      _cartItems[index]['quantity'] = newQuantity;
      if (_cartItems[index]['quantity'] <= 0) {
        _cartItems.removeAt(index);
      }
      _notifyCountChanged();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _notifyCountChanged();
  }

  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + ((item["price"] as double) * (item["quantity"] as int));
    });
  }
}
