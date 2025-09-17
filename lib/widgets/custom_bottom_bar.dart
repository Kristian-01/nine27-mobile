import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data model for bottom navigation
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar for pharmaceutical e-commerce application
/// Implements adaptive navigation with contextual transformations
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final int? cartItemCount;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.cartItemCount,
  });

  // Hardcoded navigation items for pharmaceutical e-commerce
  static const List<BottomNavItem> _navItems = [
<<<<<<< HEAD
  BottomNavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
    route: '/home-screen',
  ),
  BottomNavItem(
    icon: Icons.category_outlined,
    activeIcon: Icons.category,
    label: 'Categories',
    route: '/product-categories',
  ),
  BottomNavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    route: '/user-profile',
  ),
  BottomNavItem(
    icon: Icons.shopping_cart_outlined,
    activeIcon: Icons.shopping_cart,
    label: 'Cart',
    route: '/shopping-cart',
  ),
  BottomNavItem(
    icon: Icons.local_shipping_outlined,
    activeIcon: Icons.local_shipping,
    label: 'Orders',
    route: '/order-tracking',
  ),
];
=======
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home-screen',
    ),
    BottomNavItem(
      icon: Icons.category_outlined,
      activeIcon: Icons.category,
      label: 'Categories',
      route: '/product-categories',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/user-profile',
    ),
    BottomNavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
      route: '/shopping-cart',
    ),
    BottomNavItem(
      icon: Icons.local_shipping_outlined,
      activeIcon: Icons.local_shipping,
      label: 'Orders',
      route: '/order-tracking',
    ),
  ];
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: elevation,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;
              final isCartItem = item.route == '/shopping-cart';

              return _buildNavItem(
                context,
                item,
                index,
                isSelected,
                isCartItem && cartItemCount != null && cartItemCount! > 0,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    int index,
    bool isSelected,
    bool showBadge,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final itemColor = isSelected
        ? (selectedItemColor ?? colorScheme.primary)
        : (unselectedItemColor ?? colorScheme.onSurface.withAlpha(153));

    return Expanded(
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(index);
          } else {
<<<<<<< HEAD
           if (isSelected) return;
    Navigator.pushReplacementNamed(context, item.route);
=======
            if (isSelected) return;
            Navigator.pushReplacementNamed(context, item.route);
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(8),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: colorScheme.primary.withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      isSelected && item.activeIcon != null
                          ? item.activeIcon!
                          : item.icon,
                      color: itemColor,
                      size: 24,
                    ),
                  ),
                  if (showBadge)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartItemCount! > 99
                              ? '99+'
                              : cartItemCount.toString(),
                          style: GoogleFonts.inter(
                            color: colorScheme.onError,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: itemColor,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
