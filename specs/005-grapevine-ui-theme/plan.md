# Implementation Plan: Grapevine UI Theme

**Branch**: `005-grapevine-ui-theme` | **Date**: 2025-01-17 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/005-grapevine-ui-theme/spec.md`

## Summary

Implement a Grapevine-branded UI theme ("Appy Hour") alongside the existing "Happy Hour" dark-red theme. The solution uses a compile-time brand constant in `main.dart` to switch between themes. Architecture follows a hybrid approach: shared Cubits/repositories with theme-specific color palettes, typography, and selective widget variations. The Grapevine theme features teal (#0D9488) and orange (#E64A19) accents with an editorial magazine aesthetic inspired by grapevine.is.

## Technical Context

**Language/Version**: Dart 3.11+ / Flutter 3.x  
**Primary Dependencies**: flutter_bloc, google_fonts, flutter_svg (new), go_router  
**Storage**: N/A (presentation-only feature)  
**Testing**: flutter_test, bloc_test (existing widget tests must pass with both themes)  
**Target Platform**: iOS, Android, Web (existing targets)  
**Project Type**: Mobile app with multi-brand theming  
**Performance Goals**: App launch within 10% of baseline; 60fps animations  
**Constraints**: Single codebase, compile-time theme selection; no runtime switching  
**Scale/Scope**: 2 screens (bar list, bar detail), 2 themes, ~15 theme-aware widgets

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| CSV is Source of Truth | ✅ Pass | No data changes; presentation-only |
| Stable Data Contract | ✅ Pass | No JSON schema changes |
| Clean Architecture | ✅ Pass | Only presentation layer modified; domain/infrastructure unchanged |
| Cubits for State Management | ✅ Pass | No new Cubits; existing Cubits unchanged |
| Deterministic Builds | ✅ Pass | Compile-time constant ensures deterministic theme |

**Gate Result**: ✅ PASS - No violations

## Project Structure

### Documentation (this feature)

```text
specs/005-grapevine-ui-theme/
├── plan.md              # This file
├── research.md          # Phase 0: Font selection, SVG handling, theme patterns
├── data-model.md        # Phase 1: Brand/Theme data structures
├── quickstart.md        # Phase 1: Developer setup guide
├── contracts/           # Phase 1: Theme contract definitions
└── tasks.md             # Phase 2: Implementation tasks
```

### Source Code (repository root)

```text
app/
├── assets/
│   └── images/
│       └── grapevine_logo.svg      # ✅ Already downloaded
├── lib/
│   ├── main.dart                   # Add AppBrand constant
│   ├── presentation/
│   │   ├── core/
│   │   │   ├── brand/              # NEW: Brand abstraction
│   │   │   │   ├── brand.dart      # Export barrel
│   │   │   │   ├── app_brand.dart  # Brand enum + config
│   │   │   │   └── brand_provider.dart  # InheritedWidget for brand access
│   │   │   └── theme/
│   │   │       ├── theme.dart              # Updated export barrel
│   │   │       ├── app_theme.dart          # Refactored to use BrandConfig
│   │   │       ├── brand_colors.dart       # NEW: Abstract color interface
│   │   │       ├── brand_typography.dart   # NEW: Abstract typography interface
│   │   │       ├── default_colors.dart     # RENAMED from app_colors.dart
│   │   │       ├── default_typography.dart # RENAMED from app_typography.dart
│   │   │       ├── grapevine_colors.dart   # NEW: Teal/orange palette
│   │   │       └── grapevine_typography.dart # NEW: Lora + Source Sans 3
│   │   └── bars/
│   │       ├── bar_list/
│   │       │   ├── bar_list.dart           # Update header for logo
│   │       │   └── bar_list_item.dart      # Theme-aware styling
│   │       └── bar_detail/
│   │           └── bar_detail.dart         # Theme-aware styling
│   └── ...
└── pubspec.yaml                    # Add flutter_svg, assets declaration
```

**Structure Decision**: Follows existing Clean Architecture. New `brand/` module abstracts theme selection. Existing `theme/` files refactored to support multiple color/typography sets.

## Complexity Tracking

> No Constitution violations requiring justification.

| Addition | Justification |
|----------|---------------|
| `brand/` module | Minimal abstraction for compile-time brand selection; 3 small files |
| flutter_svg dependency | Required for SVG logo rendering; widely-used, well-maintained |
| Duplicate color/typography files | Intentional separation for distinct visual identities per spec |

---

## Phase 0: Research

See [research.md](./research.md) for detailed findings.

### Research Tasks

1. **Flutter multi-theme patterns** - Best practices for compile-time theme switching
2. **SVG rendering in Flutter** - flutter_svg vs other options for logo display
3. **Editorial font selection** - Fonts matching Grapevine's aesthetic
4. **InheritedWidget vs Provider** - Best approach for brand access in widget tree

---

## Phase 1: Design

See [data-model.md](./data-model.md) for entity definitions.  
See [contracts/](./contracts/) for theme contracts.  
See [quickstart.md](./quickstart.md) for developer setup.

### Design Decisions

1. **Brand Abstraction**: `AppBrand` enum with `BrandConfig` class containing theme, colors, typography, logo path, app name
2. **Compile-time Constant**: `const AppBrand kActiveBrand = AppBrand.grapevine;` in main.dart
3. **Theme Access**: `BrandProvider` InheritedWidget at app root; widgets access via `BrandProvider.of(context)`
4. **Color Strategy**: Parallel color classes (`DefaultColors`, `GrapevineColors`) implementing common interface
5. **Typography Strategy**: Parallel typography classes with brand-specific Google Fonts
6. **Logo Widget**: `BrandLogo` widget that renders appropriate logo based on active brand
