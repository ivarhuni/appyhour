# Implementation Plan: Dark Red UI Revamp

**Feature Branch**: `004-dark-red-ui-revamp`  
**Created**: 2026-01-17  
**Spec Reference**: [spec.md](./spec.md)

---

## Executive Summary

Transform the HappyHour Flutter app from its current partially-implemented dark theme to a fully cohesive dark/red design system with circular imagery, gradient cards, and fluid animations. The codebase already has substantial infrastructure (AppColors, AppTheme, AnimatedCard, CircularBarImage, page transitions) but the UI components (BarListItem, BarDetail) don't yet consume these design tokens consistently.

**Primary Gap**: The `BarListItem` widget uses old Material 3 defaults (12px corners, no circular images, no gradients) instead of the design system defined in `.cursorrules`.

---

## Current State Analysis

### ✅ Already Implemented (Design System Foundation)

| Component | File | Status |
|-----------|------|--------|
| Dark color palette | `app_colors.dart` | ✅ Complete - all FR-001/FR-002 colors defined |
| AppTheme with Material 3 | `app_theme.dart` | ✅ Complete - 24px card radii, stadium chips, dark scheme |
| Typography (Playfair Display + DM Sans) | `app_typography.dart` | ⚠️ Partial - uses DM Sans instead of Plus Jakarta Sans |
| Circular image with glow | `circular_bar_image.dart` | ✅ Complete - has pulse animation, hero support |
| AnimatedCard with tap feedback | `animated_card.dart` | ✅ Complete - scale animation, gradient, active glow |
| Page transitions (fade+slide) | `app_page_transitions.dart` | ✅ Complete - 300ms, easeOutCubic |
| `.cursorrules` design guidelines | `app/.cursorrules` | ✅ Complete - comprehensive design system docs |

### ❌ Not Yet Implemented (UI Components)

| Component | File | Gap |
|-----------|------|-----|
| BarListItem | `bar_list_item.dart` | Uses basic Card with 12px radius, no circular image, no gradient, no staggered animation |
| BarDetail | `bar_detail.dart` | Uses basic containers with 12px radius, no hero image, no curved header |
| Bar list staggered animation | `bar_list.dart` | No stagger delay on list items |
| Reduce-motion accessibility | All animated widgets | No check for `MediaQuery.accessibilityFeatures.reduceMotion` |
| Responsive image sizing | `circular_bar_image.dart` | Fixed `radius` prop, no responsive sizing |

---

## Implementation Phases

### Phase 1: Typography Update (FR-013) — Low Risk

**Goal**: Replace DM Sans with Plus Jakarta Sans for body text as specified in clarifications.

**Files Modified**:
- `lib/presentation/core/theme/app_typography.dart`
- `pubspec.yaml` (already has google_fonts, no change needed)

**Changes**:
```dart
// Before
static TextStyle get bodyFont => GoogleFonts.dmSans();
// After  
static TextStyle get bodyFont => GoogleFonts.plusJakartaSans();
```

Update all `GoogleFonts.dmSans()` calls to `GoogleFonts.plusJakartaSans()`.

**Validation**: App renders without font fallback warnings.

---

### Phase 2: BarListItem Redesign (FR-003, FR-004, FR-005, FR-006, FR-010) — Medium Risk

**Goal**: Transform BarListItem from basic Card to the design system spec.

**File Modified**: `lib/presentation/bars/bar_list/bar_list_item.dart`

**Structural Changes**:

