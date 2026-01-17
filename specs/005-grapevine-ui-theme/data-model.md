# Data Model: Grapevine UI Theme

**Feature**: 005-grapevine-ui-theme  
**Date**: 2025-01-17

## Overview

This feature introduces brand abstraction entities for multi-theme support. No domain entities are modified; all new entities exist in the presentation layer.

---

## Entities

### AppBrand (Enum)

Identifies available brand variants.

| Value | Description |
|-------|-------------|
| `defaultBrand` | Original "Happy Hour" dark-red theme |
| `grapevine` | "Appy Hour" teal/orange editorial theme |

**Notes**:
- `defaultBrand` instead of `default` to avoid Dart keyword conflict
- Compile-time constant selects active brand

---

### BrandConfig (Immutable Class)

Complete configuration for a brand variant.

| Field | Type | Description |
|-------|------|-------------|
| `brand` | `AppBrand` | Brand identifier |
| `appName` | `String` | Display name (e.g., "Happy Hour", "Appy Hour") |
| `logoAsset` | `String?` | Asset path for logo (null for text-only) |
| `colors` | `BrandColors` | Color palette for this brand |
| `typography` | `BrandTypography` | Typography scheme for this brand |

**Factory Methods**:
- `BrandConfig.forBrand(AppBrand brand)` → Returns config for given brand
- `BrandConfig.current` → Returns config for compile-time active brand

---

### BrandColors (Abstract Interface)

Defines required color properties for any brand theme.

| Property | Type | Description |
|----------|------|-------------|
| `background` | `Color` | Main scaffold background |
| `backgroundGradientEnd` | `Color` | Gradient end color |
| `surface` | `Color` | Card/elevated surface color |
| `surfaceVariant` | `Color` | Secondary surface color |
| `surfaceHigh` | `Color` | Highest elevation surface |
| `primary` | `Color` | Main accent color |
| `primaryLight` | `Color` | Lighter primary variant |
| `secondary` | `Color` | Secondary accent color |
| `primaryContainer` | `Color` | Primary container background |
| `onPrimaryContainer` | `Color` | Text on primary container |
| `success` | `Color` | Success/positive indicator |
| `successContainer` | `Color` | Success container background |
| `warning` | `Color` | Warning indicator |
| `warningContainer` | `Color` | Warning container background |
| `error` | `Color` | Error indicator |
| `errorContainer` | `Color` | Error container background |
| `onErrorContainer` | `Color` | Text on error container |
| `textPrimary` | `Color` | Primary text color |
| `textSecondary` | `Color` | Secondary text color |
| `textTertiary` | `Color` | Tertiary/hint text color |
| `onPrimary` | `Color` | Text on primary color |
| `divider` | `Color` | Divider/border color |
| `shimmerBase` | `Color` | Shimmer loading base |
| `shimmerHighlight` | `Color` | Shimmer loading highlight |
| `cardGradient` | `Gradient` | Card background gradient |
| `backgroundGradient` | `Gradient` | Scaffold background gradient |
| `activeGlowGradient` | `Gradient` | Active state glow effect |

**Implementations**:
- `DefaultColors` - Original dark-red palette
- `GrapevineColors` - Teal/orange editorial palette

---

### BrandTypography (Abstract Interface)

Defines typography scheme for a brand.

| Property | Type | Description |
|----------|------|-------------|
| `displayFont` | `TextStyle` | Display font family base |
| `bodyFont` | `TextStyle` | Body font family base |
| `monoFont` | `TextStyle` | Monospace font family base |
| `textTheme` | `TextTheme` | Complete Material text theme |
| `barName` | `TextStyle` | Bar name in list/detail |
| `price` | `TextStyle` | Price display |
| `data` | `TextStyle` | Data/metadata |
| `chip` | `TextStyle` | Chip/tag text |
| `badge` | `TextStyle` | Badge text |

**Implementations**:
- `DefaultTypography` - Playfair Display + Plus Jakarta Sans
- `GrapevineTypography` - Lora + Source Sans 3

---

## Relationships

```
┌─────────────────┐
│    AppBrand     │ (enum)
│  - defaultBrand │
│  - grapevine    │
└────────┬────────┘
         │ 1:1
         ▼
┌─────────────────────┐
│    BrandConfig      │
│  - brand            │
│  - appName          │
│  - logoAsset        │
│  - colors ──────────┼──► BrandColors (interface)
│  - typography ──────┼──► BrandTypography (interface)
└─────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
     ┌────────────────┐              ┌─────────────────┐
     │ DefaultColors  │              │ GrapevineColors │
     └────────────────┘              └─────────────────┘
     
     ┌──────────────────┐            ┌────────────────────┐
     │DefaultTypography │            │GrapevineTypography │
     └──────────────────┘            └────────────────────┘
```

---

## State Transitions

Not applicable - all entities are immutable configuration objects with no state transitions.

---

## Validation Rules

| Entity | Rule |
|--------|------|
| `AppBrand` | Must be valid enum value; unknown values default to `defaultBrand` |
| `BrandConfig.logoAsset` | If provided, must be valid asset path; null triggers text fallback |
| `BrandColors` | All color values must be non-null; enforced by required constructor params |
| `BrandTypography` | All text styles must be non-null; enforced by required constructor params |

---

## Color Palettes

### Default Theme (Dark Red)

```dart
background:       0xFF0D0D0D
backgroundEnd:    0xFF1A1A1A
surface:          0xFF1E1E1E
primary:          0xFFC62828  // Red
primaryLight:     0xFFE53935
secondary:        0xFFFF5252
```

### Grapevine Theme (Teal/Orange)

```dart
background:       0xFF1A1A1A
backgroundEnd:    0xFF2D2D2D
surface:          0xFF252525
primary:          0xFF0D9488  // Teal
primaryLight:     0xFF14B8A6
secondary:        0xFFE64A19  // Orange
```
