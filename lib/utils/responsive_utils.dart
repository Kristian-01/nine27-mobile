import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// A utility class that provides responsive design helpers
/// for adapting UI to different screen sizes and orientations.
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Device type breakpoints
  // Updated breakpoints to better support iOS tablets and large screens
  static const double mobileBreakpoint = 600;   // <600 = phone
  static const double tabletBreakpoint = 1200;  // 600..1199 = tablet (incl. iPads)
  static const double desktopBreakpoint = 1440; // >=1440 = desktop/large

  /// Returns true if the current device is a mobile phone
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Returns true if the current device is a tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Returns true if the current device is a desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Returns the device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    if (isMobile(context)) return DeviceType.mobile;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Returns a responsive value based on the screen size
  /// [mobile] - value for mobile screens
  /// [tablet] - value for tablet screens
  /// [desktop] - value for desktop screens
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }

  /// Returns a responsive font size based on screen size
  static double responsiveFontSize(BuildContext context, double size) {
    // Using sizer package to calculate responsive font size
    return size.sp;
  }

  /// Returns a responsive height based on screen height percentage
  static double responsiveHeight(double percent) {
    return percent.h;
  }

  /// Returns a responsive width based on screen width percentage
  static double responsiveWidth(double percent) {
    return percent.w;
  }

  /// Returns a responsive padding based on screen size
  static EdgeInsets responsivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left?.w ?? horizontal?.w ?? all?.w ?? 0,
      top: top?.h ?? vertical?.h ?? all?.h ?? 0,
      right: right?.w ?? horizontal?.w ?? all?.w ?? 0,
      bottom: bottom?.h ?? vertical?.h ?? all?.h ?? 0,
    );
  }

  /// Returns a responsive margin based on screen size
  static EdgeInsets responsiveMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: left?.w ?? horizontal?.w ?? all?.w ?? 0,
      top: top?.h ?? vertical?.h ?? all?.h ?? 0,
      right: right?.w ?? horizontal?.w ?? all?.w ?? 0,
      bottom: bottom?.h ?? vertical?.h ?? all?.h ?? 0,
    );
  }

  /// Returns a safe area padding for the current device
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
}

/// Enum representing different device types
enum DeviceType { mobile, tablet, desktop }