```
Current Layout:
┌─────────────────────────────────────────────────┐
│ BAR NAME                           🔴 LIVE      │
│ 📍 123 Street Address                           │
│ 🍺 990 kr  🍷 1200 kr  ● 2FOR1                  │
│ ⏰ Mon–Fri • 16:00–19:00      🚶 500m           │
└─────────────────────────────────────────────────┘

Target Layout:
┌─────────────────────────────────────────────────┐
│                                                 │
│   ⬤ Image    BAR NAME              🔴 LIVE     │
│   (circle)   📍 123 Street Address              │
│              ─────────────────────────────────  │
│              🍺 990 kr   🍷 1200 kr   ● 2FOR1   │
│              ⏰ Mon–Fri • 16:00–19:00           │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Implementation Steps**:

1. **Replace Card with AnimatedCard**:
   ```dart
   AnimatedCard(
     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
     isActive: isActive,
     onTap: onTap,
     child: /* content */,
   )
   ```

2. **Add CircularBarImage on left side**:
   ```dart
   Row(
     children: [
       CircularBarImage(
         imageUrl: bar.imageUrl,
         radius: _getResponsiveRadius(context), // 28-36 based on screen
         isHappyHourActive: isActive,
         heroTag: 'bar-image-${bar.id}',
       ),
       const SizedBox(width: 16),
       Expanded(child: /* bar info column */),
     ],
   )
   ```

3. **Convert price chips to stadium shape**:
   ```dart
   Container(
     decoration: BoxDecoration(
       color: backgroundColor,
       borderRadius: BorderRadius.circular(999), // Stadium
     ),
   )
   ```

4. **Add staggered animation support** (prop for index):
   ```dart
   class BarListItem extends StatefulWidget {
     final int index; // For stagger delay
     // ...
   }
   ```

**Responsive Image Sizing (FR-015)**:
```dart
double _getResponsiveRadius(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  // 56-72px diameter = 28-36 radius
  return (width * 0.08).clamp(28.0, 36.0);
}
```

---

### Phase 3: Staggered List Animation (FR-008) — Low Risk

**Goal**: Add staggered fade-in animation to bar list items.

**Files Modified**:
- `lib/presentation/bars/bar_list/bar_list.dart`
- `lib/presentation/bars/bar_list/bar_list_item.dart`

**Implementation**:

1. Pass `index` prop to BarListItem from ListView.builder
2. In BarListItem, use delayed animation:
   ```dart
   Future.delayed(Duration(milliseconds: index * 50), () {
     if (mounted) _fadeController.forward();
   });
   ```

3. Wrap content in FadeTransition + SlideTransition

**Accessibility (FR-014)**: Check reduce-motion before animating:
```dart
final reduceMotion = MediaQuery.accessibilityFeatures.of(context).reduceMotion;
if (reduceMotion) {
  // Skip animation, show immediately
  _fadeController.value = 1.0;
} else {
  Future.delayed(...);
}
```

---

### Phase 4: BarDetail Screen Redesign (FR-003, FR-004, Hero) — Medium Risk

**Goal**: Add circular hero image, curved header, and consistent styling.

**File Modified**: `lib/presentation/bars/bar_detail/bar_detail.dart`

**Changes**:

1. **Add Hero-linked CircularBarImage** in header:
   ```dart
   Positioned(
     bottom: -40,
     left: 24,
     child: CircularBarImage(
       imageUrl: bar.imageUrl,
       radius: _getDetailRadius(context), // 50-70 responsive
       isHappyHourActive: isActive,
       heroTag: 'bar-image-${bar.id}',
     ),
   )
   ```

2. **Update container radii** from 12px to 24px:
   ```dart
   borderRadius: BorderRadius.circular(24), // All cards
   ```

3. **Use gradient backgrounds** for info sections:
   ```dart
   decoration: BoxDecoration(
     gradient: AppColors.cardGradient,
     borderRadius: BorderRadius.circular(24),
   )
   ```

4. **Add curved header clip** (optional, lower priority):
   ```dart
   ClipPath(
     clipper: CurvedBottomClipper(),
     child: /* map/image header */,
   )
   ```

**Responsive Image Sizing (FR-015)**:
```dart
double _getDetailRadius(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  // 100-140px diameter = 50-70 radius
  return (width * 0.15).clamp(50.0, 70.0);
}
```

---

### Phase 5: Reduce-Motion Accessibility (FR-014) — Low Risk

**Goal**: Respect system accessibility settings for animations.

**Files Modified**:
- `lib/presentation/core/widgets/circular_bar_image.dart`
- `lib/presentation/core/widgets/animated_card.dart`
- `lib/presentation/bars/bar_list/bar_list_item.dart`

**Implementation Pattern**:
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _checkReduceMotion();
}

void _checkReduceMotion() {
  final reduceMotion = MediaQuery.accessibilityFeatures.of(context).reduceMotion;
  if (reduceMotion && _pulseController.isAnimating) {
    _pulseController.stop();
    _pulseController.reset();
  }
}
```

For `CircularBarImage`:
- When `reduceMotion` is true: Show static glow (no pulse), skip stagger delays
- Active state still visually distinct (border + static glow intensity)

For `AnimatedCard`:
- When `reduceMotion` is true: Disable scale feedback, use immediate state changes

---

### Phase 6: Consolidate .cursorrules (FR-012) — Low Risk

**Goal**: Ensure `.cursorrules` at `app/` root is under 350 lines and comprehensive.

