# Tasks: Grapevine UI Theme

**Input**: Design documents from `/specs/005-grapevine-ui-theme/`  
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, contracts/ ✓

**Tests**: Not explicitly requested - test tasks omitted. Existing widget tests must pass.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- All paths relative to `app/` directory

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project dependencies and asset configuration

- [X] T001 Add flutter_svg dependency to `app/pubspec.yaml`
- [X] T002 Declare assets folder in `app/pubspec.yaml` under flutter.assets
- [X] T003 Run `flutter pub get` to install new dependencies
- [X] T004 [P] Verify grapevine_logo.svg loads correctly with test widget

**Checkpoint**: Dependencies installed, assets accessible ✅

---

## Phase 2: Foundational (Brand Abstraction System)

**Purpose**: Core brand infrastructure that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Brand Module

- [X] T005 Create `app/lib/presentation/core/brand/` directory structure
- [X] T006 [P] Create AppBrand enum in `app/lib/presentation/core/brand/app_brand.dart`
- [X] T007 [P] Create BrandColors abstract class in `app/lib/presentation/core/theme/brand_colors.dart`
- [X] T008 [P] Create BrandTypography abstract class in `app/lib/presentation/core/theme/brand_typography.dart`

### Default Theme Refactoring

- [X] T009 Rename `app/lib/presentation/core/theme/app_colors.dart` to `default_colors.dart`
- [X] T010 Refactor DefaultColors to implement BrandColors interface in `app/lib/presentation/core/theme/default_colors.dart`
- [X] T011 Rename `app/lib/presentation/core/theme/app_typography.dart` to `default_typography.dart`
- [X] T012 Refactor DefaultTypography to implement BrandTypography interface in `app/lib/presentation/core/theme/default_typography.dart`

### Grapevine Theme Implementation

- [X] T013 [P] Create GrapevineColors implementing BrandColors in `app/lib/presentation/core/theme/grapevine_colors.dart`
- [X] T014 [P] Create GrapevineTypography implementing BrandTypography in `app/lib/presentation/core/theme/grapevine_typography.dart`

### Brand Configuration

- [X] T015 Create BrandConfig class in `app/lib/presentation/core/brand/brand_config.dart`
- [X] T015a [US3] Add fallback to defaultBrand in BrandConfig.forBrand() for null/unexpected values (FR-009)
- [X] T016 Create BrandProvider InheritedWidget in `app/lib/presentation/core/brand/brand_provider.dart`
- [X] T017 Create barrel export in `app/lib/presentation/core/brand/brand.dart`

### App Integration

- [X] T018 Add kActiveBrand compile-time constant to `app/lib/main.dart`
- [X] T019 Wrap MaterialApp.router with BrandProvider in `app/lib/main.dart`
- [X] T020 Refactor AppTheme to use BrandConfig in `app/lib/presentation/core/theme/app_theme.dart`
- [X] T021 Update theme barrel export in `app/lib/presentation/core/theme/theme.dart`

**Checkpoint**: Brand system complete - app should run with either brand via kActiveBrand constant ✅

---

## Phase 3: User Story 1 - View Bars with Grapevine Branding (Priority: P1) 🎯 MVP

**Goal**: Bar list screen displays with Grapevine visual identity (teal/orange colors, editorial typography, logo in header)

**Independent Test**: Open app with `kActiveBrand = AppBrand.grapevine`, verify bar list shows Grapevine colors and logo

### Implementation for User Story 1

- [X] T022 [US1] Create BrandLogo widget for header in `app/lib/presentation/core/widgets/brand_logo.dart`
- [X] T023 [US1] Update widgets barrel export in `app/lib/presentation/core/widgets/widgets.dart`
- [X] T024 [US1] Update BarList header to use BrandLogo in `app/lib/presentation/bars/bar_list/bar_list.dart`
- [X] T025 [US1] Update BarList to use brand colors for background in `app/lib/presentation/bars/bar_list/bar_list.dart`
- [X] T026 [US1] Update BarListItem to use brand colors and typography in `app/lib/presentation/bars/bar_list/bar_list_item.dart`
- [X] T027 [US1] Update FilterChipBar to use brand colors in `app/lib/presentation/bars/bar_list/filter_chip_bar.dart`
- [X] T028 [US1] Update SortDropdown to use brand colors in `app/lib/presentation/bars/bar_list/sort_dropdown.dart`
- [X] T029 [US1] Update ErrorBanner to use brand colors in `app/lib/presentation/bars/bar_list/error_banner.dart`

