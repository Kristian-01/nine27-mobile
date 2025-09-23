import 'product.dart';
class Order {
  final int id;
  final String orderNumber;
  final int userId;
  final String status;
  final double subtotal;
  final double taxAmount;
  final double shippingAmount;
  final double discountAmount;
  final double totalAmount;
  final String currency;
  final Map<String, dynamic> billingAddress;
  final Map<String, dynamic> shippingAddress;
  final String? paymentMethod;
  final String paymentStatus;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? orderItems;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.currency,
    required this.billingAddress,
    required this.shippingAddress,
    this.paymentMethod,
    required this.paymentStatus,
    this.shippedAt,
    this.deliveredAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      userId: json['user_id'],
      status: json['status'],
      subtotal: double.parse(json['subtotal'].toString()),
      taxAmount: double.parse(json['tax_amount'].toString()),
      shippingAmount: double.parse(json['shipping_amount'].toString()),
      discountAmount: double.parse(json['discount_amount'].toString()),
      totalAmount: double.parse(json['total_amount'].toString()),
      currency: json['currency'] ?? 'USD',
      billingAddress: json['billing_address'],
      shippingAddress: json['shipping_address'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      shippedAt: json['shipped_at'] != null
          ? DateTime.parse(json['shipped_at'])
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  bool get canBeCancelled => status == 'pending';
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Map<String, dynamic> productSnapshot;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product? product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.productSnapshot,
    required this.createdAt,
    required this.updatedAt,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: double.parse(json['unit_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      productSnapshot: json['product_snapshot'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }
}
