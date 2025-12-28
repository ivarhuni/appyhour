# Feature Specification: Flutter Mobile App for Happy Hour Discovery

**Feature Branch**: `002-flutter-mobile-app`  
**Created**: 2024-12-28  
**Status**: Draft  
**Input**: User description: "Flutter mobile application that consumes published bar JSON data and displays happy hour information to users with Clean Architecture, Cubit state management, and two screens: Bars List with filtering/sorting and Bar Detail view"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse All Bars (Priority: P1)

As a user looking for happy hour deals, I want to see a list of all available bars so that I can explore my options.

**Why this priority**: This is the core entry point to the app. Without the ability to browse bars, no other features provide value. Users must be able to see the bar list to accomplish anything.

**Independent Test**: Can be fully tested by launching the app and verifying that all bars from the JSON data source appear in a scrollable list. Delivers immediate value by showing available options.

**Acceptance Scenarios**:

1. **Given** the app is launched with valid bar data available, **When** the Bars List screen loads, **Then** all bars from the data source are displayed in a scrollable list
2. **Given** the app is launched, **When** the Bars List screen loads, **Then** each bar entry shows the bar name, street address, and cheapest beer price
3. **Given** the app is launched, **When** the data source contains no bars, **Then** an appropriate empty state message is displayed

---

### User Story 2 - View Bar Details (Priority: P1)

As a user who found an interesting bar, I want to see complete details about that bar so that I can decide if I want to visit.

**Why this priority**: Viewing details is the natural next step after browsing. Users need full information to make visiting decisions, making this equally critical to browsing.

**Independent Test**: Can be tested by selecting any bar from the list and verifying all detail fields are displayed correctly. Delivers value by providing complete information for decision-making.

**Acceptance Scenarios**:

1. **Given** I am viewing the Bars List, **When** I tap on a bar entry, **Then** the Bar Detail screen opens showing that bar's information
2. **Given** I am viewing Bar Detail, **When** the screen loads, **Then** I see the bar name, street address, and location on a map
3. **Given** I am viewing Bar Detail, **When** the screen loads, **Then** I see happy hour days and times clearly displayed
4. **Given** I am viewing Bar Detail, **When** the screen loads, **Then** I see beer price, wine price, and two-for-one availability
5. **Given** I am viewing Bar Detail, **When** the screen loads, **Then** I see any notes or description about the bar
6. **Given** I am viewing Bar Detail, **When** I want to return to the list, **Then** I can navigate back to the Bars List screen

---

### User Story 3 - Filter Bars by Active Happy Hour (Priority: P2)

As a user looking for a deal right now, I want to filter the list to only show bars with currently active happy hours so that I don't waste time on closed deals.

**Why this priority**: Time-based filtering is a key differentiator for happy hour apps. However, users can still browse and find active happy hours manually without this filter, making it secondary to basic browsing.

**Independent Test**: Can be tested by setting device time to a known happy hour period, enabling the ONGOING filter, and verifying only bars with matching happy hour times appear.

**Acceptance Scenarios**:

1. **Given** I am viewing the Bars List, **When** I select the "Show ONGOING" filter, **Then** only bars with active happy hours at the current time are displayed
2. **Given** I have the ONGOING filter active, **When** I select "Show ALL", **Then** all bars are displayed regardless of current time
3. **Given** I have the ONGOING filter active, **When** no bars have active happy hours, **Then** an appropriate message indicates no current happy hours are available
4. **Given** the current time is within a bar's happy hour window, **When** I enable the ONGOING filter, **Then** that bar appears in the filtered list

---

### User Story 4 - Sort Bars by Beer Price (Priority: P2)

As a budget-conscious user, I want to sort bars by the cheapest beer price so that I can find the best deals quickly.

**Why this priority**: Price is a primary factor for happy hour seekers. Sorting by price directly addresses the app's value proposition of finding deals.

**Independent Test**: Can be tested by enabling price sort and verifying the list order matches ascending beer prices from the data source.

**Acceptance Scenarios**:

1. **Given** I am viewing the Bars List, **When** I select "Sort by Beer Price", **Then** bars are ordered by cheapest_beer_price from lowest to highest
2. **Given** I have sorted by beer price, **When** I view the list, **Then** I can clearly see the price for each bar in the list entry
3. **Given** multiple bars have the same beer price, **When** I sort by beer price, **Then** those bars maintain a consistent secondary order (alphabetically by name)

---

### User Story 5 - Sort Bars by Location (Priority: P3)

As a user who wants convenience, I want to sort bars by distance from my current location so that I can find nearby options.

**Why this priority**: Location sorting requires device permissions and location services, adding complexity. Users can still manually identify nearby bars from addresses, making this a convenience feature.

**Independent Test**: Can be tested by enabling location sort with a known device location and verifying the list order matches calculated distances.

**Acceptance Scenarios**:

1. **Given** I am viewing the Bars List and location access is granted, **When** I select "Sort by Location", **Then** bars are ordered by distance from my current location (nearest first)
2. **Given** I select "Sort by Location", **When** location access has not been granted, **Then** the app prompts me to enable location permissions
3. **Given** I decline location permissions, **When** I attempt to sort by location, **Then** an appropriate message explains that location access is required for this feature
4. **Given** location access is granted, **When** I sort by location, **Then** the distance to each bar is displayed in the list entry

---

### User Story 6 - Sort Bars by Rating (Priority: P3)

