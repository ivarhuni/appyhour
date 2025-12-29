# Quickstart: Internationalization & Image Caching

**Feature**: 003-i18n-image-caching  
**Estimated Time**: 4-6 hours

## Prerequisites

- Flutter SDK 3.11+
- Existing Happy Hour app codebase
- Access to Icelandic and Polish translations (or placeholder text)

## Setup Steps

### 1. Add Dependencies

Update `app/pubspec.yaml`:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  cached_network_image: ^3.4.1
  flutter_cache_manager: ^3.4.1

flutter:
  generate: true  # Enable l10n code generation
```

Run:
```bash
cd app
flutter pub get
```

### 2. Create l10n Configuration

Create `app/l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
synthetic-package: false
output-dir: lib/gen_l10n
nullable-getter: false
```

### 3. Create ARB Directory

```bash
mkdir -p lib/l10n
```

### 4. Create English ARB (Template)

Create `app/lib/l10n/app_en.arb` with all strings from data-model.md.

### 5. Create Translation Files

Create `app/lib/l10n/app_is.arb` (Icelandic) and `app/lib/l10n/app_pl.arb` (Polish).

### 6. Generate Localization Code

```bash
flutter gen-l10n
```

Verify `lib/gen_l10n/` directory is created with:
- `app_localizations.dart`
- `app_localizations_en.dart`
- `app_localizations_is.dart`
- `app_localizations_pl.dart`

### 7. Configure MaterialApp

Update `lib/main.dart`:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

MaterialApp.router(
  // ... existing config ...
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('is'),
    Locale('pl'),
  ],
)
```

### 8. Create Image Cache Service

Create `app/lib/infrastructure/core/services/image_cache_service.dart`:

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  static const String cacheKey = 'happyHourImageCache';
  
  static final CacheManager cacheManager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 10),
      maxNrOfCacheObjects: 200,
    ),
  );
}
```

### 9. Replace Hardcoded Strings

For each widget file, replace:

```dart
// Before
Text('Happy Hour')

// After
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context).appTitle)
```

### 10. Replace Image.network

For network images, replace:

```dart
// Before
Image.network(imageUrl)

// After
import 'package:cached_network_image/cached_network_image.dart';
import 'package:happyhour_app/infrastructure/core/services/image_cache_service.dart';

CachedNetworkImage(
  cacheManager: ImageCacheService.cacheManager,
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

## Verification Checklist

- [ ] `flutter gen-l10n` completes without errors
- [ ] App builds successfully
- [ ] English strings display correctly
- [ ] Device language set to Icelandic → app shows Icelandic
- [ ] Device language set to Polish → app shows Polish
- [ ] Device language set to French → app falls back to English
- [ ] Images load and are cached
- [ ] Previously loaded images work offline
- [ ] No hardcoded strings remain in presentation layer

## Common Issues

### "No Material Localizations found"
Ensure `GlobalMaterialLocalizations.delegate` is in `localizationsDelegates`.

### ARB generation fails
- Check JSON syntax (no trailing commas)
- Ensure `@@locale` matches filename
- All placeholders must have matching `@key` metadata

### Images not caching
- Verify `cacheManager` parameter is passed to `CachedNetworkImage`
- Check device storage permissions (Android)

## Files Changed Summary

| File | Change |
|------|--------|
| `pubspec.yaml` | Add dependencies |
| `l10n.yaml` | New file - config |
| `lib/l10n/app_*.arb` | New files - translations |
| `lib/gen_l10n/*` | Generated - do not edit |
| `lib/main.dart` | Add localization delegates |
| `lib/infrastructure/core/services/image_cache_service.dart` | New file |
| `lib/presentation/**/*.dart` | Replace hardcoded strings |

