# Tasks: Internationalization & Image Caching

**Input**: Design documents from `/specs/003-i18n-image-caching/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Widget tests for locale verification will be created in Phase 7 (Polish) as verification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile app**: `app/` at repository root (Flutter project)
- Presentation layer: `app/lib/presentation/`
- Infrastructure layer: `app/lib/infrastructure/`
- Localization files: `app/lib/l10n/`
- Generated files: `app/lib/gen_l10n/` (do not edit)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add dependencies and project configuration for l10n and caching

- [X] T001 Add flutter_localizations, intl, cached_network_image, flutter_cache_manager dependencies to app/pubspec.yaml
- [X] T002 Add `generate: true` under flutter section in app/pubspec.yaml
- [X] T003 Run `flutter pub get` to install dependencies

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core l10n infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T004 Create l10n configuration file at app/l10n.yaml per contracts/l10n-config.md
- [X] T005 Create lib/l10n directory at app/lib/l10n/
- [X] T006 Create English ARB source file at app/lib/l10n/app_en.arb with all 27 strings from data-model.md
- [X] T007 Configure MaterialApp with localizationsDelegates and supportedLocales in app/lib/main.dart
- [X] T008 Run `flutter gen-l10n` to generate localization code in app/lib/gen_l10n/

**Checkpoint**: Foundation ready - l10n code generation works, English strings accessible via AppLocalizations.of(context)

---

## Phase 3: User Story 1 - Viewing App in Preferred Language (Priority: P1) 🎯 MVP

**Goal**: App automatically displays UI in user's device language (English, Icelandic, or Polish) with English fallback

**Independent Test**: Switch device language to Icelandic/Polish/French and verify language detection and fallback work correctly

### Implementation for User Story 1

- [X] T009 [P] [US1] Create Icelandic translations file at app/lib/l10n/app_is.arb with all 27 strings
- [X] T010 [P] [US1] Create Polish translations file at app/lib/l10n/app_pl.arb with all 27 strings
- [X] T011 [US1] Run `flutter gen-l10n` to regenerate localization code with all three locales
- [X] T012 [US1] Verify locale resolution: test device language set to is, pl, and fr (unsupported)

**Checkpoint**: User Story 1 complete - app detects device language and loads appropriate locale, falls back to English for unsupported languages

---

## Phase 4: User Story 2 - Browsing Bar List with Localized Content (Priority: P1)

**Goal**: Bar list screen displays all UI elements (filters, sort options, status badges, messages) in user's language

**Independent Test**: Navigate to bar list in each supported language and verify all static UI elements are translated

### Implementation for User Story 2

- [X] T013 [P] [US2] Replace hardcoded strings with l10n calls in app/lib/presentation/bars/bar_list/filter_chip_bar.dart
- [X] T014 [P] [US2] Replace hardcoded strings with l10n calls in app/lib/presentation/bars/bar_list/sort_dropdown.dart
- [X] T015 [P] [US2] Replace hardcoded strings with l10n calls in app/lib/presentation/bars/bar_list/bar_list_item.dart
- [X] T016 [P] [US2] Replace hardcoded strings with l10n calls in app/lib/presentation/bars/bar_list/error_banner.dart
- [X] T017 [US2] Replace hardcoded strings with l10n calls in app/lib/presentation/bars/bar_list/bar_list.dart

**Checkpoint**: User Story 2 complete - bar list screen fully localized, independently testable by switching device language

---

## Phase 5: User Story 3 - Viewing Bar Details with Localized Labels (Priority: P2)

**Goal**: Bar detail screen displays all section headers and labels in user's language

**Independent Test**: Navigate to any bar detail screen in each supported language and verify all section headers, labels, and promotional text are translated

### Implementation for User Story 3

- [X] T018 [US3] Replace hardcoded strings with l10n calls in app/lib/presentation/bars/bar_detail/bar_detail.dart

**Checkpoint**: User Story 3 complete - bar detail screen fully localized, independently testable by switching device language

---

## Phase 6: User Story 4 - Fast Image Loading with Caching (Priority: P2)

**Goal**: Images load quickly on subsequent visits via local caching with 10-day lifetime

**Independent Test**: Load images, go offline, verify cached images display; verify cache expiration after 10 days

### Implementation for User Story 4

- [X] T019 [US4] Create ImageCacheService with 10-day stalePeriod at app/lib/infrastructure/core/services/image_cache_service.dart per contracts/cache-config.md
- [X] T020 [US4] Replace Image.network with CachedNetworkImage using ImageCacheService.cacheManager in app/lib/presentation/bars/bar_detail/bar_map.dart (Note: No Image.network calls exist currently; ImageCacheService ready for future use)

**Checkpoint**: User Story 4 complete - images cached locally with 10-day lifetime, offline access works

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verification and cleanup across all user stories

- [X] T021 Verify no hardcoded user-facing strings remain in presentation layer (grep for quoted strings)
- [X] T022 Create widget test for locale verification at app/test/widget/localization_test.dart
- [X] T023 Run quickstart.md verification checklist
- [X] T024 Verify app builds and runs correctly on all target platforms (iOS, Android, Web)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - **BLOCKS all user stories**
- **User Story 1 (Phase 3)**: Depends on Foundational phase - creates translations
- **User Stories 2-4 (Phases 4-6)**: Depend on User Story 1 completion (need translations to exist)
  - US2 and US3 can proceed in parallel (different files)
  - US4 is independent of US2/US3 (image caching, not l10n)
- **Polish (Phase 7)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Depends on US1 (translation files must exist) - Can run parallel with US3/US4
- **User Story 3 (P2)**: Depends on US1 (translation files must exist) - Can run parallel with US2/US4
- **User Story 4 (P2)**: Can start after Foundational - Independent of l10n user stories

### Within Each User Story

- All tasks marked [P] within a story can run in parallel (different files)
- `flutter gen-l10n` must run after ARB files are created/modified
- String replacement tasks depend on l10n code being generated

### Parallel Opportunities

- **Phase 1**: T001 and T002 modify same file (sequential)
- **Phase 2**: T004, T005, T006 can run in parallel; T007 sequential; T008 depends on all
- **Phase 3**: T009 and T010 can run in parallel (different ARB files)
- **Phase 4**: T013, T014, T015, T016 can ALL run in parallel (different files)
- **Phase 5**: Single task
- **Phase 6**: T019 and T020 sequential (service must exist before use)

---

## Parallel Example: User Story 2

```bash
# Launch all bar list string replacements in parallel:
Task: "Replace hardcoded strings in filter_chip_bar.dart"   # T013
Task: "Replace hardcoded strings in sort_dropdown.dart"     # T014
Task: "Replace hardcoded strings in bar_list_item.dart"     # T015
Task: "Replace hardcoded strings in error_banner.dart"      # T016

