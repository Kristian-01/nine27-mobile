import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  /// Builder function for mobile layout
  final Widget Function(BuildContext context) mobileBuilder;
  
  /// Builder function for tablet layout (optional)
  final Widget Function(BuildContext context)? tabletBuilder;
  
  /// Builder function for desktop layout
  final Widget Function(BuildContext context) desktopBuilder;

  const ResponsiveBuilder({
    super.key,
    required this.mobileBuilder,
    this.tabletBuilder,
    required this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) {
      return desktopBuilder(context);
    }
    
    if (ResponsiveUtils.isTablet(context)) {
      return tabletBuilder?.call(context) ?? desktopBuilder(context);
    }
    
    return mobileBuilder(context);
  }
}

/// A widget that adapts its layout based on screen orientation
class ResponsiveOrientationBuilder extends StatelessWidget {
  /// Builder function for portrait orientation
  final Widget Function(BuildContext context) portraitBuilder;
  
  /// Builder function for landscape orientation
  final Widget Function(BuildContext context) landscapeBuilder;

  const ResponsiveOrientationBuilder({
    super.key,
    required this.portraitBuilder,
    required this.landscapeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    
    if (orientation == Orientation.portrait) {
      return portraitBuilder(context);
    } else {
      return landscapeBuilder(context);
    }
  }
}

/// A widget that provides responsive spacing based on screen size
class ResponsiveSpacer extends StatelessWidget {
  /// Height of the spacer (responsive)
  final double? height;
  
  /// Width of the spacer (responsive)
  final double? width;

  const ResponsiveSpacer({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height != null ? ResponsiveUtils.responsiveHeight(height!) : null,
      width: width != null ? ResponsiveUtils.responsiveWidth(width!) : null,
    );
  }
}

/// A widget that provides responsive padding based on screen size
class ResponsivePadding extends StatelessWidget {
  /// Child widget
  final Widget child;
  
  /// Padding on all sides
  final double? all;
  
  /// Horizontal padding
  final double? horizontal;
  
  /// Vertical padding
  final double? vertical;
  
  /// Left padding
  final double? left;
  
  /// Top padding
  final double? top;
  
  /// Right padding
  final double? right;
  
  /// Bottom padding
  final double? bottom;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.responsivePadding(
        all: all,
        horizontal: horizontal,
        vertical: vertical,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: child,
    );
  }
}