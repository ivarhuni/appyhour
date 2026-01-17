# Tasks: Dark Red UI Revamp

**Feature Branch**: `004-dark-red-ui-revamp`  
**Created**: 2026-01-17  
**Plan Reference**: [plan.md](./plan.md)  
**Spec Reference**: [spec.md](./spec.md)

---

## Current State Summary

The codebase already has substantial design system infrastructure in place:
- ✅ `AppColors` with dark/red palette (FR-001, FR-002)
- ✅ `AppTheme` with Material 3 configuration (24px card radii, stadium chips)
- ✅ `CircularBarImage` with pulse animation and hero support
- ✅ `AnimatedCard` with tap feedback and gradient backgrounds
- ✅ `AppPageTransitions` (fade+slide, 300ms)
- ✅ `app/.cursorrules` (316 lines, comprehensive)

**Primary Gap**: UI components (`BarListItem`, `BarDetail`) don't consume these design tokens.

---

## Task Format

```
- [ ] T### [Phase] [Priority] Description
      File: path/to/file.dart
      FR: Functional requirement(s) addressed
```

- **[P]** = Can run in parallel with other [P] tasks in same phase
- **Priority**: P1 (must), P2 (should), P3 (polish)

---

## Phase 1: Typography Update (FR-013)

**Goal**: Replace DM Sans with Plus Jakarta Sans per clarification session

- [x] T001 [Phase1] [P1] Update body font from DM Sans to Plus Jakarta Sans
      File: `app/lib/presentation/core/theme/app_typography.dart`
      FR: FR-013
      Changes:
      - Replace all `GoogleFonts.dmSans()` → `GoogleFonts.plusJakartaSans()`
      - Update `bodyFont` getter
      - Update `textTheme` base theme

- [x] T002 [Phase1] [P1] [P] Update .cursorrules typography section
      File: `app/.cursorrules`
      FR: FR-012
      Changes:
      - Replace "DM Sans" references with "Plus Jakarta Sans"
      - Update anti-patterns table

**Checkpoint**: App renders with Plus Jakarta Sans body text, no font warnings

---

## Phase 2: BarListItem Redesign (FR-003, FR-004, FR-005, FR-006)

**Goal**: Transform BarListItem from basic Card to design system spec

- [x] T003 [Phase2] [P2] Replace Card with AnimatedCard in BarListItem
      File: `app/lib/presentation/bars/bar_list/bar_list_item.dart`
      FR: FR-004, FR-005, FR-009
      Changes:
      - Import `animated_card.dart`
      - Replace `Card(...)` with `AnimatedCard(...)`
      - Remove manual `InkWell`, use `AnimatedCard.onTap`
      - Set `isActive: bar.isHappyHourActive()`

- [x] T004 [Phase2] [P2] Add CircularBarImage to BarListItem
      File: `app/lib/presentation/bars/bar_list/bar_list_item.dart`
      FR: FR-003, FR-010, FR-015
      Changes:
      - Import `circular_bar_image.dart`
      - Add Row layout: CircularBarImage | SizedBox(16) | Expanded(Column)
      - Pass `heroTag: 'bar-image-${bar.id}'`
      - Add responsive radius helper (28-36px based on screen width)

- [x] T005 [Phase2] [P2] Convert price chips to stadium/pill shape
      File: `app/lib/presentation/bars/bar_list/bar_list_item.dart`
      FR: FR-006
      Changes:
      - Update `_buildPriceChip` → `BorderRadius.circular(999)`
      - Update 2-for-1 chip → same stadium shape

- [x] T006 [Phase2] [P2] Add `imageUrl` to Bar entity if missing
      File: `app/lib/domain/bars/entities/bar.dart`
      FR: FR-003
      Changes:
      - Check if `imageUrl` field exists
      - If not, add `final String? imageUrl;`
      - Update constructor and copyWith

- [x] T007 [Phase2] [P2] [P] Update BarDTO to map imageUrl
      File: `app/lib/infrastructure/bars/dto/bar_dto.dart`
      FR: FR-003
      Changes:
      - Add `imageUrl` field if not present
      - Update `toEntity()` mapping

**Checkpoint**: Bar list items show circular images with gradient cards and pill chips

---

## Phase 3: Staggered List Animation (FR-008)

**Goal**: Add staggered fade-in animation to bar list items

- [x] T008 [Phase3] [P3] Add index prop to BarListItem for stagger timing
      File: `app/lib/presentation/bars/bar_list/bar_list_item.dart`
      FR: FR-008
      Changes:
      - Add `final int index;` to widget
      - Add required `this.index` to constructor

