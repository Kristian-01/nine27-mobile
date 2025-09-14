import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/product_service.dart';

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
      appBar: const CustomAppBar(
        title: 'Products',
        showBackButton: true,
        centerTitle: true,
        showCartAction: true,
        cartItemCount: 3,
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
              return ListTile(
                contentPadding: EdgeInsets.all(3.w),
                tileColor: colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: p['image_url'] != null && (p['image_url'] as String).isNotEmpty
                    ? Image.network(p['image_url'], width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.medication_outlined, size: 32),
                title: Text(p['name'] ?? ''),
                subtitle: Text(p['description'] ?? ''),
                trailing: Text('₱${(p['price'] ?? 0).toString()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              );
            },
          );
        },
      ),
    );
  }
}

