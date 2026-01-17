# Feature Specification: Grapevine UI Theme

**Feature Branch**: `005-grapevine-ui-theme`  
**Created**: 2025-01-17  
**Status**: Clarified  
**Input**: User description: "Create a Grapevine-branded UI theme variant for the Appy Hour app that aligns with the Reykjavik Grapevine website design, enabling dual UI support"

## Overview

Transform the Happy Hour app into "Appy Hour" – a Grapevine-branded version that reflects the editorial, sophisticated aesthetic of The Reykjavik Grapevine (grapevine.is). The app must support both the original UI and the new Grapevine-branded UI through a configurable switching mechanism.

### Design Direction

The Grapevine UI draws inspiration from the magazine's website with these key characteristics:

**Color Palette** (derived from grapevine.is):
- **Background**: Deep charcoal/near-black (#1A1A1A to #2D2D2D)
- **Primary Accent**: Teal/Cyan (#0D9488) – used for highlights, sidebar elements
- **Secondary Accent**: Orange/Coral (#E64A19) – used for links, dates, interactive elements
- **Text Primary**: White (#FFFFFF) for main content
- **Text Secondary**: Gray (#999999) for metadata and secondary information

**Typography**:
- **Editorial/Magazine style** with distinctive serif headlines
- Bold, condensed header fonts reflecting the Grapevine logo aesthetic
- Clean, readable body text

**Visual Character**:
- Magazine/editorial layout sensibility
- Strong photography integration
- Sophisticated, cultured feel befitting Iceland's leading English-language publication
- The Reykjavik Grapevine logo prominently displayed

## Clarified Decisions

The following decisions were clarified through stakeholder discussion:

| Area | Decision | Details |
|------|----------|---------|
| **Theme Switching** | Compile-time constant | A constant in `main.dart` determines the active theme; requires rebuild to switch |
| **Logo Asset** | Downloaded from grapevine.is | SVG logo obtained from website, stored at `assets/images/grapevine_logo.svg` |
| **App Name Scope** | Display name only | UI title changes to "Appy Hour" but same app bundle/package ID |
| **UI Architecture** | Hybrid approach | Shared core logic with theme-specific widget variations where beneficial |

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Bars with Grapevine Branding (Priority: P1)

A user opens the Appy Hour app and sees the familiar happy hour bar listings presented with the distinctive Grapevine visual identity – teal accents, orange highlights, and the Grapevine logo in the header.

**Why this priority**: The bar listing is the primary screen users interact with. The Grapevine branding must be immediately visible and create a cohesive branded experience from the first moment.

**Independent Test**: Can be fully tested by opening the app configured with Grapevine theme and viewing the bar list – delivers the core branded experience.

**Acceptance Scenarios**:

1. **Given** the app is configured for Grapevine UI, **When** the user opens the app, **Then** they see the bar list with Grapevine colors (teal/orange accents on dark background), the Grapevine logo in the header, and typography reflecting the editorial style.

2. **Given** the app is configured for Grapevine UI, **When** the user views bar cards, **Then** the cards display with the Grapevine color scheme and distinctive styling that feels like browsing a Grapevine article.

3. **Given** the app is configured for Grapevine UI, **When** the user scrolls through bars, **Then** animations and transitions feel refined and editorial, not generic.

---

### User Story 2 - View Bar Details with Grapevine Styling (Priority: P2)

A user taps on a bar to view its details and sees the detail page styled consistently with the Grapevine brand aesthetic.

**Why this priority**: Detail pages are the second most-viewed screen and must maintain brand consistency.

**Independent Test**: Can be tested by navigating to any bar detail page and verifying the Grapevine styling is applied consistently.

**Acceptance Scenarios**:

1. **Given** the app is in Grapevine mode, **When** the user views a bar's details, **Then** the detail page uses Grapevine colors, typography, and maintains the editorial aesthetic.

2. **Given** the app is in Grapevine mode, **When** happy hour times are displayed, **Then** the active/inactive states use the Grapevine color scheme (teal for active, appropriate secondary colors for inactive).

---

### User Story 3 - Switch Between UI Themes (Priority: P3)

A developer can configure which UI theme the app uses by changing a compile-time constant in `main.dart`, enabling easy switching between the original "Happy Hour" UI and the "Appy Hour" Grapevine-branded UI.

**Why this priority**: This enables the dual UI support requirement, allowing the app to serve both branded and generic markets.

**Independent Test**: Can be tested by changing the configuration constant and rebuilding the app.

**Acceptance Scenarios**:

1. **Given** the theme constant is set to "grapevine", **When** the app is built and launched, **Then** all screens render with the Grapevine UI styling.

2. **Given** the theme constant is set to "default", **When** the app is built and launched, **Then** all screens render with the original dark red UI styling.

3. **Given** a developer changes the theme constant, **When** the app is rebuilt, **Then** the new theme is applied throughout the app.

---

### User Story 4 - See Grapevine Logo (Priority: P2)

Users see The Reykjavik Grapevine logo displayed prominently in the app, reinforcing the brand partnership.

**Why this priority**: Logo visibility is essential for brand recognition and must be tastefully integrated.

**Independent Test**: Can be tested by verifying logo presence and appropriate sizing/placement in the header area.

**Acceptance Scenarios**:

1. **Given** the Grapevine UI is active, **When** the user is on the bar list screen, **Then** the Grapevine logo is visible in the header area.

2. **Given** the Grapevine UI is active, **When** the logo is displayed, **Then** it maintains proper aspect ratio and legibility at various screen sizes.

---

### Edge Cases

- What happens when the theme constant value is invalid or missing? (Default to original theme)
- How does the app handle logo loading failures? (Graceful fallback to text "Appy Hour" in branded font)
- What happens with cached images when switching themes? (Image caching is theme-agnostic; no impact)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support at least two distinct UI themes: "default" (original dark red) and "grapevine" (teal/orange editorial style)

- **FR-002**: System MUST provide a compile-time constant in `main.dart` to select the active UI theme

- **FR-003**: The Grapevine theme MUST apply consistent styling across all screens (bar list, bar detail, filters, error states)

- **FR-004**: The Grapevine theme MUST display The Reykjavik Grapevine logo (from `assets/images/grapevine_logo.svg`) in a prominent, appropriate location

- **FR-005**: The Grapevine theme MUST use the Grapevine color palette:
  - Primary accent: Teal (#0D9488 or similar)
  - Secondary accent: Orange/Coral (#E64A19 or similar)
  - Background: Dark charcoal (#1A1A1A to #2D2D2D)
  - Text: White primary, gray secondary

- **FR-006**: The Grapevine theme MUST use distinctive typography that reflects the editorial/magazine aesthetic (not generic system fonts)

- **FR-007**: System MUST maintain existing functionality (filtering, sorting, navigation, localization) regardless of active theme

- **FR-008**: The theme selection MUST NOT affect app performance or introduce visible loading delays

- **FR-009**: System MUST fall back to the default theme if the theme constant value is invalid or unrecognized

- **FR-010**: The Grapevine theme MUST display "Appy Hour" as the app title in the UI (same app bundle/package ID)

- **FR-011**: Shared core logic (Cubits, repositories, domain models) MUST remain unchanged; only presentation layer widgets may have theme-specific variations

### Non-Functional Requirements

- **NFR-001**: Theme switching mechanism should support future additional themes with minimal code changes

- **NFR-002**: Theme-specific assets (logo, fonts) must be bundled efficiently without significantly increasing app size

- **NFR-003**: Hybrid UI architecture should minimize code duplication while allowing visual distinctiveness

### Key Entities

- **UITheme**: Represents a complete visual theme including colors, typography, logo path, and app display name. Identified by a string key (e.g., "default", "grapevine").

- **AppBrand**: Compile-time constant that determines which UITheme is active for the build.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can identify the app as Grapevine-branded within 2 seconds of opening (logo visible, distinctive colors apparent)

- **SC-002**: 100% of app screens render consistently in the selected theme with no visual artifacts or style bleeding

- **SC-003**: Theme switching requires changing only one compile-time constant (no multi-file edits for theme change)

- **SC-004**: App launch time remains within 10% of baseline when using either theme

- **SC-005**: The Grapevine theme visually aligns with grapevine.is website aesthetic (verified by visual comparison)

- **SC-006**: All existing functionality (filtering, sorting, bar details, maps, localization) works identically in both themes

- **SC-007**: Core business logic (Cubits, repositories) has zero theme-specific code

## Assumptions

- The Grapevine logo has been downloaded from grapevine.is and stored at `assets/images/grapevine_logo.svg`
- The design-skill.cursorrules guidelines will be followed for creating distinctive, non-generic aesthetics
- Custom fonts may be used to achieve the editorial typography style (e.g., serif display fonts)
- The dual UI architecture follows Flutter's theming best practices (ThemeData, color schemes)
- A compile-time constant in `main.dart` is the switching mechanism
- The app bundle ID and package name remain unchanged between themes
