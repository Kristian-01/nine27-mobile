import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_item_card.dart';
import './widgets/cart_summary_card.dart';
import './widgets/checkout_button_widget.dart';
import './widgets/empty_cart_widget.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock cart data
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Paracetamol 500mg",
      "category": "Pain Relief",
      "price": 12.99,
      "quantity": 2,
      "stock": 50,
      "image":
          "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "name": "Amoxicillin 250mg",
      "category": "Antibiotics",
      "price": 24.50,
      "quantity": 1,
      "stock": 25,
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "name": "Vitamin D3 1000 IU",
      "category": "Vitamins & Supplements",
      "price": 18.75,
      "quantity": 1,
      "stock": 100,
      "image":
          "https://images.unsplash.com/photo-1550572017-edd951aa8f72?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 4,
      "name": "Lisinopril 10mg",
      "category": "Heart & Blood Pressure",
      "price": 32.00,
      "quantity": 1,
      "stock": 30,
      "image":
          "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  bool _hasUploadedPrescriptions = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: _buildAppBar(colorScheme),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar:
          _cartItems.isNotEmpty ? _buildCheckoutSection() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: colorScheme.onSurface,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Cart',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        if (_cartItems.isNotEmpty)
          TextButton(
            onPressed: _showClearCartDialog,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(width: 2.w),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppTheme.borderLight.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return EmptyCartWidget(
      onContinueShopping: () {
        Navigator.pushNamed(context, '/product-categories');
      },
    );
  }

  Widget _buildCartContent() {
    return RefreshIndicator(
      onRefresh: _refreshCart,
      color: AppTheme.primaryLight,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  _buildCartItemsList(),
                  SizedBox(height: 2.h),
                  _buildCartSummary(),
                  SizedBox(height: 10.h), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return CartItemCard(
          item: item,
          onRemove: () => _removeItem(index),
          onQuantityChanged: (newQuantity) =>
              _updateQuantity(index, newQuantity),
        );
      },
    );
  }

  Widget _buildCartSummary() {
    final subtotal = _calculateSubtotal();
    final tax = subtotal * 0.08; // 8% tax
    final deliveryFee = subtotal > 50 ? 0.0 : 5.99;
    final total = subtotal + tax + deliveryFee;

    return CartSummaryCard(
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
    );
  }

  Widget _buildCheckoutSection() {
    return CheckoutButtonWidget(
      isEnabled: _cartItems.isNotEmpty,
      onPressed: () {
        Navigator.pushNamed(context, '/checkout');
      },
    );
  }

  double _calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + ((item["price"] as double) * (item["quantity"] as int));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Implement undo functionality if needed
          },
        ),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _cartItems[index]["quantity"] = newQuantity;
    });
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Clear Cart',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all items from your cart?',
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondaryLight),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _clearCart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cart cleared successfully'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call to validate stock and pricing
    await Future.delayed(const Duration(seconds: 1));

    // Mock stock validation - randomly mark some items as out of stock
    for (var item in _cartItems) {
      if ((item["id"] as int) % 3 == 0) {
        item["stock"] = 0;
      }
    }

    setState(() {
      _isRefreshing = false;
    });

    // Show stock alerts if any items are out of stock
    final outOfStockItems =
        _cartItems.where((item) => (item["stock"] as int) == 0).toList();
    if (outOfStockItems.isNotEmpty) {
      _showStockAlert(outOfStockItems);
    }
  }

  void _showStockAlert(List<Map<String, dynamic>> outOfStockItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.warningLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Stock Alert',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The following items are currently out of stock:',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              SizedBox(height: 2.h),
              ...outOfStockItems.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Text(
                      '• ${item["name"]}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.errorLight,
                      ),
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Remove Items',
                style: TextStyle(color: AppTheme.errorLight),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search-results');
              },
              child: const Text('Find Alternatives'),
            ),
          ],
        );
      },
    );
  }
}
