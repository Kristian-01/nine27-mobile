// lib/presentation/home_screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/category_grid_widget.dart';
import './widgets/product_section_widget.dart';
import './widgets/promotional_banner_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/search_bar_widget.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response = await _productService.fetchProducts();

    if (response.success) {
      try {
        final data = response.data;
        // data may already be List<Product> or List<Map> from service
        if (data is List<Product>) {
          _products = data;
        } else if (data is List) {
          _products = data.map<Product>((item) {
            if (item is Product) return item;
            if (item is Map<String, dynamic>) return Product.fromJson(item);
            return Product.fromJson(Map<String, dynamic>.from(item));
          }).toList();
        } else {
          // unexpected but safely handle
          _products = [];
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = "Failed to parse products: $e";
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _error = response.message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Nine27-Pharmacy',
        showBackButton: false,
        centerTitle: false,
        showCartAction: true,
        cartItemCount: 3,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text('Nine27-Pharmacy'),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _fetchProducts,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text("Error: $_error"))
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SearchBarWidget(),
                        const PromotionalBannerWidget(),
                        SizedBox(height: 4.h),
                        const QuickActionsWidget(),
                        SizedBox(height: 4.h),

                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Text(
                            "Fetched Products (${_products.length})",
                            style: AppTheme.lightTheme.textTheme.titleLarge,
                          ),
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ListTile(
                              leading: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                                  ? Image.network(
                                      product.imageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, st) => const Icon(Icons.broken_image),
                                    )
                                  : const Icon(
                                      Icons.medication,
                                      size: 40,
                                    ),
                              title: Text(product.name),
                              subtitle: Text("₱${product.price.toStringAsFixed(2)}"),
                            );
                          },
                        ),

                        const ProductSectionWidget(
                          title: 'Popular Medicines',
                          sectionType: 'popular',
                        ),
                        const ProductSectionWidget(
                          title: 'Health Supplements',
                          sectionType: 'supplements',
                        ),
                        const ProductSectionWidget(
                          title: 'Special Offers',
                          sectionType: 'offers',
                        ),
                        const CategoryGridWidget(),
                        SizedBox(height: 4.h),
                        _buildHealthTipsSection(),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/search-results'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHealthTipsSection() {
    return Container();
  }
}
