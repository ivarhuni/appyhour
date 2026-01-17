# Quickstart: Grapevine UI Theme

**Feature**: 005-grapevine-ui-theme  
**Date**: 2025-01-17

## Overview

This guide explains how to switch between the "Happy Hour" (default) and "Appy Hour" (Grapevine) UI themes.

---

## Switching Themes

### Step 1: Open main.dart

```
app/lib/main.dart
```

### Step 2: Change the Brand Constant

Find the `kActiveBrand` constant near the top of the file:

```dart
/// The active brand for this build.
/// Change this value and rebuild to switch themes.
const AppBrand kActiveBrand = AppBrand.grapevine;  // ← Change this
```

### Step 3: Available Values

| Value | Theme | App Name |
|-------|-------|----------|
| `AppBrand.defaultBrand` | Dark red | "Happy Hour" |
| `AppBrand.grapevine` | Teal/orange | "Appy Hour" |

### Step 4: Rebuild the App

```bash
cd app
flutter run
```

That's it! The entire app will render with the selected theme.

---

## For Widget Developers

### Accessing Brand Configuration

Use `BrandProvider.of(context)` to access brand-specific values:

```dart
@override
Widget build(BuildContext context) {
  final brand = BrandProvider.of(context);
  
  return Container(
    color: brand.colors.background,
    child: Column(
      children: [
        // Logo (if available) or app name
        if (brand.hasLogo)
          SvgPicture.asset(brand.logoAsset!, height: 32)
        else
          Text(brand.appName, style: brand.typography.barName),
          
        // Use brand colors
        Text(
          'Welcome',
          style: TextStyle(color: brand.colors.primary),
        ),
      ],
    ),
  );
}
```

### Theme-Aware Widgets Pattern

For widgets that need significant visual differences between brands:

```dart
class BarListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brand = BrandProvider.of(context);
    
    // Use switch for brand-specific layouts
    return switch (brand.brand) {
      AppBrand.defaultBrand => _buildDefaultLayout(context, brand),
      AppBrand.grapevine => _buildGrapevineLayout(context, brand),
    };
  }
  
  Widget _buildDefaultLayout(BuildContext context, BrandConfig brand) {
    // Original styling
  }
  
  Widget _buildGrapevineLayout(BuildContext context, BrandConfig brand) {
    // Editorial magazine styling
  }
}
```

### Using Colors

```dart
final colors = BrandProvider.of(context).colors;

// Primary accent (red for default, teal for grapevine)
colors.primary

// Secondary accent (for CTAs, links)
colors.secondary

// Text colors
colors.textPrimary
colors.textSecondary

// Gradients
Container(
  decoration: BoxDecoration(gradient: colors.backgroundGradient),
)
```

### Using Typography

```dart
final typography = BrandProvider.of(context).typography;

// Domain-specific styles
Text(bar.name, style: typography.barName);
Text('1,200 kr', style: typography.price);

// Material text theme
Text('Headline', style: typography.textTheme.headlineMedium);
```

---

## File Structure

After implementation, theme-related files are organized as:

```
app/lib/presentation/core/
├── brand/
│   ├── brand.dart           # Export barrel
│   ├── app_brand.dart       # AppBrand enum
│   ├── brand_config.dart    # BrandConfig class
│   └── brand_provider.dart  # InheritedWidget
└── theme/
    ├── theme.dart           # Export barrel
    ├── app_theme.dart       # ThemeData builder (uses brand)
    ├── brand_colors.dart    # Abstract interface
    ├── default_colors.dart  # Dark red palette
    ├── grapevine_colors.dart    # Teal/orange palette
    ├── brand_typography.dart    # Abstract interface
    ├── default_typography.dart  # Playfair + Jakarta
    └── grapevine_typography.dart # Lora + Source Sans
```

---

## Assets

The Grapevine logo is located at:

```
app/assets/images/grapevine_logo.svg
```

To use it:

```dart
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  'assets/images/grapevine_logo.svg',
  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
  height: 32,
)
```

---

## Testing Both Themes

To test both themes:

1. Set `kActiveBrand = AppBrand.defaultBrand`, rebuild, test
2. Set `kActiveBrand = AppBrand.grapevine`, rebuild, test

Widget tests can override the brand by wrapping with a test `BrandProvider`:

```dart
testWidgets('renders with grapevine theme', (tester) async {
  await tester.pumpWidget(
    BrandProvider(
      config: BrandConfig.forBrand(AppBrand.grapevine),
      child: const MaterialApp(home: BarList()),
    ),
  );
  
  expect(find.byType(SvgPicture), findsOneWidget);
});
```

---

## Troubleshooting

### Logo Not Showing

1. Verify `pubspec.yaml` has assets declared:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
2. Run `flutter pub get`
3. Restart the app (hot reload may not pick up new assets)

### Fonts Not Loading

Google Fonts are fetched on first use. Ensure network connectivity or use `--dart-define=FLUTTER_WEB_USE_SKIA=true` for web.

### Theme Not Changing

Ensure you're changing `kActiveBrand` and doing a full rebuild (not just hot reload for const changes).
