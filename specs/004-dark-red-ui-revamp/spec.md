# Feature Specification: Dark Red UI Revamp

**Feature Branch**: `004-dark-red-ui-revamp`  
**Created**: 2024-12-29  
**Status**: Draft  
**Input**: User description: "Revamp UI with dark/red color scheme, circular images, fluid design, and custom prompt file"

## Overview

Transform the HappyHour app from its current amber/gold "boxy" design to a moody, sophisticated dark theme with red accents that evokes late-night cocktail bar aesthetics. The current design feels too "computed" and rigid - the new design should feel organic, flowing, and visually captivating with circular imagery and smooth animations.

**Current State**: The app has documented design guidelines in `.cursorrules` files but the actual implementation still uses the old amber/gold color scheme with rectangular components.

**Target State**: Fully implemented dark/red theme with circular images, gradient cards, subtle glows, and refined micro-interactions.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browsing Bars in Dark Mode (Priority: P1)

As a user browsing bars in the evening, I want the app to have a dark, visually comfortable interface with red accents so that it feels appropriate for late-night bar discovery and reduces eye strain.

**Why this priority**: The dark theme is the foundational visual change that affects every screen - all other UI improvements build on this.

**Independent Test**: Launch the app and navigate through bar list and detail screens - all backgrounds should be near-black with red accent colors, and no amber/gold colors should appear.

**Acceptance Scenarios**:

1. **Given** I am on the bar list screen, **When** I view the app, **Then** I see a dark near-black background with red accent colors for highlights and active states
2. **Given** I am on a bar detail screen, **When** I view active happy hour status, **Then** the indicator uses deep red with a subtle glow effect
3. **Given** any screen in the app, **When** I view text content, **Then** text contrast meets accessibility standards (WCAG AA 4.5:1 minimum)

---

### User Story 2 - Viewing Bar Cards with Circular Images (Priority: P2)

As a user scrolling through bars, I want to see circular bar images with subtle glow effects so that the list feels less "boxy" and more visually engaging.

**Why this priority**: Circular images are the most visible shape change that breaks the rectangular monotony and adds visual interest.

**Independent Test**: Open the bar list and verify each bar card displays a circular image placeholder/avatar with a subtle red glow when happy hour is active.

**Acceptance Scenarios**:

1. **Given** I am viewing the bar list, **When** I look at a bar card, **Then** I see a circular image element on the left side of the card
2. **Given** a bar is currently in happy hour, **When** I view its card, **Then** the circular image has a pulsing or glowing red border
3. **Given** I tap on a bar card, **When** I navigate to details, **Then** the circular image animates smoothly (Hero transition) to the detail screen

---

### User Story 3 - Experiencing Fluid Card Designs (Priority: P2)

As a user browsing bars, I want cards to have rounded corners, gradient backgrounds, and organic shapes so that the interface feels premium and modern rather than rigid.

**Why this priority**: Card styling transforms the overall feel of the app from "computed" to "designed".

**Independent Test**: View bar list and detail screens - cards should have large rounded corners (24px+), gradient backgrounds, and occasional asymmetric corner radii.

**Acceptance Scenarios**:

1. **Given** I am viewing bar cards, **When** I look at their shape, **Then** they have large rounded corners (24px or more) instead of small 12px corners
2. **Given** I am viewing cards, **When** I observe their background, **Then** I see subtle gradient fills (dark to slightly darker with red undertone)
3. **Given** I am viewing price chips, **When** I look at their shape, **Then** they use pill/stadium shapes (fully rounded ends)

---

### User Story 4 - Smooth Animations and Transitions (Priority: P3)

As a user navigating the app, I want smooth page transitions, staggered list animations, and subtle tap feedback so that the app feels polished and responsive.

**Why this priority**: Animations enhance perceived quality but the app is functional without them - this is polish on top of the visual redesign.

**Independent Test**: Navigate between screens and interact with list items - transitions should combine fade+slide, list items should appear with staggered animation, taps should have subtle scale feedback.

**Acceptance Scenarios**:

1. **Given** I tap on a bar card, **When** the detail screen opens, **Then** the transition uses a combined fade+slide animation over ~300ms
2. **Given** the bar list loads, **When** items appear, **Then** they fade in with a staggered delay (each item slightly after the previous)
3. **Given** I tap on any interactive element, **When** my finger presses down, **Then** the element scales slightly inward providing tactile feedback