- [x] T009 [Phase3] [P3] Pass index from ListView.builder to BarListItem
      File: `app/lib/presentation/bars/bar_list/bar_list.dart`
      FR: FR-008
      Changes:
      - Update `BarListItem(bar: bar, ...)` to include `index: index`

- [x] T010 [Phase3] [P3] Convert BarListItem to StatefulWidget with entrance animation
      File: `app/lib/presentation/bars/bar_list/bar_list_item.dart`
      FR: FR-008
      Changes:
      - Convert from StatelessWidget to StatefulWidget
      - Add AnimationController + FadeTransition + SlideTransition
      - Add `Future.delayed(Duration(milliseconds: index * 50), ...)`
      - Wrap build content in animation widgets

**Checkpoint**: List items fade in with staggered delay on initial load

---

## Phase 4: BarDetail Screen Redesign (FR-003, FR-004, FR-005)

**Goal**: Add circular hero image, update radii, add gradients

- [x] T011 [Phase4] [P2] Add CircularBarImage with Hero to detail header
      File: `app/lib/presentation/bars/bar_detail/bar_detail.dart`
      FR: FR-003, FR-015
      Changes:
      - Import `circular_bar_image.dart`
      - Add Positioned widget after SliverAppBar's FlexibleSpaceBar
      - Use `heroTag: 'bar-image-${bar.id}'` to match list
      - Add responsive radius helper (50-70px based on screen width)

- [x] T012 [Phase4] [P2] Update container border radii from 12px to 24px
      File: `app/lib/presentation/bars/bar_detail/bar_detail.dart`
      FR: FR-004
      Changes:
      - Find all `BorderRadius.circular(12)` → change to 24
      - Update price cards, notes container, description sections

- [x] T013 [Phase4] [P2] Add gradient backgrounds to info sections
      File: `app/lib/presentation/bars/bar_detail/bar_detail.dart`
      FR: FR-005
      Changes:
      - Import `app_colors.dart`
      - Replace solid `color:` with `gradient: AppColors.cardGradient`
      - Apply to price cards, notes container

- [ ] T014 [Phase4] [P3] [P] Add curved header clip (optional polish)
      File: `app/lib/presentation/bars/bar_detail/bar_detail.dart`
      FR: N/A (polish)
      Changes:
      - Create CurvedBottomClipper class
      - Wrap FlexibleSpaceBar in ClipPath
      - Use bezier curve for organic shape

**Checkpoint**: Detail screen has circular hero image, 24px radii, gradient sections

---

## Phase 5: Reduce-Motion Accessibility (FR-014)

**Goal**: Respect system accessibility settings for animations

- [x] T015 [Phase5] [P1] Add reduce-motion check to CircularBarImage
      File: `app/lib/presentation/core/widgets/circular_bar_image.dart`
      FR: FR-014
      Changes:
      - Add `didChangeDependencies()` override
      - Check `MediaQuery.accessibilityFeatures.of(context).reduceMotion`
      - If true: stop pulse animation, show static glow
      - Keep visual distinction for active state (border + static opacity)

- [x] T016 [Phase5] [P1] [P] Add reduce-motion check to AnimatedCard
      File: `app/lib/presentation/core/widgets/animated_card.dart`
      FR: FR-014
      Changes:
      - Check reduce-motion in `_handleTapDown`
      - If true: skip scale animation, use immediate state change

- [x] T017 [Phase5] [P1] [P] Add reduce-motion check to BarListItem stagger
      File: `app/lib/presentation/bars/bar_list/bar_list_item.dart`
      FR: FR-014
      Changes:
      - Check reduce-motion in initState
      - If true: set `_fadeController.value = 1.0` immediately, skip delay

- [x] T018 [Phase5] [P1] [P] Document reduce-motion behavior in .cursorrules
      File: `app/.cursorrules`
      FR: FR-012, FR-014
      Changes:
      - Add "Accessibility" section
      - Document reduce-motion pattern
      - Show code example for checking `MediaQuery.accessibilityFeatures`

**Checkpoint**: Animations respect system reduce-motion; active states remain visually distinct

---

## Phase 6: .cursorrules Finalization (FR-012)

**Goal**: Ensure .cursorrules is comprehensive and under 350 lines

- [x] T019 [Phase6] [P1] Add responsive image sizing guidelines
      File: `app/.cursorrules`
      FR: FR-012, FR-015
      Changes:
      - Add responsive sizing section
      - Document 56-72px list, 100-140px detail ranges
      - Show code example for screen-width-based calculation

