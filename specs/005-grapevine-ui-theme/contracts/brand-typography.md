# Contract: BrandTypography Interface

**Feature**: 005-grapevine-ui-theme  
**Type**: Dart Abstract Class  
**Version**: 1.0

## Purpose

Defines the typography contract that all brand typography implementations must fulfill. Ensures consistent text style access across themes.

## Contract Definition

```dart
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
```

## Implementations

### DefaultTypography

| Style | Font | Weight |
|-------|------|--------|
| Display/Headlines | Playfair Display | 600-700 |
| Body | Plus Jakarta Sans | 400 |
| Mono/Data | Fira Code | 500 |

### GrapevineTypography

| Style | Font | Weight |
|-------|------|--------|
| Display/Headlines | Lora | 600-700 |
| Body | Source Sans 3 | 400 |
| Mono/Data | Fira Code | 500 |

## Usage Pattern

```dart
// Access via BrandProvider
final typography = BrandProvider.of(context).typography;

Text(
  'Bar Name',
  style: typography.barName,
);

// Or use textTheme for Material styles
Text(
  'Headline',
  style: typography.textTheme.headlineMedium,
);
```

## Font Loading

All fonts are loaded via Google Fonts package. No custom font files required.

```dart
// GrapevineTypography example
TextStyle get displayFont => GoogleFonts.lora();
TextStyle get bodyFont => GoogleFonts.sourceSans3();
```

## Breaking Change Policy

Adding new text styles requires:
1. Update this contract
2. Update all implementations
3. Ensure new styles have appropriate fallbacks
