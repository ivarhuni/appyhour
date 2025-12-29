# Data Model: Internationalization & Image Caching

**Feature**: 003-i18n-image-caching  
**Date**: 2025-12-29

## Overview

This feature introduces two data structures:
1. **ARB Translation Files** - Externalized strings for each supported language
2. **Image Cache Configuration** - Settings for the caching system

No changes to existing domain entities are required.

---

## Entity: Translation Strings (ARB)

ARB (Application Resource Bundle) files use JSON format with metadata annotations.

### Structure

```json
{
  "@@locale": "en",
  "key": "Translated value",
  "@key": {
    "description": "Context for translators",
    "placeholders": { ... }
  }
}
```

### Complete String Catalog

| Key | English (en) | Description | Placeholders |
|-----|--------------|-------------|--------------|
| **App-Level** ||||
| `appTitle` | Happy Hour | App bar title | - |
| **Navigation & Actions** ||||
| `actionTryAgain` | Try Again | Retry button text | - |
| `actionRetry` | Retry | Short retry text | - |
| `actionShowAllBars` | Show all bars | Link to clear filter | - |
| **Filters** ||||
| `filterAll` | All | Show all bars filter | - |
| `filterHappyHourNow` | Happy Hour Now | Active happy hours filter | - |
| **Sort Options** ||||
| `sortDefault` | Default | Server order sort | - |
| `sortCheapestBeer` | Cheapest Beer | Price sort option | - |
| `sortNearest` | Nearest | Distance sort option | - |
| `sortTopRated` | Top Rated | Rating sort option | - |
| `sortLabelPrice` | Price | Short label for price sort | - |
| `sortLabelDistance` | Distance | Short label for distance sort | - |
| `sortLabelRating` | Rating | Short label for rating sort | - |
| **Status & Labels** ||||
| `labelHappyHour` | HAPPY HOUR | Badge/status indicator | - |
| `labelTwoForOne` | 2-for-1 | Deal badge short | - |
| `labelTwoForOneAvailable` | 2-for-1 deals available! | Deal banner text | - |
| `labelHappyHourPrices` | Happy Hour Prices | Section header | - |
| `labelBeer` | Beer | Drink type | - |
| `labelWine` | Wine | Drink type | - |
| `labelNotes` | Notes | Section header | - |
| `labelAbout` | About | Section header | - |
| `labelContact` | Contact | Section header | - |
| **Messages** ||||
| `msgOops` | Oops! | Error title | - |
| `msgNoHappyHoursNow` | No happy hours right now | Empty state when filtering | - |
| `msgNoBarsFound` | No bars found | Empty state general | - |
| `msgCheckBackLater` | Check back later or view all bars | Empty state suggestion | - |
| `msgPullToRefresh` | Pull down to refresh | Refresh hint | - |
| **Location** ||||
| `locationEnable` | Enable location | Tooltip for location button | - |
| `locationEnabled` | Location enabled | Tooltip when location active | - |
| **Units (with placeholders)** ||||
| `distanceMeters` | {distance}m | Distance in meters | `distance: int` |
| `distanceKilometers` | {distance}km | Distance in kilometers | `distance: String` |

### ARB File: English (`app_en.arb`)