# Then complete bar_list.dart (may import from above files):
Task: "Replace hardcoded strings in bar_list.dart"          # T017
```

---

## Implementation Strategy

### MVP First (User Stories 1 + 2)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 (language detection works)
4. Complete Phase 4: User Story 2 (bar list localized)
5. **STOP and VALIDATE**: Test US1 + US2 independently
6. Demo: Show app in English, Icelandic, Polish on bar list screen

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test language switching → MVP Ready!
3. Add User Story 2 → Bar list localized → Deploy/Demo
4. Add User Story 3 → Bar detail localized → Deploy/Demo
5. Add User Story 4 → Image caching → Deploy/Demo (independent)
6. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Developer A: User Story 1 (translations)
3. Once US1 complete:
   - Developer A: User Story 2 (bar list)
   - Developer B: User Story 3 (bar detail)
   - Developer C: User Story 4 (image caching)
4. Stories complete and integrate independently

---

## String Replacement Guide

For each presentation file, replace hardcoded strings using this pattern:

```dart
// Before
Text('Happy Hour')

// After
import 'package:happyhour_app/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context).appTitle)
```

### String Key Reference (from data-model.md)

| UI Element | ARB Key |
|------------|---------|
| App title | `appTitle` |
| "Try Again" button | `actionTryAgain` |
| "All" filter | `filterAll` |
| "Happy Hour Now" filter | `filterHappyHourNow` |
| "Default" sort | `sortDefault` |
| "Cheapest Beer" sort | `sortCheapestBeer` |
| "Nearest" sort | `sortNearest` |
| "Top Rated" sort | `sortTopRated` |
| "HAPPY HOUR" badge | `labelHappyHour` |
| "2-for-1" badge | `labelTwoForOne` |
| "Happy Hour Prices" header | `labelHappyHourPrices` |
| "Beer" label | `labelBeer` |
| "Wine" label | `labelWine` |
| "Oops!" error | `msgOops` |
| Distance with meters | `distanceMeters(distance)` |
| Distance with km | `distanceKilometers(distance)` |

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Run `flutter gen-l10n` after ANY ARB file changes
- Generated files in `lib/gen_l10n/` should NOT be edited manually

