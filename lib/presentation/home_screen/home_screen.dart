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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar with Location
              const SearchBarWidget(),

              // Promotional Banner Carousel
              const PromotionalBannerWidget(),

              SizedBox(height: 4.h),

              // Quick Actions
              const QuickActionsWidget(),

              SizedBox(height: 4.h),

              // Popular Medicines Section
              const ProductSectionWidget(
                title: 'Popular Medicines',
                sectionType: 'popular',
              ),

              // Health Supplements Section
              const ProductSectionWidget(
                title: 'Health Supplements',
                sectionType: 'supplements',
              ),

              // Special Offers Section
              const ProductSectionWidget(
                title: 'Special Offers',
                sectionType: 'offers',
              ),

              // Category Grid
              const CategoryGridWidget(),

              SizedBox(height: 4.h),

              // Health Tips Section
              _buildHealthTipsSection(),

              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        cartItemCount: 3,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          _handleBottomNavigation(index);
        },
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
    final List<Map<String, dynamic>> healthTips = [
      {
        "id": 1,
        "title": "Stay Hydrated",
        "description":
            "Drink at least 8 glasses of water daily for optimal health",
        "icon": "water_drop",
        "color": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "id": 2,
        "title": "Regular Exercise",
        "description":
            "30 minutes of daily exercise can boost your immune system",
        "icon": "fitness_center",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "id": 3,
        "title": "Balanced Diet",
        "description": "Include fruits and vegetables in your daily meals",
        "icon": "restaurant",
        "color": AppTheme.warningLight,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Tips',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: healthTips.length,
            itemBuilder: (context, index) {
              final tip = healthTips[index];
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: (tip["color"] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: tip["icon"] as String,
                        color: tip["color"] as Color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            tip["description"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Content refreshed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Already on Home screen
        break;
      case 1:
        Navigator.pushNamed(context, '/product-categories');
        break;
      case 2:
        Navigator.pushNamed(context, '/user-profile');
        break;
      case 3:
        Navigator.pushNamed(context, '/shopping-cart');
        break;
      case 4:
        Navigator.pushNamed(context, '/order-tracking');
        break;
    }
  }
}
