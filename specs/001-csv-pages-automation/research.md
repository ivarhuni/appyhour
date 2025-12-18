# Research: CSV Validation and Publishing System

**Date**: 2025-12-18  
**Feature**: 001-csv-pages-automation

## Research Tasks

### 1. TypeScript CSV Parsing Libraries

**Task**: Find best practices for CSV parsing in TypeScript/Node.js

**Decision**: Use `csv-parse` (papaparse is browser-focused, csv-parse is Node.js native)

**Rationale**:
- `csv-parse` is the most mature Node.js CSV parser
- Supports streaming for large files (future-proof for 500+ bars)
- Built-in error handling with line numbers
- TypeScript types available via `@types/csv-parse`
- Synchronous API available for simple use cases

**Alternatives Considered**:
- `papaparse`: More browser-oriented, heavier bundle
- `fast-csv`: Good performance but less community support
- Manual parsing: Too error-prone for edge cases (quoted fields, escapes)

---

### 2. TypeScript Schema Validation

**Task**: Best approach for runtime validation with clear error messages

**Decision**: Use `zod` for schema definition and validation

**Rationale**:
- First-class TypeScript support (infers types from schemas)
- Excellent error messages with field paths
- Composable schemas (can build bar schema from field schemas)
- Transform support (e.g., "Yes"/"No" → boolean)
- Small bundle size, no dependencies

**Alternatives Considered**:
- `yup`: Less TypeScript-native, more verbose
- `joi`: Heavier, designed for backend APIs
- `ajv` + JSON Schema: More complex setup, less TypeScript-friendly
- Manual validation: Inconsistent error messages, maintenance burden

---

### 3. GitHub Actions Best Practices

**Task**: Patterns for GitHub Actions that validate, build, and deploy to Pages

**Decision**: Single workflow with conditional deployment

**Rationale**:
- Use `actions/checkout@v4` for repo access
- Use `actions/setup-node@v4` with Node 20 LTS
- Use `peaceiris/actions-gh-pages@v4` for reliable Pages deployment
- Always deploy `/errors/*` even on validation failure
- Use `continue-on-error` + `if` conditions to publish errors before failing

**Key Pattern**:
```yaml
jobs:
  build-and-publish:
    steps:
      - checkout
      - setup-node
      - npm ci
      - run: npm run validate  # exits non-zero on errors
        id: validate
        continue-on-error: true
      - run: npm run generate  # generates JSON + error reports
      - deploy to gh-pages     # always deploys (errors or success)
      - fail workflow if validate failed
```

**Alternatives Considered**:
- Separate validate/deploy workflows: More complex, harder to coordinate
- GitHub Pages action (official): Less flexible for error-first deployment

---

### 4. JSON Output Structure

**Task**: Determine JSON structure for bars data that satisfies spec requirements

**Decision**: Row-number-based file naming (per spec clarification)

**Rationale**:
- Spec explicitly states: `/data/bars/{row_number}.json` where row_number = CSV row - 3
- Simple, deterministic, no slug collision concerns
- Easy for consumers to iterate (1, 2, 3, ...)
- Matches contributor mental model (row 4 in CSV = bar 1)

**Structure**:
```json
// /data/bars.json
{
  "generated_at": "2025-12-18T10:30:00Z",
  "count": 6,
  "bars": [
    { "id": 1, "name": "Brewdog", ... },
    { "id": 2, "name": "Bjórgarðurinn", ... }
  ]
}

// /data/bars/1.json
{
  "id": 1,
  "name": "Brewdog",
  "email": "bjor@brewdog.is",
  "street": "Frakkastígur 8a",
  "latitude": null,
  "longitude": null,
  "happy_hour_days": "Every day",
  "happy_hour_times": "15:00 - 17:00",
  "cheapest_beer_price": 123,
  "cheapest_wine_price": 500,
  "two_for_one": false,
  "notes": "They call it \"Hoppy Hour\"",
  "description": null
}
```

---

### 5. Error Report Format

**Task**: Design error reporting that meets FR-015 through FR-019

**Decision**: Dual-format error reporting (HTML + JSON)

**Rationale**:
- HTML for human readability (non-programmers)
- JSON for machine parsing (future tooling, client apps)
- Include line numbers, field names, error types, actionable messages

**HTML Structure** (`/errors/index.html`):
```html
<h1>Validation Results</h1>
<p>Status: ❌ 3 errors found</p>
<table>
  <tr><th>Line</th><th>Field</th><th>Error</th><th>How to Fix</th></tr>
  <tr><td>5</td><td>email</td><td>Invalid email format</td><td>Enter a valid email like name@example.com</td></tr>
</table>
```

**JSON Structure** (`/errors/errors.json`):
```json
{
  "generated_at": "2025-12-18T10:30:00Z",
  "valid": false,
  "error_count": 3,
  "valid_row_count": 3,
  "errors": [
    {
      "line": 5,
      "field": "email",
      "code": "INVALID_EMAIL",
      "message": "Invalid email format",
      "value": "not-an-email"
    }
  ]
}
```

---

### 6. CSV Location Clarification

**Task**: Confirm bars.csv location (spec says root, actual file is in /webservice/)

**Decision**: Keep bars.csv in `/webservice/` per current structure

**Rationale**:
- Constitution mentions `/webservice` folder for CSV/JSON hosted files
- Current bars.csv already exists at `/webservice/bars.csv`
- Keeps data separate from specs, scripts, future app code
- Update spec references to reflect actual location

---

### 7. Testing Strategy

**Task**: Define testing approach for validation pipeline

**Decision**: Three-tier testing with Vitest

**Rationale**:
- **Unit tests**: Individual validators (email, coordinates, prices)
- **Golden tests**: Snapshot expected JSON output for fixture CSVs
- **Contract tests**: Validate output matches JSON Schema

**Test Fixtures**:
- `valid.csv`: Complete valid data (happy path)
- `errors.csv`: Multiple error types for error report testing
- `edge-cases.csv`: Empty rows, special characters, boundary values

---

## Resolved Clarifications

| Topic | Resolution |
|-------|------------|
| CSV location | `/webservice/bars.csv` (not repo root) |
| Bar ID scheme | Sequential from 1, based on CSV row number - 3 |
| Slug vs ID | No slug needed; use numeric ID only |
| Timestamp in output | Include `generated_at` for cache-busting awareness |
| Empty coordinates | Allow null/empty; only validate format if present |