```json
{
  "@@locale": "en",
  
  "appTitle": "Happy Hour",
  "@appTitle": { "description": "Main app title shown in app bar" },
  
  "actionTryAgain": "Try Again",
  "@actionTryAgain": { "description": "Button text for retry actions" },
  
  "actionRetry": "Retry",
  "@actionRetry": { "description": "Short retry button text" },
  
  "actionShowAllBars": "Show all bars",
  "@actionShowAllBars": { "description": "Link to clear filter and show all bars" },
  
  "filterAll": "All",
  "@filterAll": { "description": "Filter chip to show all bars" },
  
  "filterHappyHourNow": "Happy Hour Now",
  "@filterHappyHourNow": { "description": "Filter chip to show only active happy hours" },
  
  "sortDefault": "Default",
  "@sortDefault": { "description": "Default server order sorting" },
  
  "sortCheapestBeer": "Cheapest Beer",
  "@sortCheapestBeer": { "description": "Sort by cheapest beer price" },
  
  "sortNearest": "Nearest",
  "@sortNearest": { "description": "Sort by distance from user" },
  
  "sortTopRated": "Top Rated",
  "@sortTopRated": { "description": "Sort by rating" },
  
  "sortLabelPrice": "Price",
  "@sortLabelPrice": { "description": "Short label for price sort" },
  
  "sortLabelDistance": "Distance",
  "@sortLabelDistance": { "description": "Short label for distance sort" },
  
  "sortLabelRating": "Rating",
  "@sortLabelRating": { "description": "Short label for rating sort" },
  
  "labelHappyHour": "HAPPY HOUR",
  "@labelHappyHour": { "description": "Happy hour status badge" },
  
  "labelTwoForOne": "2-for-1",
  "@labelTwoForOne": { "description": "Two for one deal badge" },
  
  "labelTwoForOneAvailable": "2-for-1 deals available!",
  "@labelTwoForOneAvailable": { "description": "Banner text for 2-for-1 deals" },
  
  "labelHappyHourPrices": "Happy Hour Prices",
  "@labelHappyHourPrices": { "description": "Section header for prices" },
  
  "labelBeer": "Beer",
  "@labelBeer": { "description": "Beer drink type" },
  
  "labelWine": "Wine",
  "@labelWine": { "description": "Wine drink type" },
  
  "labelNotes": "Notes",
  "@labelNotes": { "description": "Notes section header" },
  
  "labelAbout": "About",
  "@labelAbout": { "description": "About section header" },
  
  "labelContact": "Contact",
  "@labelContact": { "description": "Contact section header" },
  
  "msgOops": "Oops!",
  "@msgOops": { "description": "Error state title" },
  
  "msgNoHappyHoursNow": "No happy hours right now",
  "@msgNoHappyHoursNow": { "description": "Empty state when filtering for active happy hours" },
  
  "msgNoBarsFound": "No bars found",
  "@msgNoBarsFound": { "description": "General empty state" },
  
  "msgCheckBackLater": "Check back later or view all bars",
  "@msgCheckBackLater": { "description": "Suggestion text in empty state" },
  
  "msgPullToRefresh": "Pull down to refresh",
  "@msgPullToRefresh": { "description": "Refresh hint text" },
  
  "locationEnable": "Enable location",
  "@locationEnable": { "description": "Tooltip for location permission button" },
  
  "locationEnabled": "Location enabled",
  "@locationEnabled": { "description": "Tooltip when location is active" },
  
  "distanceMeters": "{distance}m",
  "@distanceMeters": {
    "description": "Distance formatted in meters",
    "placeholders": {
      "distance": { "type": "int", "example": "500" }
    }
  },
  
  "distanceKilometers": "{distance}km",
  "@distanceKilometers": {
    "description": "Distance formatted in kilometers",
    "placeholders": {
      "distance": { "type": "String", "example": "1.5" }
    }
  }
}
```

---

## Entity: Image Cache Configuration

### Cache Manager Settings

| Property | Value | Description |
|----------|-------|-------------|
| `key` | `"happyHourImageCache"` | Unique cache identifier |
| `stalePeriod` | `Duration(days: 10)` | Maximum age before refresh (per FR-007) |
| `maxNrOfCacheObjects` | `200` | Maximum cached images |
| `fileService` | `HttpFileService()` | HTTP client for fetching |

### Cache Entry (managed by flutter_cache_manager)

| Field | Type | Description |
|-------|------|-------------|
| `url` | `String` | Original image URL |
| `file` | `File` | Local cached file |
| `validTill` | `DateTime` | Expiration timestamp |
| `eTag` | `String?` | HTTP ETag for validation |
| `touched` | `DateTime` | Last access time |

---

## Relationships

```
┌─────────────────────────────────────────────────────────────────┐
│                        MaterialApp                               │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ localizationsDelegates:                                   │  │
│  │   - AppLocalizations.delegate                             │  │
│  │   - GlobalMaterialLocalizations.delegate                  │  │
│  │   - GlobalWidgetsLocalizations.delegate                   │  │
│  │   - GlobalCupertinoLocalizations.delegate                 │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ supportedLocales: [en, is, pl]                            │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Presentation Layer                          │
│  ┌─────────────────────┐    ┌─────────────────────────────────┐ │
│  │ AppLocalizations    │    │ CachedNetworkImage              │ │
│  │ .of(context)        │    │ - cacheManager: AppCacheManager │ │
│  │ .appTitle           │    │ - imageUrl: String              │ │
│  │ .filterAll          │    │ - placeholder: Widget           │ │
│  │ .msgOops            │    │ - errorWidget: Widget           │ │
│  └─────────────────────┘    └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Validation Rules

### ARB Files
- `@@locale` must match file suffix (`app_en.arb` → `"@@locale": "en"`)
- All keys in `app_en.arb` must exist in all translation files
- Placeholder names must match between base and translations
- JSON must be valid (no trailing commas, proper escaping)

### Cache
- `stalePeriod` must be exactly 10 days (per requirement)
- `maxNrOfCacheObjects` should not exceed 500 (storage constraint)
- Cache key must be unique within the app

---

## Migration Notes

No database migrations required. This feature adds:
1. New ARB files (created fresh)
2. New generated l10n code (auto-generated)
3. New cache manager (runtime configuration)

Existing data structures remain unchanged.

