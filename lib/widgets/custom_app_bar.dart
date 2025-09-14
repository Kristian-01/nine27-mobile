import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget for pharmaceutical e-commerce application
/// Implements Clinical Minimalism design with trust-building elements
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showSearchAction;
  final VoidCallback? onSearchPressed;
  final bool showCartAction;
  final VoidCallback? onCartPressed;
  final int? cartItemCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showSearchAction = false,
    this.onSearchPressed,
    this.showCartAction = false,
    this.onCartPressed,
    this.cartItemCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: titleWidget ??
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: foregroundColor ?? colorScheme.onSurface,
            ),
          ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: showBackButton,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: _buildActions(context),
      bottom: elevation > 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: theme.dividerColor.withAlpha(26),
              ),
            )
          : null,
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<Widget> actionWidgets = [];

    // Add search action if enabled
    if (showSearchAction) {
      actionWidgets.add(
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: onSearchPressed ??
              () {
                Navigator.pushNamed(context, '/search-results');
              },
          tooltip: 'Search products',
        ),
      );
    }

    // Add cart action if enabled
    if (showCartAction) {
      actionWidgets.add(
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 24),
              onPressed: onCartPressed ??
                  () {
                    Navigator.pushNamed(context, '/shopping-cart');
                  },
              tooltip: 'Shopping cart',
            ),
            if (cartItemCount != null && cartItemCount! > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
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
                    cartItemCount! > 99 ? '99+' : cartItemCount.toString(),
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
      );
    }

    // Add custom actions if provided
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    // Add padding to the last action
    if (actionWidgets.isNotEmpty) {
      actionWidgets.add(const SizedBox(width: 8));
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (elevation > 0 ? 1 : 0),
      );
}