---

### User Story 5 - Reusable UI Design Prompt File (Priority: P1)

As a developer working on the app, I want a single consolidated `.cursorrules` file at the app root that defines the complete UI design system so that any future UI work follows consistent guidelines without manual specification.

**Why this priority**: This enables consistent future development and is a prerequisite for maintaining the design system long-term.

**Independent Test**: Verify the `.cursorrules` file exists at `app/.cursorrules`, contains complete color palette, typography, shape language, and animation guidelines, and is properly formatted for Cursor AI consumption.

**Acceptance Scenarios**:

1. **Given** I open Cursor in the `app/` directory, **When** Cursor loads, **Then** it should pick up the UI design guidelines from `.cursorrules`
2. **Given** I ask Cursor to modify any UI component, **When** Cursor generates code, **Then** it follows the dark/red color scheme and design patterns
3. **Given** the `.cursorrules` file, **When** I review its contents, **Then** it includes: color palette, typography choices, shape guidelines, animation patterns, and anti-patterns to avoid

---

### Edge Cases

- What happens when bar images fail to load? → Display a styled placeholder maintaining the circular shape
- How does the app handle users who prefer light mode? → For MVP, enforce dark theme only; light theme support is out of scope
- What happens on low-performance devices? → Animations should use hardware acceleration and gracefully degrade

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: App MUST use the dark color palette with near-black backgrounds (0xFF0D0D0D to 0xFF1A1A1A range)
- **FR-002**: App MUST use red accent colors for primary actions and active states (0xFFC62828 to 0xFFE53935 range)
- **FR-003**: Bar list item images MUST be circular with subtle box shadow/glow effects
- **FR-004**: Cards MUST have rounded corners of at least 24 pixels radius
- **FR-005**: Cards SHOULD use gradient backgrounds (surface to surface-variant)
- **FR-006**: Filter chips and price tags MUST use pill/stadium shapes (fully rounded ends)
- **FR-007**: Page transitions MUST use combined fade and slide animations
- **FR-008**: List items SHOULD animate in with staggered delays on initial load
- **FR-009**: Interactive elements SHOULD provide subtle scale feedback on tap
- **FR-010**: Active happy hour indicators MUST use a pulsing glow animation
- **FR-011**: App MUST maintain WCAG AA contrast ratios (4.5:1 for normal text, 3:1 for large text)
- **FR-012**: A consolidated `.cursorrules` file MUST exist at `app/.cursorrules` with complete design system documentation
- **FR-013**: Typography MUST use custom fonts appropriate for a bar/cocktail aesthetic (display fonts for headlines, sans-serif for body)

### Key Entities

- **AppColors**: Centralized color constants defining the complete palette (background, surface, primary, secondary, text, semantic colors)
- **AppTheme**: Theme configuration implementing Material 3 with custom color scheme, typography, and component themes
- **BarListItem**: Card component displaying bar summary with circular image, gradient background, and pill-shaped chips
- **BarDetail**: Detail screen with curved header, hero image transition, and organized information sections

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of screens use the dark color palette - no amber/gold colors remain in production code
- **SC-002**: All bar images display as circles with consistent sizing (64px diameter in list, 120px in detail)
- **SC-003**: Card corner radii are 24px or larger throughout the app
- **SC-004**: All text meets WCAG AA contrast requirements when tested with accessibility tools
- **SC-005**: Page transitions complete within 300-400ms with no jank (60fps)
- **SC-006**: The `.cursorrules` file is under 350 lines while remaining comprehensive
- **SC-007**: Users perceive the app as "premium" or "sophisticated" in qualitative feedback (target: app no longer described as "boxy" or "computed")

## Assumptions

- Google Fonts package is available and acceptable for custom typography
- No light mode theme is required for this phase
- Bar image URLs will be available from the API (placeholder handling needed for missing images)
- Performance optimizations (image caching) were completed in feature 003 and are available

## Out of Scope

- Light mode theme support
- Custom illustrations or iconography beyond Material Icons
- Complex parallax or 3D effects
- Bar image upload or management features
