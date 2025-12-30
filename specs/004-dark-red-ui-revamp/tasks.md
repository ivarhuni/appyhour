# Tasks: Dark Red UI Revamp

**Input**: Design documents from `/specs/004-dark-red-ui-revamp/`  
**Prerequisites**: spec.md (available), existing `.cursorrules` (available)

**Tests**: Not explicitly requested in spec — test tasks omitted.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter app**: `app/lib/` for source files
- **Theme**: `app/lib/presentation/core/theme/`
- **Components**: `app/lib/presentation/bars/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create theme infrastructure and design tokens

- [ ] T001 Create AppColors class with dark/red color palette in `app/lib/presentation/core/theme/app_colors.dart`
- [ ] T002 [P] Add Google Fonts dependency (`google_fonts: ^6.0.0`) to `app/pubspec.yaml` and run pub get
- [ ] T003 Create AppTypography class with Playfair Display, DM Sans, JetBrains Mono fonts in `app/lib/presentation/core/theme/app_typography.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core theme that MUST be complete before ANY user story can be fully implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T004 Create AppTheme class with Material 3 dark theme configuration in `app/lib/presentation/core/theme/app_theme.dart`
- [ ] T005 Update `app/lib/main.dart` to import and use AppTheme, remove inline `_buildTheme()` method, force dark mode only
- [ ] T006 Create presentation/core/theme barrel export in `app/lib/presentation/core/theme/theme.dart`

**Checkpoint**: Foundation ready — theme infrastructure in place, app uses dark theme exclusively

---

## Phase 3: User Story 5 — Reusable UI Design Prompt File (Priority: P1) 🎯 MVP

**Goal**: Consolidate and finalize the `.cursorrules` file with complete design system documentation

**Independent Test**: Verify `app/.cursorrules` exists, contains color palette, typography, shapes, animations, and anti-patterns; is under 350 lines

### Implementation for User Story 5

- [ ] T007 [US5] Review and update color palette section in `app/.cursorrules` to match AppColors.dart implementation
- [ ] T008 [US5] Add detailed typography section with font pairing rationale in `app/.cursorrules`
- [ ] T009 [US5] Add shape language section with exact border radius values in `app/.cursorrules`
- [ ] T010 [US5] Add animation timing and curve specifications in `app/.cursorrules`
- [ ] T011 [US5] Remove redundant `app/lib/presentation/.cursorrules` file, consolidate into root `.cursorrules`

**Checkpoint**: User Story 5 complete — single authoritative design system file exists at `app/.cursorrules`

---

## Phase 4: User Story 1 — Browsing Bars in Dark Mode (Priority: P1)

**Goal**: Apply dark theme with red accents to all screens, removing all amber/gold colors

**Independent Test**: Launch app, navigate through bar list and detail screens — all backgrounds should be near-black with red accent colors, no amber/gold visible

### Implementation for User Story 1

- [ ] T012 [US1] Update `app/lib/presentation/bars/bar_list/bar_list.dart` — apply dark surface colors to Scaffold and AppBar
- [ ] T013 [P] [US1] Update `app/lib/presentation/bars/bar_list/bar_list_item.dart` — replace theme.colorScheme.primary (amber) with AppColors.primary (red)
- [ ] T014 [P] [US1] Update `app/lib/presentation/bars/bar_list/filter_chip_bar.dart` — use red accent for selected state
- [ ] T015 [P] [US1] Update `app/lib/presentation/bars/bar_list/sort_dropdown.dart` — apply dark theme styling
- [ ] T016 [P] [US1] Update `app/lib/presentation/bars/bar_list/error_banner.dart` — use semantic error colors from AppColors
- [ ] T017 [US1] Update `app/lib/presentation/bars/bar_detail/bar_detail.dart` — apply dark surface and red accent colors throughout
- [ ] T018 [P] [US1] Update `app/lib/presentation/bars/bar_detail/bar_map.dart` — ensure dark mode compatible styling
- [ ] T019 [US1] Verify text contrast meets WCAG AA (4.5:1) — audit all Text widgets for proper AppColors.textPrimary/Secondary usage

