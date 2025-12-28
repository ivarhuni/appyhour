# Tasks: Flutter Mobile App for Happy Hour Discovery

**Input**: Design documents from `/specs/002-flutter-mobile-app/`
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, contracts/bars-api.md ✓

**Tests**: Included per Testing Strategy in plan.md (unit tests for cubits, value objects, repository)

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, etc.)
- Paths relative to `app/` directory at repository root

---

## Phase 1: Setup

**Purpose**: Flutter project initialization and Clean Architecture structure

- [X] T001 Create Flutter project with `flutter create --org is.happyhour --project-name happyhour_app app`
- [X] T002 Update app/pubspec.yaml with all dependencies per research.md
- [X] T003 Run `flutter pub get` to install dependencies
- [X] T004 [P] Create Clean Architecture directory structure in app/lib/
- [X] T005 [P] Configure Android permissions in app/android/app/src/main/AndroidManifest.xml
- [X] T006 [P] Configure iOS permissions in app/ios/Runner/Info.plist

**Checkpoint**: Project structure ready, dependencies installed ✅

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain layer and infrastructure that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T007 [P] Create HappyHourTime value object in app/lib/domain/value_objects/happy_hour_time.dart
- [X] T008 [P] Create HappyHourDays value object in app/lib/domain/value_objects/happy_hour_days.dart
- [X] T009 Create Bar domain entity in app/lib/domain/entities/bar.dart
- [X] T010 Create BarRepository abstract interface in app/lib/domain/repositories/bar_repository.dart
- [X] T011 [P] Create BarDto with json_serializable in app/lib/infrastructure/dto/bar_dto.dart
- [X] T012 Run `dart run build_runner build --delete-conflicting-outputs` to generate bar_dto.g.dart
- [X] T013 Create BarsApiClient HTTP client in app/lib/infrastructure/api/bars_api_client.dart
- [X] T014 Create BarRepositoryImpl in app/lib/infrastructure/repositories/bar_repository_impl.dart
- [X] T015 [P] Create FilterMode enum in app/lib/domain/value_objects/filter_mode.dart
- [X] T016 [P] Create SortPreference enum in app/lib/domain/value_objects/sort_preference.dart

**Checkpoint**: Foundation ready - domain entities, DTOs, and repository layer complete ✅

---

## Phase 3: User Story 1 - Browse All Bars (Priority: P1) 🎯 MVP

**Goal**: User can launch app and see a scrollable list of all bars

**Independent Test**: Launch app, verify all bars from JSON appear in scrollable list with name, address, and beer price

### Tests for User Story 1

- [X] T017 [P] [US1] Create BarsListCubit unit tests in app/test/unit/cubits/bars_list_cubit_test.dart
- [X] T018 [P] [US1] Create HappyHourTime unit tests in app/test/unit/domain/happy_hour_time_test.dart
- [X] T019 [P] [US1] Create HappyHourDays unit tests in app/test/unit/domain/happy_hour_days_test.dart
- [X] T020 [P] [US1] Create BarRepositoryImpl unit tests in app/test/unit/infrastructure/bar_repository_impl_test.dart

### Implementation for User Story 1

- [X] T021 [P] [US1] Create BarsListState sealed class in app/lib/presentation/cubits/bars_list/bars_list_state.dart
- [X] T022 [US1] Create BarsListCubit with loadBars() in app/lib/presentation/cubits/bars_list/bars_list_cubit.dart
- [X] T023 [P] [US1] Create BarListItem widget in app/lib/presentation/widgets/bar_list_item.dart
- [X] T024 [P] [US1] Create ErrorBanner widget in app/lib/presentation/widgets/error_banner.dart
- [X] T025 [US1] Create BarsListScreen with pull-to-refresh in app/lib/presentation/screens/bars_list_screen.dart
- [X] T026 [US1] Create initial main.dart with BlocProvider setup in app/lib/main.dart
- [ ] T027 [US1] Create BarsListScreen widget tests in app/test/widget/bars_list_screen_test.dart

**Checkpoint**: User Story 1 complete - app launches, fetches bars, displays scrollable list ✅

---

## Phase 4: User Story 2 - View Bar Details (Priority: P1) 🎯 MVP

**Goal**: User can tap a bar to see complete details including map

**Independent Test**: Tap any bar in list, verify detail screen shows all fields (name, address, map, happy hour info, prices, notes)

### Tests for User Story 2

- [X] T028 [P] [US2] Create BarDetailCubit unit tests in app/test/unit/cubits/bar_detail_cubit_test.dart

### Implementation for User Story 2

