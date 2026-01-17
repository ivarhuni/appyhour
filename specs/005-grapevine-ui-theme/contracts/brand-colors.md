# Contract: BrandColors Interface

**Feature**: 005-grapevine-ui-theme  
**Type**: Dart Abstract Class  
**Version**: 1.0

## Purpose

Defines the color contract that all brand color implementations must fulfill. Ensures consistent color property access across themes.

## Contract Definition

```dart
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
```

## Implementations

### DefaultColors

Original dark-red theme colors. Must maintain exact values from existing `AppColors` class.

### GrapevineColors

New teal/orange theme colors per research.md palette specification.

## Usage Pattern

```dart
// Access via BrandProvider
final colors = BrandProvider.of(context).colors;

Container(
  color: colors.background,
  child: Text('Hello', style: TextStyle(color: colors.textPrimary)),
);
```

## Breaking Change Policy

Adding new color properties requires:
1. Update this contract
2. Update all implementations (DefaultColors, GrapevineColors)
3. Provide sensible defaults or migration path