**Checkpoint**: User Story 1 complete — entire app uses dark/red color scheme, no amber/gold remains

---

## Phase 5: User Story 2 — Viewing Bar Cards with Circular Images (Priority: P2)

**Goal**: Add circular bar images with glow effects to bar list items

**Independent Test**: Open bar list — each card displays a circular image placeholder; active happy hour shows pulsing red glow

### Implementation for User Story 2

- [ ] T020 [US2] Create CircularBarImage widget in `app/lib/presentation/core/widgets/circular_bar_image.dart` — circular container with BoxShape.circle, shadow, placeholder
- [ ] T021 [US2] Update Bar entity in `app/lib/domain/bars/entities/bar.dart` — add optional `imageUrl` field if not present
- [ ] T022 [US2] Update BarDTO in `app/lib/infrastructure/bars/dto/bar_dto.dart` — map imageUrl from API response
- [ ] T023 [US2] Update `app/lib/presentation/bars/bar_list/bar_list_item.dart` — integrate CircularBarImage on left side of card
- [ ] T024 [US2] Add active happy hour glow animation to CircularBarImage — pulsing red border when `isHappyHourActive`
- [ ] T025 [US2] Wrap CircularBarImage in Hero widget for list-to-detail transition with tag `'bar-image-${bar.id}'`

**Checkpoint**: User Story 2 complete — bar cards show circular images with glow effects

---

## Phase 6: User Story 3 — Experiencing Fluid Card Designs (Priority: P2)

**Goal**: Transform cards to use large rounded corners, gradient backgrounds, and pill-shaped chips

**Independent Test**: View bar list and detail — cards have 24px+ rounded corners, gradient fills, pill-shaped price chips

### Implementation for User Story 3

- [ ] T026 [US3] Create AnimatedCard widget in `app/lib/presentation/core/widgets/animated_card.dart` — 24px radius, gradient background, optional asymmetric corners
- [ ] T027 [US3] Update `app/lib/presentation/bars/bar_list/bar_list_item.dart` — replace Card with AnimatedCard, 24px border radius
- [ ] T028 [US3] Update `_buildPriceChip` method in bar_list_item.dart — change to pill shape (BorderRadius.circular(999))
- [ ] T029 [US3] Update two-for-one chip styling — pill shape with AppColors.success background
- [ ] T030 [US3] Update `app/lib/presentation/bars/bar_detail/bar_detail.dart` — apply gradient backgrounds to price cards and info sections
- [ ] T031 [US3] Update notes container and description sections — use large radius and gradient styling

**Checkpoint**: User Story 3 complete — all cards have organic, fluid design with 24px+ corners and gradients

---

## Phase 7: User Story 4 — Smooth Animations and Transitions (Priority: P3)

**Goal**: Add refined page transitions, staggered list animations, and tap feedback

**Independent Test**: Navigate between screens — transitions use fade+slide; list items appear with staggered animation; taps show subtle scale feedback

### Implementation for User Story 4

- [ ] T032 [US4] Create custom page transition in `app/lib/presentation/core/navigation/app_page_transitions.dart` — fade+slide over 300ms with easeOutCubic
- [ ] T033 [US4] Update `app/lib/main.dart` GoRouter configuration — apply custom page transitions using `pageBuilder`
- [ ] T034 [US4] Convert BarListItem to StatefulWidget with AnimationController for staggered entrance animation
- [ ] T035 [US4] Add stagger delay based on item index — each item delays 60ms after previous
- [ ] T036 [US4] Add tap scale feedback to BarListItem — scale down 3% on press, animate back on release
- [ ] T037 [US4] Add Hero transition for bar detail header — connect circular image from list to detail view
- [ ] T038 [US4] Add pulsing glow animation controller to CircularBarImage for active happy hour state

**Checkpoint**: User Story 4 complete — app feels polished with refined animations

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final refinements and validation

