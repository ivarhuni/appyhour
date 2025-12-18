# Feature Specification: CSV Validation and Publishing System

**Feature Branch**: `001-csv-pages-automation`  
**Created**: 2025-12-18  
**Status**: Draft  
**Input**: User description: "GitHub-based CSV validation and publishing system for happy hour data. Non-programmers update bars.csv via GitHub web UI, GitHub Actions validate CSV, generate static JSON artifacts, and publish to GitHub Pages with error reporting."

## Clarifications

### Session 2025-12-18

- Q: How should individual bars be identified in the JSON file structure? → A: Each bar should be accessible at `/data/bars/{row_number}.json` where row_number is the CSV row number minus 3 (accounting for header rows and empty rows at the top of the CSV file). This uses row position rather than slug-based naming.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Submit Valid Bar Data (Priority: P1)

A contributor wants to add a new bar's happy hour information to the public dataset. They navigate to the repository on GitHub, edit the bars.csv file using the web interface, add the bar's information in the correct CSV format, commit the changes with a descriptive message, and the system automatically validates and publishes the data to GitHub Pages within minutes.

**Why this priority**: This is the core value proposition - enabling non-technical contributors to successfully add data that becomes immediately available to consumers.

**Independent Test**: Can be fully tested by editing bars.csv with one valid bar entry, committing to main, and verifying the new bar appears in the published JSON files at the expected URLs.

**Acceptance Scenarios**:

1. **Given** bars.csv exists with valid data, **When** a contributor adds a new valid bar entry via GitHub web editor and commits to main, **Then** the GitHub Action runs successfully, generates JSON artifacts including the new bar, and publishes them to GitHub Pages
2. **Given** the build completed successfully, **When** a user visits the published site, **Then** they can access both the aggregate bars.json and individual bar JSON files with the new data
3. **Given** bars.csv has been updated, **When** the automation completes, **Then** the errors page shows zero errors and displays a success message

---

### User Story 2 - Identify and Fix Data Errors (Priority: P1)

A contributor accidentally introduces invalid data (malformed CSV, missing required fields, or duplicate entries) when editing bars.csv. After committing, the GitHub Action fails validation and generates a human-readable error report. The contributor reads the error page which shows the specific line numbers and error descriptions, returns to GitHub to fix the bars.csv file, and commits again. The second run passes validation and publishes the corrected data.

**Why this priority**: Error recovery is essential for non-programmers who need clear guidance to fix issues without technical support.

**Independent Test**: Can be fully tested by committing invalid CSV data, verifying the error page displays specific issues with line numbers, fixing the errors, and confirming the second commit succeeds.

**Acceptance Scenarios**:

1. **Given** bars.csv contains invalid data, **When** a contributor commits the changes, **Then** the GitHub Action fails validation but still publishes the error report to /errors/index.html and /errors/errors.json
2. **Given** the validation failed, **When** the contributor visits the errors page, **Then** they see a human-readable list of errors with specific line numbers and descriptions of what needs to be fixed
3. **Given** the contributor has reviewed the errors, **When** they fix the issues in bars.csv and commit again, **Then** the validation passes and the corrected data is published to GitHub Pages

---

### User Story 3 - Restore Previous Valid Version (Priority: P2)

A contributor realizes that a recent change broke something or removed important data. They use GitHub's file history feature to view previous versions of bars.csv, select a known-good version, restore it by committing the old content, and the system automatically rebuilds and republishes the working dataset.

**Why this priority**: Rollback capability provides safety and confidence for contributors to experiment without fear of permanent damage.

**Independent Test**: Can be fully tested by making a breaking change, using GitHub's history to restore a previous version, and verifying the system republishes the old data successfully.

**Acceptance Scenarios**:

1. **Given** bars.csv has been modified multiple times, **When** a contributor views the file history on GitHub, **Then** they can see previous versions with timestamps and commit messages
2. **Given** a contributor wants to restore old data, **When** they copy content from a previous version and commit it to bars.csv, **Then** the GitHub Action automatically rebuilds and republishes the restored dataset
3. **Given** a previous version has been restored, **When** the build completes, **Then** the published artifacts reflect the restored data state

---

### User Story 4 - Consume Published Data (Priority: P3)

