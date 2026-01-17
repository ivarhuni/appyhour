import 'package:flutter/material.dart';

/// Abstract interface for brand color palettes.
///
/// Implementations provide brand-specific color values while
/// maintaining a consistent API for theme-aware widgets.
abstract class BrandColors {
  // Background colors
  Color get background;
  Color get backgroundGradientEnd;

  // Surface colors (cards, dialogs, sheets)
  Color get surface;
  Color get surfaceVariant;
  Color get surfaceHigh;

  // Primary accent
  Color get primary;
  Color get primaryLight;
  Color get primaryContainer;
  Color get onPrimaryContainer;

  // Secondary accent
  Color get secondary;

  // Semantic colors
  Color get success;
  Color get successContainer;
  Color get warning;
  Color get warningContainer;
  Color get error;
  Color get errorContainer;
  Color get onErrorContainer;

  // Text colors
  Color get textPrimary;
  Color get textSecondary;
  Color get textTertiary;
  Color get onPrimary;

  // Utility colors
  Color get divider;
  Color get shimmerBase;
  Color get shimmerHighlight;

  // Gradients
  Gradient get cardGradient;
  Gradient get backgroundGradient;
  Gradient get activeGlowGradient;
}
