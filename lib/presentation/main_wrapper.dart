// lib/presentation/main_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/custom_bottom_bar.dart';
import 'home_screen/home_screen.dart';
import 'product_categories/product_categories.dart';
import 'user_profile/user_profile.dart';
import 'shopping_cart/shopping_cart.dart';
import 'order_tracking/order_tracking.dart';
import '../services/cart_service.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;

  const MainWrapper({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductCategories(),
    const UserProfile(),
    const ShoppingCart(),
    const OrderTracking(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      // Smooth page transition
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: CartService().itemCountNotifier,
        builder: (_, count, __) {
          return CustomBottomBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            cartItemCount: count,
          );
        },
      ),
    );
  }
}