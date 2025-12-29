# Implementation Plan: Internationalization & Image Caching

**Branch**: `003-i18n-image-caching` | **Date**: 2025-12-29 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/003-i18n-image-caching/spec.md`

## Summary

Add internationalization (l10n) support with English (default), Icelandic, and Polish translations, replacing all hardcoded UI strings with localized references. Additionally, implement image caching with a 10-day lifetime for network images.

**Technical Approach**: Use Flutter's built-in `flutter_localizations` with ARB files for type-safe internationalization, and `cached_network_image` with `flutter_cache_manager` for configurable image caching.

## Technical Context

**Language/Version**: Dart 3.11+ / Flutter 3.x  
**Primary Dependencies**: flutter_localizations (SDK), intl, cached_network_image, flutter_cache_manager  
**Storage**: Local file system (image cache), SharedPreferences metadata  
**Testing**: flutter_test, bloc_test (existing), widget tests for locale verification  
**Target Platform**: iOS, Android, Web (Flutter multiplatform)  
**Project Type**: Mobile app  
**Performance Goals**: Cached images load in <100ms, locale resolution <50ms  
**Constraints**: 10-day cache lifetime (exact), offline support for cached images  
**Scale/Scope**: ~30 strings to localize, 3 languages, ~200 cached images max

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Notes |
|------|--------|-------|
| Architecture Compliance | ✅ PASS | Clean Architecture preserved - l10n is presentation layer, cache is infrastructure |
| State Management | ✅ PASS | No changes to Cubit pattern - l10n accessed via BuildContext |
| Data Flow | ✅ PASS | No changes to data flow - GitHub Pages JSON → Repository → Cubit → UI |
| Dependency Alignment | ✅ PASS | Using flutter_bloc compatible packages, no GetX or alternative state management |
| Breaking Changes | ✅ PASS | No changes to JSON data contract or API shape |

**Re-check after Phase 1**: ✅ PASS - Design does not introduce architectural violations

## Project Structure

### Documentation (this feature)

```text
specs/003-i18n-image-caching/
├── plan.md              # This file
├── research.md          # Phase 0 output - technology decisions
├── data-model.md        # Phase 1 output - ARB schema, cache config
├── quickstart.md        # Phase 1 output - implementation guide
├── contracts/           # Phase 1 output - configuration contracts
│   ├── l10n-config.md   # l10n.yaml specification
│   ├── arb-schema.md    # ARB file format specification
│   └── cache-config.md  # Image cache configuration
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
app/
├── l10n.yaml                          # NEW: Localization configuration
├── lib/
│   ├── l10n/                          # NEW: Translation files
│   │   ├── app_en.arb                 # English (source)
│   │   ├── app_is.arb                 # Icelandic
│   │   └── app_pl.arb                 # Polish
│   ├── gen_l10n/                      # GENERATED: Do not edit
│   │   ├── app_localizations.dart
│   │   ├── app_localizations_en.dart
│   │   ├── app_localizations_is.dart
│   │   └── app_localizations_pl.dart
│   ├── main.dart                      # MODIFIED: Add localization delegates
│   ├── infrastructure/
│   │   └── core/
│   │       └── services/
│   │           ├── location_service.dart    # Existing
│   │           └── image_cache_service.dart # NEW: Cache manager
│   └── presentation/
│       └── bars/
│           ├── bar_list/
│           │   ├── bar_list.dart            # MODIFIED: Use l10n strings
│           │   ├── bar_list_item.dart       # MODIFIED: Use l10n strings
│           │   ├── error_banner.dart        # MODIFIED: Use l10n strings
│           │   ├── filter_chip_bar.dart     # MODIFIED: Use l10n strings
│           │   └── sort_dropdown.dart       # MODIFIED: Use l10n strings
│           └── bar_detail/
│               ├── bar_detail.dart          # MODIFIED: Use l10n strings
│               └── bar_map.dart             # MODIFIED: Use cached images
└── test/
    └── widget/
        └── localization_test.dart           # NEW: Locale verification tests
```

**Structure Decision**: Mobile app structure maintained. New files added to infrastructure/core/services for caching and lib/l10n for translations. Presentation layer files modified to use generated localization accessors.

## Complexity Tracking

> No violations detected. Feature integrates cleanly with existing architecture.

| Aspect | Assessment |
|--------|------------|
| New Dependencies | 4 packages - all well-established Flutter ecosystem packages |
| Architecture Changes | None - l10n and caching are orthogonal to existing patterns |
| State Management | No changes - l10n uses BuildContext, not Cubit state |
| Breaking Changes | None - purely additive feature |

## Implementation Phases

### Phase 1: Localization Infrastructure
1. Add dependencies to pubspec.yaml
2. Create l10n.yaml configuration
3. Create English ARB file with all strings
4. Configure MaterialApp with localization delegates
5. Generate l10n code

### Phase 2: Translations
1. Create Icelandic ARB file
2. Create Polish ARB file
3. Regenerate l10n code

### Phase 3: String Replacement
1. Replace hardcoded strings in bar_list.dart
2. Replace hardcoded strings in bar_list_item.dart
3. Replace hardcoded strings in bar_detail.dart
4. Replace hardcoded strings in filter_chip_bar.dart
5. Replace hardcoded strings in sort_dropdown.dart
6. Replace hardcoded strings in error_banner.dart

### Phase 4: Image Caching
1. Create ImageCacheService with 10-day stalePeriod
2. Update bar_map.dart to use CachedNetworkImage
3. Update any other network image usage

### Phase 5: Testing & Verification
1. Add widget tests for locale switching
2. Verify all strings render in each language
3. Test offline image caching behavior
4. Verify no hardcoded strings remain

## Artifacts Generated

| File | Type | Description |
|------|------|-------------|
| [research.md](./research.md) | Phase 0 | Technology decisions and alternatives |
| [data-model.md](./data-model.md) | Phase 1 | Complete string catalog, ARB schema |
| [quickstart.md](./quickstart.md) | Phase 1 | Step-by-step implementation guide |
| [contracts/l10n-config.md](./contracts/l10n-config.md) | Phase 1 | l10n.yaml specification |
| [contracts/arb-schema.md](./contracts/arb-schema.md) | Phase 1 | ARB file format contract |
| [contracts/cache-config.md](./contracts/cache-config.md) | Phase 1 | Cache configuration contract |

## Next Steps

Run `/speckit.tasks` to break this plan into executable tasks with acceptance criteria.
