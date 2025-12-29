# Research: Internationalization & Image Caching

**Feature**: 003-i18n-image-caching  
**Date**: 2025-12-29

## Research Topics

### 1. Flutter Internationalization (l10n) Approach

**Decision**: Use Flutter's built-in `flutter_localizations` with ARB (Application Resource Bundle) files

**Rationale**:
- Official Flutter solution, deeply integrated with the framework
- Built-in support for `MaterialLocalizations` and `CupertinoLocalizations`
- ARB format is JSON-based, easy to translate and maintain
- Code generation produces type-safe accessors (`AppLocalizations.of(context).stringKey`)
- Automatic locale resolution based on device settings
- Lazy loading of locale data for efficient memory use

**Alternatives Considered**:

| Package | Pros | Cons | Decision |
|---------|------|------|----------|
| `easy_localization` | Simple API, JSON/YAML support, hot reload | Extra dependency, less integrated with Flutter | Rejected - adds dependency when built-in works |
| `get` (GetX) | Includes localization + state management | Would replace flutter_bloc, too invasive | Rejected - not worth changing architecture |
| `intl` standalone | Fine-grained control | More boilerplate, less automated | Rejected - ARB gen is simpler |
| Flutter built-in l10n | Official, type-safe, well-documented | Requires pubspec config | **Selected** |

**Implementation Details**:
- Add `flutter_localizations` to dependencies (from Flutter SDK)
- Add `intl` package for message formatting with placeholders
- Configure `generate: true` in `pubspec.yaml` for ARB code generation
- Create ARB files in `lib/l10n/` directory:
  - `app_en.arb` (English - source)
  - `app_is.arb` (Icelandic)
  - `app_pl.arb` (Polish)
- Generated code outputs to `lib/gen_l10n/`

### 2. ARB File Structure

**Decision**: Use flat key structure with descriptive names and metadata

**Rationale**:
- ARB supports `@key` metadata for translator context
- Flat structure is simpler to parse and less error-prone
- Consistent naming convention (`category_specificItem`) for organization

**Key Naming Convention**:
```
appTitle                    # App-level
navTryAgain, navRetry       # Navigation/actions
filterAll, filterHappyHour  # Filter chips
sortDefault, sortBeerPrice  # Sort options
labelHappyHour, labelBeer   # UI labels
msgOops, msgNoResults       # Messages
unitMeters, unitKilometers  # Units
```

### 3. Image Caching Library

**Decision**: Use `cached_network_image` with `flutter_cache_manager`

**Rationale**:
- Most popular Flutter image caching solution (9000+ pub.dev likes)
- Uses `flutter_cache_manager` internally with configurable cache settings
- Supports placeholder and error widgets out of the box
- Memory and disk caching
- Cache duration is configurable per cache manager instance
- Works well with `flutter_map` for map tile caching

**Alternatives Considered**:

| Package | Pros | Cons | Decision |
|---------|------|------|----------|
| `cached_network_image` | Popular, battle-tested, configurable | None significant | **Selected** |
| `extended_image` | More features (zoom, gestures) | Heavier, overkill for this use case | Rejected |
| `octo_image` | Lightweight | Less features, smaller community | Rejected |
| DIY with `http` + `path_provider` | Full control | Reinventing the wheel | Rejected |

**Implementation Details**:
- Configure `CacheManager` with `stalePeriod: Duration(days: 10)`
- Use `CachedNetworkImage` widget as drop-in replacement for `Image.network`
- Configure max cache entries and size limits for device storage management

### 4. Cache Configuration

**Decision**: Custom `CacheManager` with 10-day stale period

**Configuration**:
```dart
class AppCacheManager {
  static const key = 'appImageCache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 10),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
```

**Rationale**:
- `stalePeriod: 10 days` matches requirement FR-007
- `maxNrOfCacheObjects: 200` limits storage (~50MB typical for images)
- Uses default LRU eviction when limit reached
- Database-backed metadata for reliable expiration tracking

### 5. Locale Detection Strategy

**Decision**: Use `WidgetsBinding.instance.platformDispatcher.locale` via Flutter's built-in resolution

**Rationale**:
- Automatic locale resolution matches device settings
- Falls back to English when locale not in `supportedLocales`
- No additional platform channel code needed
- Works consistently across iOS, Android, and web

**Resolution Order**:
1. Exact match (e.g., `is` → Icelandic)
2. Language match (e.g., `is_IS` → `is`)
3. Fallback to English (`en`)

### 6. String Interpolation for Dynamic Values

**Decision**: Use ICU message format in ARB files

**Rationale**:
- Standard format supported by translation tools
- Handles pluralization (`{count, plural, =0{no items} =1{1 item} other{{count} items}}`)
- Parameter substitution (`{price} kr`)
- Well-documented with clear Flutter examples

**Examples**:
```json
{
  "distanceMeters": "{distance}m",
  "@distanceMeters": {
    "placeholders": {
      "distance": {"type": "int"}
    }
  },
  "distanceKilometers": "{distance}km",
  "@distanceKilometers": {
    "placeholders": {
      "distance": {"type": "String"}
    }
  }
}
```

## Dependencies to Add

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  cached_network_image: ^3.4.1
  flutter_cache_manager: ^3.4.1

flutter:
  generate: true
```

## Files to Create

| Path | Purpose |
|------|---------|
| `lib/l10n/app_en.arb` | English translations (source) |
| `lib/l10n/app_is.arb` | Icelandic translations |
| `lib/l10n/app_pl.arb` | Polish translations |
| `l10n.yaml` | Localization configuration |
| `lib/infrastructure/core/services/image_cache_service.dart` | Cache manager configuration |

## Key Findings Summary

1. **Flutter l10n is mature** - Built-in solution requires minimal dependencies
2. **ARB format is industry standard** - Compatible with translation tools and services
3. **cached_network_image is battle-tested** - 10-day cache trivial to configure
4. **No architectural changes needed** - Features integrate cleanly into existing structure
5. **Type-safe string access** - Generated code prevents runtime translation key errors

