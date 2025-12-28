# Data Model: Flutter Mobile App for Happy Hour Discovery

**Branch**: `002-flutter-mobile-app` | **Date**: 2024-12-28

## Domain Entities

### Bar (Core Entity)

The primary domain entity representing a drinking establishment with happy hour offerings.

```dart
/// Domain entity for a bar/restaurant with happy hour information.
/// Immutable value object with computed properties.
class Bar {
  final int id;
  final String name;
  final String email;
  final String street;
  final double latitude;
  final double longitude;
  final String happyHourDays;
  final HappyHourTime happyHourTime;
  final int cheapestBeerPrice;    // ISK
  final int cheapestWinePrice;    // ISK
  final bool twoForOne;
  final String notes;
  final String? description;
  
  // Computed at runtime (not persisted)
  double? distanceFromUser;       // meters, null if location unavailable
}
```

**Field Mappings from JSON**:

| JSON Field | Domain Field | Transformation |
|------------|--------------|----------------|
| `id` | `id` | Direct |
| `name` | `name` | Direct |
| `email` | `email` | Direct |
| `street` | `street` | Direct |
| `latitude` | `latitude` | Direct |
| `longitude` | `longitude` | Direct |
| `happy_hour_days` | `happyHourDays` | Direct |
| `happy_hour_times` | `happyHourTime` | Parse to `HappyHourTime` |
| `cheapest_beer_price` | `cheapestBeerPrice` | Direct |
| `cheapest_wine_price` | `cheapestWinePrice` | Direct |
| `two_for_one` | `twoForOne` | Direct |
| `notes` | `notes` | Direct |
| `description` | `description` | Direct (nullable) |

### HappyHourTime (Value Object)

Encapsulates happy hour time parsing and active-status logic.

```dart
/// Value object representing a happy hour time window.
/// Handles overnight spans (e.g., 22:00 - 02:00).
class HappyHourTime {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  
  /// Parse from "HH:MM - HH:MM" format
  factory HappyHourTime.parse(String timeString);
  
  /// Check if given time falls within this window
  /// Handles overnight spans correctly
  bool isActiveAt(DateTime time);
  
  /// Format for display: "15:00 - 19:00"
  String get displayString;
}
```

**Overnight Handling Logic**:
```
If end time < start time (e.g., 22:00 - 02:00):
  - Happy hour spans midnight
  - Active if: currentTime >= startTime OR currentTime <= endTime
  
If end time >= start time (e.g., 15:00 - 19:00):
  - Normal daytime window
  - Active if: currentTime >= startTime AND currentTime <= endTime
```

### HappyHourDays (Value Object)

Encapsulates day-of-week parsing and matching.

```dart
/// Value object for happy hour day availability.
/// Parses strings like "Every day", "Mon-Fri", "Weekends".
class HappyHourDays {
  final Set<int> activeDays;  // 1=Monday ... 7=Sunday (ISO weekday)
  
  /// Parse from display string
  factory HappyHourDays.parse(String daysString);
  
  /// Check if a given weekday is active
  bool isActiveOn(int weekday);
  
  /// Original display string
  String get displayString;
}
```

**Known Day Patterns**:

| Pattern | Days (ISO) |
|---------|------------|
| "Every day" | 1,2,3,4,5,6,7 |
| "Mon-Fri" | 1,2,3,4,5 |
| "Weekdays" | 1,2,3,4,5 |
| "Weekends" | 6,7 |
| "Sat-Sun" | 6,7 |

### FilterState (Presentation State)

```dart
/// Enum representing the current filter mode.
enum FilterMode {
  all,      // Show all bars
  ongoing,  // Show only bars with active happy hour
}
```

### SortPreference (Presentation State)

```dart
/// Enum representing sort options.
enum SortPreference {
  serverOrder,  // Default: JSON order (server-controlled)
  beerPrice,    // Cheapest beer price ascending
  distance,     // Distance from user (nearest first)
  rating,       // Rating descending (if available)
}
```

### BarsListState (Cubit State)

