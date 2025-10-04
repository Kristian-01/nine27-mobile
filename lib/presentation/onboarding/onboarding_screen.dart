import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to Nine27',
      description: 'Your trusted healthcare partner for all your pharmaceutical needs',
      image: 'assets/images/logo.png',
      backgroundColor: const Color(0xFFE8F5E9),
    ),
    OnboardingItem(
      title: 'Browse Products',
      description: 'Explore our wide range of medicines and healthcare products',
      image: 'assets/images/logo.png',
      backgroundColor: const Color(0xFFE0F7FA),
    ),
    OnboardingItem(
      title: 'Fast Delivery',
      description: 'Get your medications delivered to your doorstep quickly and safely',
      image: 'assets/images/logo.png',
      backgroundColor: const Color(0xFFE8EAF6),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingItems.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_onboardingItems[index]);
            },
          ),
          
          // Skip button
          Positioned(
            top: 6.h,
            right: 6.w,
            child: TextButton(
              onPressed: _navigateToHome,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          // Bottom navigation
          Positioned(
            bottom: 5.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      _onboardingItems.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                  
                  // Next/Done button
                  ElevatedButton(
                    onPressed: () {
                      // Using HapticFeedback with proper import
                      HapticFeedback.mediumImpact();
                      if (_currentPage == _onboardingItems.length - 1) {
                        _navigateToHome();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingItems.length - 1 ? 'Get Started' : 'Next',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Container(
      color: item.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(5.w),
            child: Image.asset(
              item.image,
              fit: BoxFit.contain,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 2.h),
          
          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isCurrentPage = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      height: 1.h,
      width: isCurrentPage ? 6.w : 3.w,
      decoration: BoxDecoration(
        color: isCurrentPage ? const Color(0xFF00C853) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}