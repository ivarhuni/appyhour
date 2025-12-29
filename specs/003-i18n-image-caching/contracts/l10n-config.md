# Localization Configuration Contract

**File**: `app/l10n.yaml`

## Purpose

Configures Flutter's code generation for internationalization. This file tells the Flutter tooling where to find ARB files and where to output generated code.

## Configuration

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
synthetic-package: false
output-dir: lib/gen_l10n
nullable-getter: false
```

## Field Definitions

| Field | Value | Description |
|-------|-------|-------------|
| `arb-dir` | `lib/l10n` | Directory containing ARB translation files |
| `template-arb-file` | `app_en.arb` | Source language file (English) |
| `output-localization-file` | `app_localizations.dart` | Generated output filename |
| `output-class` | `AppLocalizations` | Generated class name |
| `synthetic-package` | `false` | Generate to specified directory (not synthetic) |
| `output-dir` | `lib/gen_l10n` | Output directory for generated files |
| `nullable-getter` | `false` | Getters are non-nullable (requires locale) |

## Generated Files

After running `flutter gen-l10n`, the following files are created:

```
lib/gen_l10n/
├── app_localizations.dart       # Main class with string accessors
├── app_localizations_en.dart    # English implementation
├── app_localizations_is.dart    # Icelandic implementation
└── app_localizations_pl.dart    # Polish implementation
```

## Usage in Code

```dart
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

// In widgets:
Text(AppLocalizations.of(context).appTitle)

// With placeholders:
Text(AppLocalizations.of(context).distanceMeters(500))
```

## Constraints

- ARB files MUST exist for all supported locales before generation
- Template file (English) MUST contain all string keys
- Changes to ARB files require regeneration (`flutter gen-l10n`)

