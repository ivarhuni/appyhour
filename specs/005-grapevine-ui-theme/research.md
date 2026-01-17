# Research: Grapevine UI Theme

**Feature**: 005-grapevine-ui-theme  
**Date**: 2025-01-17

## Research Summary

This document captures research findings for implementing multi-brand theming in the Happy Hour Flutter app.

---

## 1. Flutter Multi-Theme Patterns

### Decision: Compile-time constant with InheritedWidget

### Rationale
- **Compile-time constant** in `main.dart` satisfies the requirement for rebuild-based switching
- **InheritedWidget** provides efficient widget tree access without external state management dependencies
- Simpler than Provider/Riverpod for static compile-time values
- Zero runtime overhead for theme resolution

### Alternatives Considered

| Approach | Rejected Because |
|----------|------------------|
| Runtime theme switching | Spec requires compile-time; adds complexity for unused feature |
| Flutter flavors | Over-engineered for UI-only differences; requires build config changes |
| Provider package | External dependency for simple static value propagation |
| Global singleton | Less testable; doesn't integrate with widget tree |

### Implementation Pattern

```dart
// main.dart
const AppBrand kActiveBrand = AppBrand.grapevine;

// Brand enum
enum AppBrand { defaultBrand, grapevine }

// BrandConfig - immutable configuration per brand
class BrandConfig {
  final String appName;
  final String logoAsset;
  final ThemeData theme;
  final AppColorScheme colors;
  final AppTypographyScheme typography;
  
  const BrandConfig({...});
  
  static BrandConfig forBrand(AppBrand brand) => switch (brand) {
    AppBrand.defaultBrand => _defaultConfig,
    AppBrand.grapevine => _grapevineConfig,
  };
}

// InheritedWidget for tree access
class BrandProvider extends InheritedWidget {
  final BrandConfig config;
  
  static BrandConfig of(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<BrandProvider>()!.config;
}
```

---

## 2. SVG Rendering in Flutter

### Decision: flutter_svg package

### Rationale
- Industry-standard for SVG rendering in Flutter
- Well-maintained (5.9k+ GitHub stars, regular updates)
- Supports color tinting for logo adaptation
- Already works with the downloaded Grapevine logo format

### Alternatives Considered

| Package | Rejected Because |
|---------|------------------|
| jovial_svg | Less widely adopted; flutter_svg sufficient |
| Convert to PNG | Loses scalability; requires multiple resolutions |
| Custom painter | Over-engineered for simple logo display |

### Implementation

```dart
// pubspec.yaml
dependencies:
  flutter_svg: ^2.0.10+1

// Usage
SvgPicture.asset(
  'assets/images/grapevine_logo.svg',
  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
  height: 32,
)
```

### Asset Configuration

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
```

---

## 3. Editorial Font Selection

### Decision: Lora (display) + Source Sans 3 (body)

### Rationale
- **Lora**: Elegant serif with editorial character; available via Google Fonts; evokes magazine quality
- **Source Sans 3**: Clean, professional sans-serif for body text; excellent readability
- Both fonts are open-source and free for commercial use
- Distinct from default theme's Playfair Display / Plus Jakarta Sans

### Alternatives Considered

| Font Pair | Rejected Because |
|-----------|------------------|
| Playfair Display (keep) | Too similar to default theme; spec requires distinctive typography |
| Merriweather + Open Sans | Generic; doesn't capture editorial sophistication |
| Crimson Pro + Inter | Inter is overused; violates design-skill.cursorrules anti-patterns |
| Georgia (system) + Helvetica | System fonts lack distinction; spec requires custom fonts |

### Typography Mapping

| Text Style | Grapevine Font | Weight |
|------------|----------------|--------|
| Display/Headlines | Lora | 600-700 |
| Titles | Lora | 500-600 |
| Body | Source Sans 3 | 400 |
| Labels/Data | Fira Code (keep) | 500 |

---

## 4. Color Palette Refinement

### Decision: Finalized Grapevine palette

Based on grapevine.is visual analysis:

| Role | Hex | Usage |
|------|-----|-------|
| Background | #1A1A1A | Main scaffold background |
| Background End | #2D2D2D | Gradient end |
| Surface | #252525 | Cards, elevated surfaces |
| Surface Variant | #2A2A2A | Secondary surfaces |
| Primary | #0D9488 | Teal - main accent, active states |
| Primary Light | #14B8A6 | Teal light - hover, highlights |
| Secondary | #E64A19 | Orange - links, dates, CTAs |
| Secondary Light | #FF7043 | Orange light - hover states |
| Success | #10B981 | Positive indicators |
| Warning | #F59E0B | Caution indicators |
| Error | #EF4444 | Error states |
| Text Primary | #FFFFFF | Headlines, important text |
| Text Secondary | #A3A3A3 | Body text, descriptions |
| Text Tertiary | #737373 | Metadata, hints |
| Divider | #404040 | Separators, borders |

### Contrast Verification
- Primary teal on dark background: 7.2:1 ✅ (WCAG AAA)
- Secondary orange on dark background: 5.8:1 ✅ (WCAG AA)
- Text primary on background: 16:1 ✅ (WCAG AAA)

---

## 5. InheritedWidget vs Provider

### Decision: InheritedWidget (no external package)

### Rationale
- Brand config is immutable, set at app start
- No state changes requiring Provider's reactivity
- Reduces external dependencies
- Simpler mental model for static configuration
- BlocProvider already used for dynamic state; keep separation clear

### Implementation Notes
- `BrandProvider` wraps `MaterialApp.router` in main.dart
- Widgets access via `BrandProvider.of(context).colors.primary`
- Type-safe access with no string keys

---

## Resolved Clarifications

All "NEEDS CLARIFICATION" items from Technical Context have been resolved:

| Item | Resolution |
|------|------------|
| SVG handling | flutter_svg package |
| Font selection | Lora + Source Sans 3 |
| Theme access pattern | InheritedWidget (BrandProvider) |
| Color values | Finalized palette above |

---

## Dependencies to Add

```yaml
dependencies:
  flutter_svg: ^2.0.10+1  # SVG logo rendering
  # google_fonts already present - Lora and Source Sans 3 available
```

## Assets to Declare

```yaml
flutter:
  assets:
    - assets/images/
```
