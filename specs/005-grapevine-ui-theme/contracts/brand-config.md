# Contract: BrandConfig

**Feature**: 005-grapevine-ui-theme  
**Type**: Dart Class  
**Version**: 1.0

## Purpose

Immutable configuration object that bundles all brand-specific settings. Acts as the single source of truth for brand customization.

## Contract Definition

```dart
/// Immutable configuration for a brand variant.
/// 
/// Provides all customization points for theming including colors,
/// typography, logo, and app display name.
@immutable
class BrandConfig {
  /// The brand identifier
  final AppBrand brand;
  
  /// Display name shown in UI (e.g., "Happy Hour", "Appy Hour")
  final String appName;
  
  /// Asset path for brand logo, null for text-only branding
  final String? logoAsset;
  
  /// Color palette for this brand
  final BrandColors colors;
  
  /// Typography scheme for this brand
  final BrandTypography typography;
  
  const BrandConfig({
    required this.brand,
    required this.appName,
    this.logoAsset,
    required this.colors,
    required this.typography,
  });
  
  /// Returns configuration for the specified brand
  static BrandConfig forBrand(AppBrand brand) => switch (brand) {
    AppBrand.defaultBrand => _defaultConfig,
    AppBrand.grapevine => _grapevineConfig,
  };
  
  /// Returns configuration for the compile-time active brand
  static BrandConfig get current => forBrand(kActiveBrand);
  
  /// Whether this brand has a logo asset
  bool get hasLogo => logoAsset != null;
}
```

## Brand Configurations

### Default Brand

```dart
BrandConfig(
  brand: AppBrand.defaultBrand,
  appName: 'Happy Hour',
  logoAsset: null,  // Text-only header
  colors: DefaultColors(),
  typography: DefaultTypography(),
)
```

### Grapevine Brand

```dart
BrandConfig(
  brand: AppBrand.grapevine,
  appName: 'Appy Hour',
  logoAsset: 'assets/images/grapevine_logo.svg',
  colors: GrapevineColors(),
  typography: GrapevineTypography(),
)
```

## Compile-Time Constant

The active brand is determined by a compile-time constant in `main.dart`:

```dart
/// The active brand for this build.
/// Change this value and rebuild to switch themes.
const AppBrand kActiveBrand = AppBrand.grapevine;
```

## Usage Pattern

```dart
// In main.dart - wrap app with BrandProvider
void main() {
  runApp(
    BrandProvider(
      config: BrandConfig.current,
      child: const HappyHourApp(),
    ),
  );
}

// In widgets - access config
final config = BrandProvider.of(context);
print(config.appName);  // "Appy Hour"
print(config.hasLogo);  // true
```

## Extension Points

To add a new brand:
1. Add value to `AppBrand` enum
2. Create color and typography implementations
3. Add case to `BrandConfig.forBrand()` switch
4. Provide logo asset if applicable
