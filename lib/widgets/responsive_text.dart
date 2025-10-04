import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A text widget that automatically adjusts its font size based on screen dimensions
class ResponsiveText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Base font size that will be adjusted based on screen size
  final double fontSize;
  
  /// Text style
  final TextStyle? style;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Font weight
  final FontWeight? fontWeight;
  
  /// Text color
  final Color? color;

  const ResponsiveText(
    this.text, {
    Key? key,
    required this.fontSize,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = ResponsiveUtils.responsiveFontSize(context, fontSize);
    
    return Text(
      text,
      style: (style ?? TextStyle()).copyWith(
        fontSize: responsiveFontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A heading text widget with predefined sizes that adapt to screen dimensions
class ResponsiveHeading extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Heading level (1-6)
  final int level;
  
  /// Text style
  final TextStyle? style;
  
  /// Text alignment
  final TextAlign? textAlign;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Text overflow behavior
  final TextOverflow? overflow;
  
  /// Font weight
  final FontWeight? fontWeight;
  
  /// Text color
  final Color? color;

  const ResponsiveHeading(
    this.text, {
    Key? key,
    required this.level,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.color,
  })  : assert(level >= 1 && level <= 6, 'Heading level must be between 1 and 6'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define base font sizes for different heading levels
    final Map<int, double> headingSizes = {
      1: 24.0, // h1
      2: 20.0, // h2
      3: 18.0, // h3
      4: 16.0, // h4
      5: 14.0, // h5
      6: 12.0, // h6
    };

    return ResponsiveText(
      text,
      fontSize: headingSizes[level]!,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }
}