As a user seeking quality experiences, I want to sort bars by user rating so that I can find highly-rated establishments.

**Why this priority**: Rating sort depends on rating data availability. The bar data may not always include ratings, making this a lower priority feature that enhances but doesn't define the core experience.

**Independent Test**: Can be tested by enabling rating sort and verifying the list order matches rating values from the data source.

**Acceptance Scenarios**:

1. **Given** I am viewing the Bars List and rating data is available, **When** I select "Sort by Rating", **Then** bars are ordered by rating from highest to lowest
2. **Given** some bars do not have ratings, **When** I sort by rating, **Then** unrated bars appear at the end of the sorted list
3. **Given** all bars lack rating data, **When** I attempt to sort by rating, **Then** an appropriate message indicates ratings are not available

---

### Edge Cases

- What happens when the app cannot reach the data source (network error)?
  - Display empty bar list with error banner at top and a retry button; list remains interactive for pull-to-refresh
- What happens when bar data is malformed or incomplete?
  - Display available data and gracefully handle missing fields with appropriate defaults or "Not available" indicators
- What happens when the user's location cannot be determined?
  - Location-based sorting becomes unavailable; other sort options remain functional
- What happens when happy hour times span midnight (e.g., 10 PM - 2 AM)?
  - Correctly identify the happy hour as active during the overnight period
- What happens when a bar has no happy hour times defined?
  - Bar appears in "Show ALL" but not in "Show ONGOING" filter; Bar Detail clearly indicates no happy hour schedule

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a scrollable list of all bars retrieved from the published JSON data source
- **FR-002**: System MUST display each bar's name, street address, and cheapest beer price in the list view
- **FR-003**: Users MUST be able to tap a bar entry to navigate to that bar's detail view
- **FR-004**: System MUST display complete bar information on the detail screen: name, address, map location, happy hour days/times, beer price, wine price, two-for-one availability, and notes/description
- **FR-005**: System MUST display the bar's location on an interactive map in the detail view
- **FR-006**: Users MUST be able to filter the bar list to show only bars with currently active happy hours ("Show ONGOING")
- **FR-007**: Users MUST be able to remove the active happy hour filter to see all bars ("Show ALL")
- **FR-008**: System MUST correctly determine if a bar's happy hour is currently active based on the device's current time and the bar's happy_hour_times data
- **FR-009**: Users MUST be able to sort the bar list by cheapest beer price (ascending)
- **FR-010**: Users MUST be able to sort the bar list by distance from current location (nearest first)
- **FR-011**: Users MUST be able to sort the bar list by user rating (highest first), when rating data is available
- **FR-012**: System MUST request location permissions before enabling location-based sorting
- **FR-013**: System MUST handle missing or unavailable data gracefully with appropriate user feedback
- **FR-014**: Users MUST be able to navigate back from the detail screen to the list screen
- **FR-015**: System MUST display appropriate empty states when no bars match current filters
- **FR-016**: System MUST fetch bar data from the server on each app launch
- **FR-017**: Users MUST be able to manually refresh the bar list via pull-to-refresh gesture
- **FR-018**: System MUST display bars in JSON data source order by default, allowing server-side control of initial display order

### Key Entities

- **Bar**: Represents a drinking establishment with happy hour offerings. Key attributes: name, street address, location coordinates, happy hour schedule (days and times), beer price, wine price, two-for-one availability, notes/description, and optional user rating.
- **Happy Hour Schedule**: Defines when a bar's happy hour is active. Includes days of the week and time windows. May span multiple time periods and handle overnight hours.
- **Filter State**: Represents the current filtering mode (ONGOING or ALL) that controls which bars are visible.
- **Sort Preference**: Represents the user's current sort selection (Rating, Location, or Beer Price).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can view the complete bar list within 3 seconds of app launch on a standard mobile network connection
- **SC-002**: Users can navigate from the bar list to any bar's detail view in under 1 second
- **SC-003**: The ONGOING filter correctly identifies 100% of bars with active happy hours based on current device time
- **SC-004**: All sorting operations complete and display results within 500 milliseconds
- **SC-005**: Users can complete the primary task flow (launch app → browse bars → view bar details) without errors or confusion
- **SC-006**: App gracefully handles offline/error states, displaying meaningful feedback in 100% of failure scenarios
- **SC-007**: Location-based sorting provides distance-ordered results when device location is available and permissions are granted
- **SC-008**: Users with no prior app experience can find a bar with an active happy hour within 30 seconds

## Clarifications

### Session 2024-12-28

- Q: When should the app fetch fresh bar data from the server? → A: Fetch on each app launch with pull-to-refresh available; no caching layer needed.
- Q: What should be the default sort order when the bar list first loads? → A: Display in JSON data source order (server-controlled).
- Q: When the app launches and cannot fetch bar data, what should users see? → A: Show empty list with error banner at top and retry button.

## Assumptions

- Bar JSON data is already published and available at a known URL (from the existing webservice project)
- Bar data includes all required fields: name, street address, location coordinates, happy hour schedule, beer price, wine price, two-for-one indicator, and notes
- The app will target both iOS and Android platforms using Flutter
- Users have standard mobile devices with GPS/location capabilities
- Rating data may or may not be available in the bar JSON; the app should handle its absence gracefully
- The app operates in a single locale/timezone context (Iceland, based on existing data)
- No user authentication or personalization is required for the initial version
- Map display uses the platform's native mapping capabilities
- App requires network connectivity; no offline caching layer is needed

