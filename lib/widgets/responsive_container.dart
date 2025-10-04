import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A container widget that adapts its size and styling based on screen dimensions
class ResponsiveContainer extends StatelessWidget {
  /// Child widget
  final Widget child;
  
  /// Width as percentage of screen width (0-100)
  final double? width;
  
  /// Height as percentage of screen height (0-100)
  final double? height;
  
  /// Maximum width in pixels
  final double? maxWidth;
  
  /// Maximum height in pixels
  final double? maxHeight;
  
  /// Padding configuration
  final EdgeInsetsGeometry? padding;
  
  /// Margin configuration
  final EdgeInsetsGeometry? margin;
  
  /// Background color
  final Color? color;
  
  /// Border radius
  final BorderRadius? borderRadius;
  
  /// Box shadow
  final List<BoxShadow>? boxShadow;
  
  /// Border configuration
  final Border? border;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? ResponsiveUtils.responsiveWidth(width!) : null,
      height: height != null ? ResponsiveUtils.responsiveHeight(height!) : null,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        border: border,
      ),
      child: child,
    );
  }
}

/// A grid layout that adapts its column count based on screen size
class ResponsiveGridView extends StatelessWidget {
  /// List of child widgets
  final List<Widget> children;
  
  /// Number of columns for mobile layout
  final int mobileColumns;
  
  /// Number of columns for tablet layout
  final int tabletColumns;
  
  /// Number of columns for desktop layout
  final int desktopColumns;
  
  /// Spacing between items
  final double spacing;
  
  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 4,
    this.spacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = ResponsiveUtils.responsive(
      context,
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}