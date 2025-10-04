/// A configuration class for responsive design settings
class ResponsiveConfig {
  // Singleton instance
  static final ResponsiveConfig _instance = ResponsiveConfig._internal();
  factory ResponsiveConfig() => _instance;
  ResponsiveConfig._internal();

  // Breakpoints
  final double mobileBreakpoint = 600;
  final double tabletBreakpoint = 900;
  final double desktopBreakpoint = 1200;

  // Spacing scales
  final Map<String, double> spacingScale = {
    'xs': 4.0,
    'sm': 8.0,
    'md': 16.0,
    'lg': 24.0,
    'xl': 32.0,
    '2xl': 48.0,
  };

  // Font size scales
  final Map<String, double> fontSizeScale = {
    'xs': 12.0,
    'sm': 14.0,
    'md': 16.0,
    'lg': 18.0,
    'xl': 20.0,
    '2xl': 24.0,
    '3xl': 30.0,
    '4xl': 36.0,
  };

  // Border radius scales
  final Map<String, double> borderRadiusScale = {
    'xs': 4.0,
    'sm': 8.0,
    'md': 12.0,
    'lg': 16.0,
    'xl': 24.0,
    'full': 9999.0,
  };

  // Device-specific adjustments
  final Map<String, double> iosAdjustments = {
    'buttonHeight': 48.0,
    'inputHeight': 44.0,
    'bottomNavHeight': 84.0,
  };

  final Map<String, double> androidAdjustments = {
    'buttonHeight': 48.0,
    'inputHeight': 48.0,
    'bottomNavHeight': 80.0,
  };

  // Get device-specific adjustment
  double getDeviceAdjustment(String key, bool isIOS) {
    return isIOS 
        ? iosAdjustments[key] ?? 0.0
        : androidAdjustments[key] ?? 0.0;
  }

  // Get spacing value
  double getSpacing(String key) {
    return spacingScale[key] ?? spacingScale['md']!;
  }

  // Get font size value
  double getFontSize(String key) {
    return fontSizeScale[key] ?? fontSizeScale['md']!;
  }

  // Get border radius value
  double getBorderRadius(String key) {
    return borderRadiusScale[key] ?? borderRadiusScale['md']!;
  }
}