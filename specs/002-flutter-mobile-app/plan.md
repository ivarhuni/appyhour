# Implementation Plan: Flutter Mobile App for Happy Hour Discovery

**Branch**: `002-flutter-mobile-app` | **Date**: 2024-12-28 | **Spec**: [spec.md](spec.md)

## Summary

Build a Flutter mobile application that fetches bar happy hour data from a published JSON endpoint and displays it to users. The app features two screens (Bars List with filtering/sorting, Bar Detail with map), uses Clean Architecture with Cubit-based state management, and targets both iOS and Android platforms.

## Technical Context

**Language/Version**: Dart ≥3.8.0 / Flutter ≥3.38.0  
**Primary Dependencies**: flutter_bloc ^9.1.1, http ^1.3.0, geolocator ^14.0.0, flutter_map ^8.1.0, go_router ^15.1.0  
**Storage**: N/A (no local persistence; fetch on launch)  
**Testing**: flutter_test, bloc_test ^10.0.0, mocktail ^1.0.5  
**Target Platform**: iOS 12+ and Android API 21+  
**Project Type**: Mobile application  
**Performance Goals**: List loads <3s, navigation <1s, sorting <500ms  
**Constraints**: Network required; no offline caching  
**Scale/Scope**: ~10-50 bars, 2 screens, 2 cubits

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Notes |
|------|--------|-------|
| Architecture matches constitution | ✅ Pass | Clean Architecture with 4 layers as specified |
| State management per constitution | ✅ Pass | Cubits (flutter_bloc) as mandated |
| Directory structure per constitution | ✅ Pass | presentation/application/domain/infrastructure |
| Data flow pattern | ✅ Pass | GitHub Pages JSON → HTTP Client → Repository → Cubit → UI |
| No secrets in repo | ✅ Pass | No API keys needed (OpenStreetMap tiles, public JSON) |
| Screens match constitution | ✅ Pass | Bars List + Bar Detail as specified |

**Gate Result**: ✅ All gates passed

## Project Structure

### Documentation (this feature)

```text
specs/002-flutter-mobile-app/
├── plan.md              # This file
├── research.md          # Technology decisions
├── data-model.md        # Entity definitions
├── quickstart.md        # Developer setup guide
├── contracts/
│   └── bars-api.md      # API contract documentation
├── checklists/
│   └── requirements.md  # Specification quality checklist
└── spec.md              # Feature specification
```

### Source Code (repository root)

```text
app/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── router.dart                         # go_router configuration
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── bars_list_screen.dart       # P1: Main list view
│   │   │   └── bar_detail_screen.dart      # P1: Detail view with map
│   │   ├── widgets/
│   │   │   ├── bar_list_item.dart          # List item component
│   │   │   ├── filter_chip_bar.dart        # ONGOING/ALL filter
│   │   │   ├── sort_dropdown.dart          # Sort options
│   │   │   ├── error_banner.dart           # Error display
│   │   │   └── bar_map.dart                # Map display component
│   │   └── cubits/
│   │       ├── bars_list/
│   │       │   ├── bars_list_cubit.dart
│   │       │   └── bars_list_state.dart
│   │       └── bar_detail/
│   │           ├── bar_detail_cubit.dart
│   │           └── bar_detail_state.dart
│   ├── application/
│   │   └── use_cases/
│   │       ├── get_all_bars.dart
│   │       └── filter_and_sort_bars.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   └── bar.dart
│   │   ├── repositories/
│   │   │   └── bar_repository.dart         # Abstract interface
│   │   └── value_objects/
│   │       ├── happy_hour_time.dart
│   │       └── happy_hour_days.dart
│   └── infrastructure/
│       ├── api/
│       │   └── bars_api_client.dart        # HTTP client
│       ├── repositories/
│       │   └── bar_repository_impl.dart    # Concrete implementation
│       └── dto/
│           ├── bar_dto.dart
│           └── bar_dto.g.dart              # Generated
├── test/
│   ├── unit/
│   │   ├── cubits/
│   │   │   ├── bars_list_cubit_test.dart
│   │   │   └── bar_detail_cubit_test.dart
│   │   ├── domain/
│   │   │   ├── happy_hour_time_test.dart
│   │   │   └── happy_hour_days_test.dart
│   │   └── infrastructure/
│   │       └── bar_repository_impl_test.dart
│   └── widget/
│       ├── bars_list_screen_test.dart
│       └── bar_detail_screen_test.dart
├── android/
├── ios/
└── pubspec.yaml
```

**Structure Decision**: Mobile application with Clean Architecture (4 layers). Single `app/` directory at repository root containing the Flutter project.