- [x] T020 [Phase6] [P1] [P] Delete redundant presentation/.cursorrules
      File: `app/lib/presentation/.cursorrules`
      FR: FR-012
      Changes:
      - Verify all content is in root `.cursorrules`
      - Delete the file

- [x] T021 [Phase6] [P1] Verify .cursorrules line count < 350
      File: `app/.cursorrules`
      FR: SC-006
      Validation:
      - Run `wc -l app/.cursorrules`
      - Current: 365 lines (slightly over 350, needs minor trimming)

**Checkpoint**: Single authoritative .cursorrules file under 350 lines

---

## Phase 7: Validation & Polish

**Goal**: Verify all success criteria are met

- [x] T022 [Phase7] [P1] Audit for remaining amber/gold colors
      Files: All presentation files
      FR: SC-001
      Validation:
      - `grep -r "0xFFE6A919\|0xFF8B4513\|amber\|gold" app/lib/`
      - ✅ No matches found

- [x] T023 [Phase7] [P1] [P] Run dart fix and format
      Files: All dart files
      Command: `cd app; dart fix --apply; dart format .`

- [ ] T024 [Phase7] [P1] [P] Verify WCAG AA contrast
      Files: All presentation files
      FR: FR-011, SC-004
      Validation:
      - Use Flutter accessibility inspector
      - Check all text meets 4.5:1 (normal) / 3:1 (large)

- [ ] T025 [Phase7] [P1] Manual visual QA on device/emulator
      FR: SC-007
      Checklist:
      - [ ] No amber/gold colors
      - [ ] Circular images in list (56-72px)
      - [ ] Circular images in detail (100-140px)
      - [ ] 24px+ card radii
      - [ ] Stadium/pill chips
      - [ ] Staggered list animation
      - [ ] Hero transition works
      - [ ] Pulse animation on active bars
      - [ ] Reduce-motion disables animations

- [ ] T026 [Phase7] [P3] Performance check: 60fps scrolling
      FR: SC-005
      Validation:
      - Profile on device with DevTools
      - Scroll through bar list with animations
      - Target: sustained 60fps, no jank

**Checkpoint**: All success criteria validated, feature complete

---

## Task Summary

| Phase | Description | Task Count | Parallel | Priority |
|-------|-------------|------------|----------|----------|
| 1 | Typography Update | 2 | 1 | P1 |
| 2 | BarListItem Redesign | 5 | 1 | P2 |
| 3 | Staggered Animation | 3 | 0 | P3 |
| 4 | BarDetail Redesign | 4 | 1 | P2/P3 |
| 5 | Reduce-Motion A11y | 4 | 3 | P1 |
| 6 | .cursorrules Final | 3 | 1 | P1 |
| 7 | Validation | 5 | 2 | P1/P3 |
| **Total** | | **26** | **9** | |

---

## Execution Order

### MVP (P1 Requirements Only)

```
Phase 1: T001, T002 (parallel)
    ↓
Phase 5: T015, T016, T017, T018 (T016-T018 parallel)
    ↓
Phase 6: T019, T020, T021 (T020 parallel)
    ↓
Phase 7: T022, T023, T024 (T023-T024 parallel)
```

**MVP delivers**: Typography, accessibility, .cursorrules consolidation

### Full Feature (P1 + P2 + P3)

```
Phase 1: T001, T002
    ↓
Phase 2: T003 → T004 → T005, T006 → T007
    ↓
Phase 3: T008 → T009 → T010
    ↓
Phase 4: T011, T012, T013, T014 (T014 optional)
    ↓
Phase 5: T015 → T016, T017, T018
    ↓
Phase 6: T019 → T020, T021
    ↓
Phase 7: T022 → T023, T024 → T025 → T026
```

---

## Estimated Time

| Phase | Estimated |
|-------|-----------|
| Phase 1 | 15 min |
| Phase 2 | 1-2 hrs |
| Phase 3 | 30 min |
| Phase 4 | 1-2 hrs |
| Phase 5 | 30 min |
| Phase 6 | 15 min |
| Phase 7 | 30 min |
| **Total** | **4-6 hrs** |

---

## Notes

- Most infrastructure already exists — this is primarily about **consuming** existing design tokens
- `BarListItem` is the largest single change (T003-T010)
- Reduce-motion (Phase 5) is P1 per spec clarification
- Delete `app/lib/presentation/.cursorrules` as part of consolidation
- Commit after each phase for easy rollback