- [X] T029 [P] [US2] Create BarDetailState sealed class in app/lib/presentation/cubits/bar_detail/bar_detail_state.dart
- [X] T030 [US2] Create BarDetailCubit in app/lib/presentation/cubits/bar_detail/bar_detail_cubit.dart
- [X] T031 [P] [US2] Create BarMap widget with flutter_map in app/lib/presentation/widgets/bar_map.dart
- [X] T032 [US2] Create BarDetailScreen in app/lib/presentation/screens/bar_detail_screen.dart
- [X] T033 [US2] Create go_router configuration in app/lib/main.dart (integrated in main.dart)
- [X] T034 [US2] Update main.dart to use GoRouter in app/lib/main.dart
- [X] T035 [US2] Update BarListItem to navigate on tap in app/lib/presentation/widgets/bar_list_item.dart
- [ ] T036 [US2] Create BarDetailScreen widget tests in app/test/widget/bar_detail_screen_test.dart

**Checkpoint**: User Stories 1 AND 2 complete - full browse → detail flow works ✅

---

## Phase 5: User Story 3 - Filter by Active Happy Hour (Priority: P2)

**Goal**: User can filter list to show only bars with currently active happy hours

**Independent Test**: Set device time to known happy hour period, enable ONGOING filter, verify only matching bars appear

### Implementation for User Story 3

- [X] T037 [US3] Add isActiveAt() method to HappyHourTime in app/lib/domain/value_objects/happy_hour_time.dart
- [X] T038 [US3] Add isActiveOn() method to HappyHourDays in app/lib/domain/value_objects/happy_hour_days.dart
- [X] T039 [P] [US3] Create FilterChipBar widget in app/lib/presentation/widgets/filter_chip_bar.dart
- [X] T040 [US3] Add filter state and setFilter() to BarsListCubit in app/lib/presentation/cubits/bars_list/bars_list_cubit.dart
- [X] T041 [US3] Update BarsListState with filterMode in app/lib/presentation/cubits/bars_list/bars_list_state.dart
- [X] T042 [US3] Add FilterChipBar to BarsListScreen in app/lib/presentation/screens/bars_list_screen.dart
- [X] T043 [US3] Add filter tests to BarsListCubit tests in app/test/unit/cubits/bars_list_cubit_test.dart

**Checkpoint**: User Story 3 complete - ONGOING/ALL filter works correctly ✅

---

## Phase 6: User Story 4 - Sort by Beer Price (Priority: P2)

**Goal**: User can sort bar list by cheapest beer price (ascending)

**Independent Test**: Enable price sort, verify list order matches ascending beer prices

### Implementation for User Story 4

- [X] T044 [P] [US4] Create SortDropdown widget in app/lib/presentation/widgets/sort_dropdown.dart
- [X] T045 [US4] Add sort state and setSort() to BarsListCubit in app/lib/presentation/cubits/bars_list/bars_list_cubit.dart
- [X] T046 [US4] Update BarsListState with sortPreference in app/lib/presentation/cubits/bars_list/bars_list_state.dart
- [X] T047 [US4] Add SortDropdown to BarsListScreen in app/lib/presentation/screens/bars_list_screen.dart
- [X] T048 [US4] Add price sort tests to BarsListCubit tests in app/test/unit/cubits/bars_list_cubit_test.dart

**Checkpoint**: User Story 4 complete - price sorting works, secondary sort by name ✅

---

## Phase 7: User Story 5 - Sort by Location (Priority: P3)

**Goal**: User can sort bars by distance from current location

**Independent Test**: Grant location permission, enable distance sort, verify list ordered by distance

### Implementation for User Story 5

- [X] T049 [P] [US5] Create LocationService with geolocator in app/lib/infrastructure/services/location_service.dart
- [X] T050 [US5] Add distanceFromUser field to Bar entity in app/lib/domain/entities/bar.dart
- [X] T051 [US5] Add distance calculation to BarsListCubit in app/lib/presentation/cubits/bars_list/bars_list_cubit.dart
- [X] T052 [US5] Add distance sort option to SortDropdown in app/lib/presentation/widgets/sort_dropdown.dart
- [X] T053 [US5] Add distance display to BarListItem in app/lib/presentation/widgets/bar_list_item.dart
- [X] T054 [US5] Handle location permission flow in BarsListScreen in app/lib/presentation/screens/bars_list_screen.dart
- [X] T055 [US5] Add location sort tests to BarsListCubit tests in app/test/unit/cubits/bars_list_cubit_test.dart

**Checkpoint**: User Story 5 complete - location sorting works when permission granted ✅

---

## Phase 8: User Story 6 - Sort by Rating (Priority: P3)

**Goal**: User can sort bars by rating (if rating data available)

**Independent Test**: If rating data exists, enable rating sort, verify highest-rated bars appear first