An external application or website wants to display happy hour information. Developers integrate with the published JSON endpoints at https://ivarhuni.github.io/happyhour/data/bars.json (for all bars) or individual bar files at /data/bars/{n}.json where n is a sequential number (1, 2, 3, etc.). The data is always current, reflecting the latest validated changes from contributors.

**Why this priority**: This completes the value chain - data contributors feed consumers, but the core workflow (P1-P2) must work first.

**Independent Test**: Can be fully tested by making a data change, waiting for publication, and fetching the JSON endpoints to verify they return the updated data in the expected format.

**Acceptance Scenarios**:

1. **Given** valid data has been published, **When** a consumer fetches https://ivarhuni.github.io/happyhour/data/bars.json, **Then** they receive a JSON file containing all validated bar records
2. **Given** a specific bar exists in the dataset, **When** a consumer fetches https://ivarhuni.github.io/happyhour/data/bars/{n}.json (where n is the bar's sequential number), **Then** they receive a JSON file with that bar's complete information
3. **Given** a contributor updates bar data, **When** the changes are validated and published, **Then** consumers fetching the JSON endpoints receive the updated data within minutes

---

### Edge Cases

- What happens when a contributor commits an empty bars.csv file?
- What happens when bars.csv contains only headers with no data rows?
- How does the system handle very large CSV files (100+ bars)?
- What happens if two contributors edit bars.csv simultaneously (GitHub's web UI typically prevents this, but concurrent commits via different methods are possible)?
- What happens when the CSV contains non-ASCII characters (international bar names, special characters)?
- How does the system behave if the GitHub Actions runner fails or times out?
- How does the system handle CSV rows with inconsistent column counts (too many or too few fields)?

## Requirements *(mandatory)*

### Functional Requirements

#### Data Input & Access

- **FR-001**: System MUST accept bars.csv file located at `/webservice/bars.csv` as the single source of truth for bar data
- **FR-002**: System MUST support editing bars.csv exclusively through GitHub's web-based editor interface (no command-line tools or external software required)
- **FR-003**: System MUST automatically trigger validation and publishing workflows when changes are committed to the main branch

#### Validation

- **FR-004**: System MUST validate the structure and content of bars.csv before generating any output artifacts
- **FR-005**: System MUST validate CSV format (proper comma separation, consistent column counts, proper escaping of special characters)
- **FR-006**: System MUST enforce that CSV includes a header row with the expected column names: Name of Bar/Restaurant, Best Contact Email, Street, Latitute, Longitute, Happy Hour Days, Happy Hour Times, Price Of Cheapest Beer, Price Of Cheapest Wine, 2F1?, Notes
- **FR-007**: System MUST validate that all required fields are present and non-empty for each bar entry: Name of Bar/Restaurant, Best Contact Email, Street, Latitute, Longitute, Happy Hour Days, Happy Hour Times, Price Of Cheapest Beer, Price Of Cheapest Wine, 2F1?, Notes (coordinates are required)
- **FR-008**: System MUST validate data types and formats for each field: Happy Hour Times must be in "HH:MM - HH:MM" 24-hour format, prices must be non-negative integers (ISK), email must be valid format, coordinates must be valid numbers (lat -90 to 90, lng -180 to 180), 2F1? must be "Yes" or "No"
- **FR-009**: System MUST record the specific line number for each validation error to enable precise error correction

#### Output Generation

- **FR-010**: System MUST generate an aggregate JSON file at /data/bars.json containing all validated bar records
- **FR-011**: System MUST generate individual JSON files at /data/bars/{n}.json for each bar, where n is a sequential number starting from 1
- **FR-012**: System MUST map CSV row numbers to JSON file numbers by subtracting 3 from the row number (row 4 becomes bar 1, row 5 becomes bar 2, etc.) to account for non-data rows at the top of the CSV
- **FR-013**: System MUST generate outputs only when validation passes completely (all-or-nothing publishing)
- **FR-014**: System MUST preserve existing published data if new validation fails (no partial updates)

#### Error Reporting

- **FR-015**: System MUST generate both human-readable (HTML) and machine-readable (JSON) error reports on every workflow run, even when there are zero errors
- **FR-016**: System MUST publish the human-readable error report to /errors/index.html
- **FR-017**: System MUST publish the machine-readable error report to /errors/errors.json
- **FR-018**: Error reports MUST include specific line numbers, error types, and clear descriptions of what needs to be fixed
- **FR-019**: System MUST display a summary of validation results (count of valid rows and count of errors) in the GitHub Actions workflow logs

#### Publishing & Deployment

- **FR-020**: System MUST publish all generated artifacts to GitHub Pages served from the gh-pages branch
- **FR-021**: System MUST make published content accessible at https://ivarhuni.github.io/happyhour/
- **FR-022**: System MUST publish error reports even when validation fails (so contributors can see what to fix)
- **FR-023**: System MUST fail the GitHub Actions workflow when validation errors are present (while still publishing error reports)
- **FR-024**: System MUST support manual workflow triggering via workflow_dispatch in addition to automatic triggers on push to main

#### Versioning & Recovery

- **FR-025**: System MUST support restoration of previous bars.csv versions through GitHub's file history feature
- **FR-026**: System MUST automatically rebuild and republish outputs when any previous version is restored and committed

### Key Entities

- **Bar Record**: Represents a single establishment's happy hour information. Contains: Name of Bar/Restaurant, Best Contact Email, Street address, geographic coordinates (Latitute, Longitute), Happy Hour Days, Happy Hour Times, pricing (Price Of Cheapest Beer, Price Of Cheapest Wine), 2F1? flag, Notes, and optional Description for Featured Happy Hour. Each bar generates one JSON file identified by its sequential number (CSV row number minus 3).

- **Validation Error**: Represents a single issue found during CSV validation. Contains error type (format error, missing field, invalid data type, malformed CSV structure), line number in CSV where error occurred, field name if applicable, and human-readable error message. Errors are collected and published in both HTML and JSON formats.

- **Published Dataset**: Represents the complete validated collection of bar records. Includes an aggregate view (all bars in one file) and individual bar views (one file per bar). Generated fresh on each successful validation, maintaining consistency across all output files.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Contributors without programming experience can successfully add a new bar entry and see it published within 5 minutes of committing
- **SC-002**: When validation errors occur, contributors can identify and fix issues within 10 minutes using only the error report (no external support needed)
- **SC-003**: 95% of valid CSV commits result in successful publication on first attempt
- **SC-004**: Error reports provide sufficient detail that contributors can fix issues without contacting maintainers for clarification
- **SC-005**: System handles CSV files with up to 500 bar records without workflow timeouts or performance degradation
- **SC-006**: Published JSON endpoints return data to consumers within 2 seconds of request
- **SC-007**: Zero data inconsistencies between the aggregate JSON file and individual bar JSON files (they always reflect the same source data)
- **SC-008**: Contributors successfully restore previous data versions using GitHub's file history feature without data loss

## Assumptions

- Contributors have GitHub accounts with write access to the repository
- Contributors have basic familiarity with GitHub's web interface (can navigate to files and use the edit button)
- The repository is public and published via GitHub Pages
- GitHub Actions workflows have sufficient minutes allocation to run on each commit
- CSV files are UTF-8 encoded (standard for GitHub web editor)
- Bar data changes are infrequent enough that concurrent edit conflicts are rare
- Internet connectivity is available for accessing GitHub Pages endpoints
- Required CSV fields are: Name of Bar/Restaurant, Best Contact Email, Street, Latitute, Longitute, Happy Hour Days, Happy Hour Times, Price Of Cheapest Beer, Price Of Cheapest Wine, 2F1?, Notes
- Optional fields include: Description for Featured Happy Hour
- Duplicate bar entries are allowed (no duplicate detection required)
- Time formats follow 24-hour convention (e.g., "15:00 - 17:00") based on existing data
- Price formats are numeric values in ISK (Icelandic Króna) without currency symbols (e.g., "500")
- The "2F1?" field accepts Yes/No values indicating two-for-one deals
- CSV file structure has 3 rows before bar data begins (empty rows and header row), so the first bar is at row 4, second at row 5, etc.
- Individual bar JSON files are numbered sequentially starting from 1 (first bar at row 4 becomes `/data/bars/1.json`, second bar at row 5 becomes `/data/bars/2.json`, etc.)
- Maximum reasonable CSV file size is 500 bars (approximately 50KB-100KB)
