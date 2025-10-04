// lib/presentation/home_screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/category_grid_widget.dart';
import './widgets/product_section_widget.dart';
import './widgets/promotional_banner_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/search_bar_widget.dart';
import '../../services/cart_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Nine27-Pharmacy',
        showBackButton: false,
        centerTitle: false,
        showCartAction: true,
        cartItemCount: CartService().totalItems,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text('Nine27-Pharmacy'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarWidget(),
            const PromotionalBannerWidget(),
            SizedBox(height: 4.h),
            const QuickActionsWidget(),
            SizedBox(height: 4.h),

            // Static curated sections instead of fetched list
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

            // Categories from backend displayed in grid widget
            const CategoryGridWidget(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/search-results'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: const CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