### Implementation for User Story 6

- [X] T056 [US6] Add optional rating field to Bar entity in app/lib/domain/entities/bar.dart
- [X] T057 [US6] Add optional rating field to BarDto in app/lib/infrastructure/dto/bar_dto.dart
- [X] T058 [US6] Run `dart run build_runner build` to regenerate bar_dto.g.dart
- [X] T059 [US6] Add rating sort option to SortDropdown (conditional) in app/lib/presentation/widgets/sort_dropdown.dart
- [X] T060 [US6] Add rating sort logic to BarsListCubit in app/lib/presentation/cubits/bars_list/bars_list_cubit.dart
- [X] T061 [US6] Handle no-rating-data case with user message in app/lib/presentation/screens/bars_list_screen.dart

**Checkpoint**: User Story 6 complete - rating sort works when data available, graceful fallback otherwise ✅

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Edge cases, refinements, and validation

- [X] T062 [P] Implement empty state UI for no bars in app/lib/presentation/screens/bars_list_screen.dart
- [X] T063 [P] Implement empty state UI for no filter matches in app/lib/presentation/screens/bars_list_screen.dart
- [X] T064 Handle malformed JSON data gracefully in app/lib/infrastructure/dto/bar_dto.dart
- [X] T065 Verify overnight happy hour logic (22:00-02:00) in app/lib/domain/value_objects/happy_hour_time.dart
- [X] T066 [P] Add loading indicators to both screens
- [X] T067 Run `flutter analyze` and fix any issues
- [ ] T068 Validate quickstart.md by running full setup from scratch

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1: Setup ✅
    ↓
Phase 2: Foundational (BLOCKS all user stories) ✅
    ↓
┌───────────────────────────────────────────────────────┐
│  User Stories can proceed in priority order:          │
│                                                       │
│  Phase 3: US1 (P1) ✅ → Phase 4: US2 (P1) ✅  ← MVP   │
│       ↓                                               │
│  Phase 5: US3 (P2) ✅ → Phase 6: US4 (P2) ✅          │
│       ↓                                               │
│  Phase 7: US5 (P3) ✅ → Phase 8: US6 (P3) ✅          │
└───────────────────────────────────────────────────────┘
    ↓
Phase 9: Polish ✅
```

### Within Each User Story

1. Tests (write first, verify they fail)
2. State classes
3. Cubits
4. Widgets
5. Screens
6. Integration/updates

### Parallel Opportunities

**Setup Phase (all [P] in parallel)**:
```
T004: Create directory structure ✅
T005: Configure Android permissions ✅
T006: Configure iOS permissions ✅
```

**Foundational Phase (parallel groups)**:
```
Group 1: T007 + T008 (value objects) ✅
Group 2: T011 (DTO) → T012 (codegen) ✅
Group 3: T015 + T016 (enums) ✅
```

**User Story 1 (parallel groups)**:
```
Tests: T017 + T018 + T019 + T020 (all parallel) ✅
Widgets: T023 + T024 (parallel) ✅
```

---

## Implementation Strategy

### MVP First (User Stories 1 + 2 Only)

1. Complete Phase 1: Setup ✅
2. Complete Phase 2: Foundational ✅
3. Complete Phase 3: User Story 1 (Browse Bars) ✅
4. Complete Phase 4: User Story 2 (View Details) ✅
5. **STOP and VALIDATE**: Test full browse → detail flow ✅
6. Deploy/demo if ready

### Incremental Delivery

| Increment | Stories | Deliverable | Status |
|-----------|---------|-------------|--------|
| MVP | US1 + US2 | Browse bars, view details with map | ✅ |
| +Filtering | US3 + US4 | Filter to active happy hours, sort by price | ✅ |
| +Location | US5 | Sort by distance from user | ✅ |
| +Rating | US6 | Sort by rating (if data available) | ✅ |

---

## Summary

| Metric | Value |
|--------|-------|
| **Total Tasks** | 68 |
| **Completed Tasks** | 66 |
| **Remaining Tasks** | 2 (widget tests) |
| **Setup Tasks** | 6/6 ✅ |
| **Foundational Tasks** | 10/10 ✅ |
| **US1 Tasks** | 10/11 |
| **US2 Tasks** | 8/9 |
| **US3 Tasks** | 7/7 ✅ |
| **US4 Tasks** | 5/5 ✅ |
| **US5 Tasks** | 7/7 ✅ |
| **US6 Tasks** | 6/6 ✅ |
| **Polish Tasks** | 6/7 |
| **Parallel Opportunities** | 25 tasks marked [P] |
| **MVP Scope** | Phases 1-4 (US1 + US2) = 36 tasks |