```dart
/// Sealed class for bars list screen state.
sealed class BarsListState {}

class BarsListInitial extends BarsListState {}

class BarsListLoading extends BarsListState {}

class BarsListLoaded extends BarsListState {
  final List<Bar> bars;
  final List<Bar> filteredBars;  // After filter + sort applied
  final FilterMode filterMode;
  final SortPreference sortPreference;
  final String? errorBanner;     // Non-blocking error message
}

class BarsListError extends BarsListState {
  final String message;
}
```

### BarDetailState (Cubit State)

```dart
/// Sealed class for bar detail screen state.
sealed class BarDetailState {}

class BarDetailInitial extends BarDetailState {}

class BarDetailLoaded extends BarDetailState {
  final Bar bar;
  final bool isHappyHourActive;
}
```

## Entity Relationships

```
┌─────────────────┐
│     Bar         │
├─────────────────┤
│ id (PK)         │
│ name            │
│ email           │
│ street          │
│ latitude        │
│ longitude       │
│ happyHourDays   │──────┐
│ happyHourTime   │──┐   │
│ cheapestBeerPrice│ │   │
│ cheapestWinePrice│ │   │
│ twoForOne       │ │   │
│ notes           │ │   │
│ description?    │ │   │
│ distanceFromUser?│ │   │
└─────────────────┘ │   │
                    │   │
        ┌───────────┘   │
        │               │
        ▼               ▼
┌───────────────┐ ┌───────────────┐
│ HappyHourTime │ │ HappyHourDays │
├───────────────┤ ├───────────────┤
│ startHour     │ │ activeDays    │
│ startMinute   │ │ displayString │
│ endHour       │ └───────────────┘
│ endMinute     │
│ isActiveAt()  │
└───────────────┘
```

## Validation Rules

| Field | Rule | Error Handling |
|-------|------|----------------|
| `id` | Integer ≥ 1 | Required, fail parse if invalid |
| `name` | Non-empty string | Display "Unknown Bar" if empty |
| `latitude` | -90 to 90 | Required for map display |
| `longitude` | -180 to 180 | Required for map display |
| `happy_hour_times` | "HH:MM - HH:MM" pattern | Display raw string if parse fails |
| `cheapest_beer_price` | Integer ≥ 0 | Display "N/A" if missing |
| `cheapest_wine_price` | Integer ≥ 0 | Display "N/A" if missing |
| `two_for_one` | Boolean | Default to false if missing |

## State Transitions

### BarsListCubit

```
┌──────────────────┐
│  BarsListInitial │
└────────┬─────────┘
         │ loadBars()
         ▼
┌──────────────────┐
│  BarsListLoading │
└────────┬─────────┘
         │
    ┌────┴────┐
    │         │
success     failure
    │         │
    ▼         ▼
┌──────────────────┐  ┌──────────────────┐
│  BarsListLoaded  │  │  BarsListError   │
└────────┬─────────┘  └────────┬─────────┘
         │                     │
         │ refresh()           │ retry()
         │ setFilter()         │
         │ setSort()           │
         └─────────────────────┘
                 │
                 ▼
         (cycle back to Loading)
```

### BarDetailCubit

```
┌───────────────────┐
│  BarDetailInitial │
└─────────┬─────────┘
          │ loadBar(id)
          ▼
┌───────────────────┐
│  BarDetailLoaded  │
└───────────────────┘
```

## Data Flow

```
GitHub Pages                  Infrastructure              Domain              Presentation
     │                              │                        │                      │
     │  GET /data/bars.json         │                        │                      │
     │◄─────────────────────────────│                        │                      │
     │                              │                        │                      │
     │  JSON Response               │                        │                      │
     │─────────────────────────────►│                        │                      │
     │                              │                        │                      │
     │                    BarDto.fromJson()                  │                      │
     │                              │                        │                      │
     │                              │   toDomain()           │                      │
     │                              │───────────────────────►│                      │
     │                              │                        │                      │
     │                              │                  List<Bar>                    │
     │                              │                        │───────────────────────►│
     │                              │                        │                      │
     │                              │                        │            emit(BarsListLoaded)
     │                              │                        │                      │
```


