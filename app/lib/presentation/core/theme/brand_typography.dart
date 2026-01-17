import 'package:flutter/material.dart';

/// Abstract interface for brand typography schemes.
///
/// Implementations provide brand-specific font families and text styles
/// while maintaining a consistent API for theme-aware widgets.
abstract class BrandTypography {
  // Font family bases
  TextStyle get displayFont;
  TextStyle get bodyFont;
  TextStyle get monoFont;

  // Complete Material text theme
  TextTheme get textTheme;

  // Domain-specific styles
  TextStyle get barName;
  TextStyle get price;
  TextStyle get data;
  TextStyle get chip;
  TextStyle get badge;
}