**Checkpoint**: Bar list fully branded with Grapevine theme when kActiveBrand = AppBrand.grapevine ✅

---

## Phase 4: User Story 4 - See Grapevine Logo (Priority: P2)

**Goal**: Grapevine logo displays prominently and correctly in header

**Independent Test**: Verify logo renders at correct size, aspect ratio maintained, visible on all screen sizes

**Note**: Logo widget created in US1; this phase adds refinements and fallback handling

### Implementation for User Story 4

- [X] T030 [US4] Add logo fallback to app name text in BrandLogo widget in `app/lib/presentation/core/widgets/brand_logo.dart`
- [X] T031 [US4] Add responsive sizing to BrandLogo for different screen widths in `app/lib/presentation/core/widgets/brand_logo.dart`
- [X] T032 [US4] Apply color filter to SVG logo for theme consistency in `app/lib/presentation/core/widgets/brand_logo.dart`

**Checkpoint**: Logo displays correctly, has text fallback, responsive sizing works ✅

---

## Phase 5: User Story 2 - View Bar Details with Grapevine Styling (Priority: P2)

**Goal**: Bar detail page styled consistently with Grapevine brand aesthetic

**Independent Test**: Navigate to any bar detail, verify Grapevine colors, typography, and editorial styling

### Implementation for User Story 2

- [X] T033 [US2] Update BarDetail scaffold and app bar to use brand colors in `app/lib/presentation/bars/bar_detail/bar_detail.dart`
- [X] T034 [US2] Update BarDetail typography to use brand typography in `app/lib/presentation/bars/bar_detail/bar_detail.dart`
- [X] T035 [US2] Update happy hour time display with brand-appropriate active/inactive colors in `app/lib/presentation/bars/bar_detail/bar_detail.dart`
- [X] T036 [US2] Update price displays to use brand typography in `app/lib/presentation/bars/bar_detail/bar_detail.dart`
- [X] T037 [US2] Update BarMap styling for brand consistency in `app/lib/presentation/bars/bar_detail/bar_map.dart`
- [X] T038 [US2] Update any chips/badges to use brand colors in `app/lib/presentation/bars/bar_detail/bar_detail.dart`

**Checkpoint**: Bar detail fully branded with Grapevine theme ✅

---

## Phase 6: User Story 3 - Switch Between UI Themes (Priority: P3)

**Goal**: Developers can switch between themes by changing one constant

**Independent Test**: Change kActiveBrand, rebuild app, verify all screens render with selected theme

**Note**: Core functionality implemented in Phase 2; this phase validates and documents

### Implementation for User Story 3

- [X] T039 [US3] Verify default theme still works by setting `kActiveBrand = AppBrand.defaultBrand` in `app/lib/main.dart`
- [X] T040 [US3] Verify all screens render correctly with default theme
- [X] T041 [US3] Switch back to `kActiveBrand = AppBrand.grapevine` and verify
- [X] T042 [US3] Add code comment documenting theme switching in `app/lib/main.dart`

**Checkpoint**: Theme switching works with single constant change ✅

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final refinements and quality assurance

- [X] T043 [P] Update AnimatedCard to respect brand colors in `app/lib/presentation/core/widgets/animated_card.dart`
- [X] T044 [P] Update CircularBarImage to respect brand colors in `app/lib/presentation/core/widgets/circular_bar_image.dart`
- [X] T045 Verify all shimmer/loading states use brand colors
- [X] T046 Run existing widget tests with both themes
- [X] T047 Visual review: Compare Grapevine theme to grapevine.is website
- [X] T048 Performance check: Verify app launch time within 10% of baseline
- [X] T049 Clean up any unused imports after refactoring
- [X] T050 [P] Update README if needed for theme switching documentation

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1: Setup ──────────────────────────┐
                                         │