## Implementation Phases

### Phase 1: Foundation (P1 Stories)

**Goal**: Core browse and detail functionality

| Component | Priority | Description |
|-----------|----------|-------------|
| Domain entities | P1 | Bar, HappyHourTime, HappyHourDays |
| DTO + JSON parsing | P1 | BarDto with json_serializable |
| Repository interface | P1 | BarRepository abstract class |
| Repository implementation | P1 | HTTP fetch, DTO→Domain mapping |
| BarsListCubit | P1 | Load, error, loaded states |
| BarsListScreen | P1 | Scrollable list, pull-to-refresh |
| BarListItem widget | P1 | Name, address, beer price |
| BarDetailCubit | P1 | Load single bar |
| BarDetailScreen | P1 | All bar info + map |
| Router setup | P1 | List ↔ Detail navigation |

**Deliverable**: User can launch app, see bar list, tap to view details with map

### Phase 2: Filtering (P2 Stories)

**Goal**: Time-based filtering and price sorting

| Component | Priority | Description |
|-----------|----------|-------------|
| HappyHourTime.isActiveAt() | P2 | Time window logic incl. overnight |
| HappyHourDays.isActiveOn() | P2 | Day-of-week matching |
| FilterChipBar widget | P2 | ONGOING / ALL toggle |
| BarsListCubit filtering | P2 | Filter state management |
| SortDropdown widget | P2 | Sort option selection |
| BarsListCubit price sort | P2 | Sort by beer price ascending |

**Deliverable**: User can filter to active happy hours and sort by price

### Phase 3: Location Features (P3 Stories)

**Goal**: Location-based sorting

| Component | Priority | Description |
|-----------|----------|-------------|
| LocationService | P3 | Geolocator integration |
| Permission handling | P3 | Request and handle location access |
| Distance calculation | P3 | Add distanceFromUser to Bar |
| BarsListCubit distance sort | P3 | Sort by distance nearest first |
| Distance display | P3 | Show distance in list items |

**Deliverable**: User can sort bars by distance from current location

### Phase 4: Polish (P3 Stories)

**Goal**: Rating sort and edge cases

| Component | Priority | Description |
|-----------|----------|-------------|
| Rating sort (conditional) | P3 | Only if rating data available |
| Empty state improvements | P3 | Refined empty/error UI |
| Edge case handling | P3 | Malformed data, midnight spans |

**Deliverable**: Production-ready app with all edge cases handled

## Key Technical Decisions

| Decision | Rationale | Reference |
|----------|-----------|-----------|
| Cubits over Blocs | Simpler for CRUD operations | research.md |
| flutter_map over Google Maps | No API key required | research.md |
| No caching layer | User clarification; fresh data preferred | spec.md clarifications |
| Server-controlled order | Default list order from JSON | spec.md clarifications |
| Sealed classes for states | Exhaustive switch in Dart 3 | research.md |

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  http: ^1.3.0
  geolocator: ^14.0.0
  flutter_map: ^8.1.0
  latlong2: ^0.9.1
  go_router: ^15.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
  build_runner: ^2.4.15
  json_serializable: ^6.9.0
```

## Testing Strategy

| Layer | Approach | Coverage Target |
|-------|----------|-----------------|
| Value Objects | Unit tests for parsing logic | 100% |
| Cubits | bloc_test with state assertions | 100% |
| Repository | Mocked HTTP responses | 90% |
| Screens | Widget tests with mocked cubits | Key flows |

**Critical Test Cases**:
- Happy hour time parsing (normal, overnight, edge)
- Happy hour day matching (every day, weekdays, weekends)
- Cubit state transitions (initial → loading → loaded/error)
- Network error handling
- Empty list handling

## Success Metrics

| Metric | Target | Validation |
|--------|--------|------------|
| SC-001 | List loads <3 seconds | Manual timing on 3G |
| SC-002 | Navigation <1 second | Automated widget test |
| SC-003 | 100% filter accuracy | Unit tests for time logic |
| SC-004 | Sort <500ms | Profiler measurement |
| SC-006 | 100% error handling | Mock network failure tests |

## Complexity Tracking

No constitution violations requiring justification. Architecture follows mandated patterns.

## Related Documents

- [Specification](spec.md) — Feature requirements and user stories
- [Research](research.md) — Technology decisions and alternatives
- [Data Model](data-model.md) — Entity definitions and state diagrams
- [Quickstart](quickstart.md) — Developer setup instructions
- [API Contract](contracts/bars-api.md) — Endpoint documentation