**Current State**: `app/.cursorrules` exists with 316 lines — ✅ already compliant

**Updates Needed**:
1. Update typography section to reference Plus Jakarta Sans (not DM Sans)
2. Add reduce-motion accessibility section
3. Add responsive image sizing guidelines

---

## File Modification Summary

| File | Phase | Changes |
|------|-------|---------|
| `lib/presentation/core/theme/app_typography.dart` | 1 | Replace DM Sans → Plus Jakarta Sans |
| `lib/presentation/bars/bar_list/bar_list_item.dart` | 2, 3 | Complete rewrite with AnimatedCard, CircularBarImage, stagger |
| `lib/presentation/bars/bar_list/bar_list.dart` | 3 | Pass index prop to BarListItem |
| `lib/presentation/bars/bar_detail/bar_detail.dart` | 4 | Add hero image, update radii, gradients |
| `lib/presentation/core/widgets/circular_bar_image.dart` | 5 | Add reduce-motion check |
| `lib/presentation/core/widgets/animated_card.dart` | 5 | Add reduce-motion check |
| `app/.cursorrules` | 6 | Minor updates for Plus Jakarta Sans, accessibility |

---

## Dependencies & Prerequisites

### Already Available
- ✅ `google_fonts: ^6.3.3` (supports Plus Jakarta Sans)
- ✅ `cached_network_image: ^3.4.1` (used by CircularBarImage)
- ✅ Image caching service from feature 003

### No New Dependencies Required

---

## Testing Strategy

### Manual Testing Checklist

1. **Color Palette (SC-001)**:
   - [ ] No amber/gold colors anywhere in app
   - [ ] All backgrounds use 0xFF0D0D0D–0xFF1A1A1A range
   - [ ] Red accents for primary actions

2. **Circular Images (SC-002)**:
   - [ ] List items show circular images (56-72px diameter range)
   - [ ] Detail screen shows larger circular images (100-140px range)
   - [ ] Images scale appropriately on different screen sizes

3. **Card Styling (SC-003)**:
   - [ ] All cards have 24px+ border radius
   - [ ] Gradient backgrounds visible on cards
   - [ ] Price chips use stadium/pill shape

4. **Animations (SC-005)**:
   - [ ] Page transitions complete in ~300ms
   - [ ] Staggered list animation on initial load
   - [ ] Tap feedback on interactive elements
   - [ ] Happy hour pulse animation on active bars

5. **Accessibility (FR-014)**:
   - [ ] Enable reduce-motion in device settings
   - [ ] Verify no pulsing/staggered animations
   - [ ] Verify active states still visually distinct

6. **Contrast (SC-004)**:
   - [ ] Run accessibility scanner
   - [ ] All text meets WCAG AA 4.5:1

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Font loading failure | Low | Medium | Plus Jakarta Sans has fallback in GoogleFonts; spec requires system font fallback |
| Animation jank | Medium | Low | Use hardware-accelerated animations only; test on low-end device |
| Breaking existing tests | Low | Low | Widget tests exist but are minimal; update selectors if needed |
| Inconsistent styling | Medium | Medium | Use design tokens (AppColors, AppTypography) everywhere, avoid hardcoded values |

---

## Estimated Effort

| Phase | Estimated Time | Complexity |
|-------|---------------|------------|
| Phase 1: Typography | 15 min | Low |
| Phase 2: BarListItem | 1-2 hours | Medium |
| Phase 3: Staggered Animation | 30 min | Low |
| Phase 4: BarDetail | 1-2 hours | Medium |
| Phase 5: Reduce-Motion | 30 min | Low |
| Phase 6: .cursorrules | 15 min | Low |

**Total**: ~4-6 hours

---

## Rollout Strategy

1. Implement all phases on feature branch
2. Manual QA on Android emulator + physical device
3. Accessibility testing with TalkBack/reduce-motion
4. Merge to main

---

## Success Criteria Mapping

| Success Criteria | Implementation Phase |
|-----------------|---------------------|
| SC-001: No amber/gold colors | Already complete in design tokens |
| SC-002: Circular images with responsive sizing | Phase 2, 4 |
| SC-003: 24px+ card radii | Phase 2, 4 |
| SC-004: WCAG AA contrast | Verify with accessibility tools |
| SC-005: 60fps transitions | Phase 3, use existing infrastructure |
| SC-006: .cursorrules < 350 lines | Phase 6 (already 316 lines) |
| SC-007: Premium perception | Visual QA after all phases |