- [ ] T039 [P] Create barrel export for core widgets in `app/lib/presentation/core/widgets/widgets.dart`
- [ ] T040 [P] Run `dart fix --apply` and `dart format .` on app directory
- [ ] T041 Verify no amber/gold colors remain — grep codebase for `0xFFE6A919`, `0xFF8B4513`, color references
- [ ] T042 Manual UI audit — test all screens against spec.md acceptance criteria
- [ ] T043 Performance check — ensure 60fps scrolling on bar list with animations enabled

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3-7)**: All depend on Foundational phase completion
  - US5 and US1 are both P1 and can proceed in parallel
  - US2 and US3 are both P2 and can proceed in parallel after US1
  - US4 (P3) builds on US2 components (CircularBarImage with animation)
- **Polish (Phase 8)**: Depends on all desired user stories being complete

### User Story Dependencies

```
Phase 1: Setup
    ↓
Phase 2: Foundational
    ↓
    ├── Phase 3: US5 (.cursorrules) ───────────────────┐
    │                                                   │
    └── Phase 4: US1 (Dark Mode) ──────────────────────┤
            ↓                                           │
            ├── Phase 5: US2 (Circular Images) ────────┤
            │                                           │
            └── Phase 6: US3 (Fluid Cards) ────────────┤
                    ↓                                   │
                    Phase 7: US4 (Animations) ─────────┤
                            ↓                           │
                            Phase 8: Polish ←──────────┘
```

### Within Each User Story

- Models/DTOs before widgets (if applicable)
- Reusable widgets before screen-specific implementations
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003 can run in parallel (different files)
- T013, T014, T015, T016, T018 can all run in parallel (different screen files)
- All US2 model tasks (T021, T022) can run before widget implementation
- T039, T040 can run in parallel (different concerns)

---

## Parallel Example: User Story 1 (Dark Mode)

```bash
# After Foundational phase complete, launch parallel tasks:
Task: T013 "Update bar_list_item.dart — replace amber with red"
Task: T014 "Update filter_chip_bar.dart — red accent for selected"
Task: T015 "Update sort_dropdown.dart — dark theme"
Task: T016 "Update error_banner.dart — semantic error colors"
Task: T018 "Update bar_map.dart — dark mode styling"

# Then sequential tasks:
Task: T012 "Update bar_list.dart — dark surface colors"
Task: T017 "Update bar_detail.dart — dark surface and red accents"
Task: T019 "Audit text contrast for WCAG AA"
```

---

## Implementation Strategy

### MVP First (US5 + US1 Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: Foundational (T004-T006)
3. Complete Phase 3: User Story 5 — .cursorrules consolidation (T007-T011)
4. Complete Phase 4: User Story 1 — Dark theme applied (T012-T019)
5. **STOP and VALIDATE**: App should be fully dark/red themed with no amber
6. Deploy/demo if ready — this is a functional MVP

### Incremental Delivery

1. Complete Setup + Foundational → Theme infrastructure ready
2. Add US5 → Design system documented → Demo to team
3. Add US1 → Dark mode complete → Deploy (MVP!)
4. Add US2 + US3 → Visual polish → Deploy
5. Add US4 → Animation polish → Deploy (Full feature)

### Suggested MVP Scope

**MVP = Phase 1 + Phase 2 + Phase 3 + Phase 4 (T001-T019)**

This delivers:
- Complete dark/red color scheme
- Documented design system in `.cursorrules`
- No amber/gold colors remaining
- WCAG AA compliant text contrast

---

## Summary

| Phase | User Story | Task Count | Parallel Tasks |
|-------|------------|------------|----------------|
| 1 | Setup | 3 | 1 |
| 2 | Foundational | 3 | 0 |
| 3 | US5 (.cursorrules) | 5 | 0 |
| 4 | US1 (Dark Mode) | 8 | 5 |
| 5 | US2 (Circular Images) | 6 | 0 |
| 6 | US3 (Fluid Cards) | 6 | 0 |
| 7 | US4 (Animations) | 7 | 0 |
| 8 | Polish | 5 | 2 |
| **Total** | | **43** | **8** |

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- The existing `app/.cursorrules` file already documents most design patterns — US5 is about consolidation and finalization
- Dark mode is enforced — light theme support is explicitly out of scope per spec

