# ARB File Schema Contract

**Files**: `app/lib/l10n/app_*.arb`

## Purpose

Defines the structure and requirements for Application Resource Bundle (ARB) files used for internationalization.

## File Naming Convention

```
app_{locale}.arb
```

Where `{locale}` is:
- `en` - English (template/source)
- `is` - Icelandic
- `pl` - Polish

## Schema

### Required Fields

```json
{
  "@@locale": "{locale_code}"
}
```

### String Entry

```json
{
  "keyName": "Translated string value"
}
```

### String Entry with Metadata

```json
{
  "keyName": "Translated string value",
  "@keyName": {
    "description": "Context for translators",
    "placeholders": {
      "paramName": {
        "type": "String|int|double|num|DateTime",
        "example": "example value"
      }
    }
  }
}
```

## String Key Categories

All keys follow the pattern `{category}{SpecificName}`:

| Prefix | Category | Example |
|--------|----------|---------|
| `app` | App-level | `appTitle` |
| `action` | Buttons, links | `actionTryAgain` |
| `filter` | Filter options | `filterAll` |
| `sort` | Sort options | `sortDefault`, `sortLabelPrice` |
| `label` | UI labels | `labelBeer`, `labelHappyHour` |
| `msg` | Messages | `msgOops`, `msgNoBarsFound` |
| `location` | Location features | `locationEnable` |
| `distance` | Distance units | `distanceMeters` |

## Placeholder Syntax

### Simple Placeholder

```json
{
  "greeting": "Hello, {name}!",
  "@greeting": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
}
```

### Number Placeholder

```json
{
  "itemCount": "{count} items",
  "@itemCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

## Validation Rules

1. **Locale Match**: `@@locale` value MUST match filename suffix
2. **Complete Coverage**: All keys in `app_en.arb` MUST exist in all locale files
3. **Placeholder Consistency**: Placeholder names MUST match across all locale files
4. **Valid JSON**: Files MUST be valid JSON (no trailing commas)
5. **UTF-8 Encoding**: Files MUST use UTF-8 encoding

## Example: Complete Entry

```json
{
  "@@locale": "en",
  
  "distanceMeters": "{distance}m",
  "@distanceMeters": {
    "description": "Distance formatted in meters, shown on bar cards",
    "placeholders": {
      "distance": {
        "type": "int",
        "example": "500"
      }
    }
  }
}
```

## Translation Workflow

1. Add new strings to `app_en.arb` (source of truth)
2. Add corresponding entries to `app_is.arb` and `app_pl.arb`
3. Run `flutter gen-l10n` to regenerate code
4. Verify build succeeds and strings render correctly

