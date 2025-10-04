import 'dart:io';
import 'package:flutter/material.dart';

/// A utility class that provides device-specific adaptations
/// for ensuring optimal functionality across different platforms.
class ScreenAdapter {
  ScreenAdapter._();

  /// Returns true if the device is running iOS
  static bool get isIOS => Platform.isIOS;

  /// Returns true if the device is running Android
  static bool get isAndroid => Platform.isAndroid;

  /// Returns the safe area insets for the current device
  static EdgeInsets safeAreaInsets(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Returns the safe area bottom padding
  static double safeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Returns the safe area top padding (status bar height)
  static double safeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Returns the screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Returns the screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Returns the device pixel ratio
  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Returns the text scale factor
  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Returns true if the device is in dark mode
  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// Returns a platform-specific value
  static T platformSpecific<T>({required T ios, required T android}) {
    return isIOS ? ios : android;
  }

  /// Returns a platform-specific widget
  static Widget platformWidget({
    required Widget Function(BuildContext) iosBuilder,
    required Widget Function(BuildContext) androidBuilder,
  }) {
    return Builder(
      builder: (context) {
        return isIOS ? iosBuilder(context) : androidBuilder(context);
      },
    );
  }
}