import 'package:flutter/material.dart';
import 'package:medicart/widgets/custom_app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../services/product_service.dart';
import '../../services/cart_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Products',
        showBackButton: true,
        centerTitle: true,
        showCartAction: true,
        cartItemCount: CartService().totalItems,
      ),
      body: FutureBuilder(
        future: _productService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load products', style: Theme.of(context).textTheme.bodyLarge),
            );
          }
          final data = (snapshot.data?.data?['data'] ?? []) as List<dynamic>;
          if (data.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Text('No products yet. Add some via POST /api/products.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(4.w),
            itemCount: data.length,
            separatorBuilder: (_, __) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final p = data[index] as Map<String, dynamic>;
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    p['image_url'] != null && (p['image_url'] as String).isNotEmpty
                        ? Image.network(p['image_url'], width: 56, height: 56, fit: BoxFit.cover)
                        : const Icon(Icons.medication_outlined, size: 32),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['name'] ?? ''),
                          SizedBox(height: 0.5.h),
                          Text(p['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₱${(p['price'] ?? 0).toString()}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        SizedBox(height: 0.5.h),
                        ElevatedButton(
                          onPressed: () {
                            final product = {
                              'id': p['id'],
                              'name': p['name'],
                              'price': (p['price'] as num?)?.toDouble() ?? 0.0,
                              'image': p['image_url'] ?? '',
                              'quantity': 1,
                            };
                            CartService().addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

