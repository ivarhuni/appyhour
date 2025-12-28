# Research: Flutter Mobile App for Happy Hour Discovery

**Branch**: `002-flutter-mobile-app` | **Date**: 2024-12-28

## Technology Decisions

### 1. State Management: flutter_bloc with Cubits

**Decision**: Use `flutter_bloc ^9.1.1` with Cubit pattern (not full Bloc)

**Rationale**:
- Cubits are simpler than Blocs for straightforward state transitions
- This app has simple user actions (fetch, filter, sort) without complex event streams
- Methods directly emit states, reducing boilerplate vs event-based Bloc
- Same testing patterns and widgets (BlocProvider, BlocBuilder) work for both

**Alternatives Considered**:
- Full Bloc pattern: Overkill for simple CRUD operations; events add unnecessary complexity
- Provider: Less structured; Cubit provides better separation of concerns
- Riverpod: Excellent but team prefers flutter_bloc per constitution

### 2. HTTP Client: http package

**Decision**: Use `http ^1.3.0` for API calls

**Rationale**:
- Lightweight, official Dart package
- Simple GET requests are all that's needed (fetch bars.json)
- No complex interceptors, caching, or retry logic required

**Alternatives Considered**:
- dio: More powerful but overkill for simple GET requests
- Built-in HttpClient: Lower level, http package is more ergonomic

### 3. Location Services: geolocator

**Decision**: Use `geolocator ^14.0.0` for device location and distance calculations

**Rationale**:
- Most popular location package for Flutter
- Cross-platform (iOS/Android) with unified API
- Built-in distance calculation with `Geolocator.distanceBetween()`
- Handles permission requests gracefully

**Alternatives Considered**:
- location package: Less feature-rich for distance calculations
- Manual Haversine implementation: Unnecessary when geolocator provides it

### 4. Map Display: flutter_map with OpenStreetMap

**Decision**: Use `flutter_map ^8.1.0` with OpenStreetMap tiles

**Rationale**:
- No API key required (uses free OpenStreetMap tiles)
- Simpler setup than Google Maps
- Sufficient for displaying a single bar location marker
- Good performance for static map display

**Alternatives Considered**:
- google_maps_flutter: Requires API key, billing account, more complex setup
- mapbox_gl: Requires API key, overkill for simple marker display

### 5. JSON Serialization: json_serializable

**Decision**: Use `json_serializable ^6.9.0` with `build_runner`

**Rationale**:
- Code generation reduces boilerplate for fromJson/toJson
- Type-safe deserialization matching the known JSON schema
- Industry standard for Flutter projects

**Alternatives Considered**:
- Manual fromJson: More error-prone, harder to maintain
- freezed: More powerful but overkill for simple data classes

### 6. Value Equality: equatable

**Decision**: Use `equatable ^2.0.5` for state classes

**Rationale**:
- Simplifies state comparison in Cubits
- Reduces boilerplate for == and hashCode
- Recommended by flutter_bloc documentation

**Alternatives Considered**:
- Manual equals override: More boilerplate, error-prone
- freezed: Would provide this but adds complexity

### 7. Architecture: Clean Architecture (4 Layers)

**Decision**: Follow Clean Architecture as specified in constitution

**Rationale**:
- Already mandated by project constitution
- Clear separation: presentation → application → domain → infrastructure
- Testable at each layer boundary
- Repository pattern abstracts data source

**Structure**:
```
lib/
├── presentation/     # Screens, Widgets, Cubits
├── application/      # Use cases (thin layer for this simple app)
├── domain/           # Entities, Repository interfaces
└── infrastructure/   # API client, Repository implementations
```

### 8. Navigation: go_router

**Decision**: Use `go_router ^15.1.0` for declarative routing

**Rationale**:
- Recommended by Flutter team for declarative navigation
- Simple setup for 2-screen app (list → detail)
- Supports deep linking if needed later
- Clean URL-based routing

**Alternatives Considered**:
- Navigator 2.0 directly: More boilerplate
- auto_route: Code generation overhead for simple navigation

### 9. Time Parsing and Happy Hour Logic

**Decision**: Use Dart's built-in DateTime with custom parsing for "HH:MM - HH:MM" format

**Rationale**:
- JSON provides times in simple "HH:MM - HH:MM" format
- No timezone complexity needed (single locale: Iceland)
- Parse start/end times, compare with DateTime.now()
- Handle overnight spans (end < start means crosses midnight)

**Implementation Notes**:
- Parse "15:00 - 19:00" → TimeOfDay(15,0), TimeOfDay(19,0)
- For overnight: if end < start, happy hour is active if now >= start OR now <= end
- Day matching: Parse "Every day", "Mon-Fri", etc. with simple string matching

### 10. Testing Strategy

**Decision**: Use `flutter_test` + `bloc_test ^10.0.0` + `mocktail ^1.0.5`

**Rationale**:
- bloc_test provides whenListen, expectBloc patterns for Cubit testing
- mocktail for mocking repositories without codegen
- Widget tests for screen integration

**Test Coverage Targets**:
- Cubits: 100% state transitions
- Repository: HTTP mocking
- Happy hour logic: Time parsing and overnight spans
- Widget tests: Key user flows

## Dependency Summary

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  http: ^1.3.0
  geolocator: ^14.0.0
  flutter_map: ^8.1.0
  latlong2: ^0.9.1
  go_router: ^15.1.0
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
  build_runner: ^2.4.15
  json_serializable: ^6.9.0
  flutter_lints: ^6.0.0
```

## Open Questions Resolved

| Question | Resolution |
|----------|------------|
| Map provider | flutter_map with OpenStreetMap (no API key needed) |
| Location package | geolocator for permissions + distance calc |
| Overnight happy hours | Handle by checking if end < start, then OR logic |
| Rating data | Not in current JSON schema; hide sort option if absent |