Phase 2: Foundational ◄──────────────────┘
    │
    ├──► Phase 3: US1 (Bar List) ──► Phase 4: US4 (Logo Refinement)
    │                                     │
    └──► Phase 5: US2 (Bar Detail) ◄──────┘
                   │
                   ▼
         Phase 6: US3 (Theme Switching Verification)
                   │
                   ▼
         Phase 7: Polish
```

### User Story Dependencies

| Story | Depends On | Can Parallel With |
|-------|------------|-------------------|
| US1 (P1) | Phase 2 complete | US2 (after Phase 2) |
| US4 (P2) | US1 T022 (BrandLogo created) | US2 |
| US2 (P2) | Phase 2 complete | US1, US4 |
| US3 (P3) | US1, US2, US4 complete | None |

### Within Each Phase

- All tasks marked [P] can run in parallel
- Sequential tasks must complete in order
- Models/interfaces before implementations
- Core widgets before screen integration

### Parallel Opportunities

**Phase 2 Parallel Groups:**
```
Group A: T006, T007, T008 (enum and interfaces)
Group B: T013, T014 (Grapevine implementations - after Group A)
```

**Phase 3 Parallel Group:**
```
T026, T027, T028, T029 can run in parallel (different files)
```

---

## Parallel Example: Phase 2 Foundational

```bash
# Launch interface definitions in parallel:
Task T007: "Create BrandColors abstract class in app/lib/presentation/core/theme/brand_colors.dart"
Task T008: "Create BrandTypography abstract class in app/lib/presentation/core/theme/brand_typography.dart"

# Then launch implementations in parallel:
Task T013: "Create GrapevineColors in app/lib/presentation/core/theme/grapevine_colors.dart"
Task T014: "Create GrapevineTypography in app/lib/presentation/core/theme/grapevine_typography.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (4 tasks)
2. Complete Phase 2: Foundational (17 tasks)
3. Complete Phase 3: User Story 1 (8 tasks)
4. **STOP and VALIDATE**: Test bar list with Grapevine branding
5. Deploy/demo if ready - **MVP delivers core branded experience**

### Incremental Delivery

| Increment | Phases | Value Delivered |
|-----------|--------|-----------------|
| MVP | 1 + 2 + 3 | Bar list with Grapevine branding |
| +Logo | 4 | Refined logo display |
| +Detail | 5 | Complete bar detail branding |
| +Verified | 6 | Confirmed theme switching |
| Complete | 7 | Polished, production-ready |

### Estimated Effort

| Phase | Tasks | Parallelizable | Estimated Time |
|-------|-------|----------------|----------------|
| Setup | 4 | 1 | 15 min |
| Foundational | 18 | 6 | 2-3 hours |
| US1 | 8 | 4 | 1-2 hours |
| US4 | 3 | 0 | 30 min |
| US2 | 6 | 0 | 1-2 hours |
| US3 | 4 | 0 | 30 min |
| Polish | 8 | 4 | 1 hour |
| **Total** | **51** | | **6-9 hours** |

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable after Phase 2
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- The logo SVG is already downloaded at `app/assets/images/grapevine_logo.svg`
- Existing tests must pass with both themes - run `flutter test` after Phase 2
- FR-009 (invalid theme fallback) addressed by T015a - BrandConfig.forBrand() returns defaultBrand for unexpected values

---

## Implementation Complete ✅

**All 51 tasks completed successfully.**

- All existing widget tests pass with both themes (51 tests)
- Theme switching works via single `kActiveBrand` constant change
- Brand system fully implemented with BrandProvider, BrandConfig, BrandColors, BrandTypography
- Grapevine theme uses teal (#0D9488) primary and orange (#E64A19) secondary colors
- Lora + Source Sans 3 typography for editorial magazine aesthetic
- SVG logo rendering with color filter support
- All widgets updated to use brand-aware colors and typography
