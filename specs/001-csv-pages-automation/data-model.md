# Data Model: CSV Validation and Publishing System

**Date**: 2025-12-18  
**Feature**: 001-csv-pages-automation

## Entities

### Bar (Primary Entity)

Represents a single establishment's happy hour information.

| Field | CSV Column | Type | Required | Validation Rules |
|-------|-----------|------|----------|------------------|
| `id` | (derived) | integer | auto | Sequential: CSV row number - 3 |
| `name` | Name of Bar/Restaurant | string | ✅ | Non-empty, max 200 chars |
| `email` | Best Contact Email | string | ✅ | Valid email format (RFC 5322 basic) |
| `street` | Street | string | ✅ | Non-empty |
| `latitude` | Latitute | number | ✅ | -90 to 90 |
| `longitude` | Longitute | number | ✅ | -180 to 180 |
| `happy_hour_days` | Happy Hour Days | string | ✅ | Non-empty |
| `happy_hour_times` | Happy Hour Times | string | ✅ | Format: "HH:MM - HH:MM" (24-hour) |
| `cheapest_beer_price` | Price Of Cheapest Beer | integer | ✅ | Non-negative integer (ISK) |
| `cheapest_wine_price` | Price Of Cheapest Wine | integer | ✅ | Non-negative integer (ISK) |
| `two_for_one` | 2F1? | boolean | ✅ | Input: "Yes"/"No" → JSON: true/false |
| `notes` | Notes | string | ✅ | Can be empty string |
| `description` | Description for Featured Happy Hour | string \| null | ❌ | Optional promotional text |

**CSV Header Row** (canonical, case-sensitive):
```
Name of Bar/Restaurant,Best Contact Email,Street,Latitute,Longitute,Happy Hour Days,Happy Hour Times,Price Of Cheapest Beer,Price Of Cheapest Wine,2F1?,Notes,Description for Featured Happy Hour
```

> Note: "Latitute" and "Longitute" are intentional typos preserved from original CSV for backward compatibility.

---

### ValidationError

Represents a single validation issue found during CSV processing.

| Field | Type | Description |
|-------|------|-------------|
| `line` | integer | 1-based line number in CSV file |
| `field` | string \| null | Column name if field-specific, null for row-level errors |
| `code` | string | Stable error code (e.g., "INVALID_EMAIL", "MISSING_REQUIRED") |
| `message` | string | Human-readable error description |
| `value` | string \| null | The problematic value (for debugging) |

**Error Codes**:
| Code | Description |
|------|-------------|
| `MISSING_HEADER` | Expected header row not found or malformed |
| `MISSING_REQUIRED` | Required field is empty or missing |
| `INVALID_EMAIL` | Email format validation failed |
| `INVALID_COORDINATE` | Latitude/longitude out of valid range |
| `INVALID_PRICE` | Price is not a non-negative integer |
| `INVALID_BOOLEAN` | 2F1? field is not "Yes" or "No" |
| `MALFORMED_ROW` | Row has wrong number of columns |
| `PARSE_ERROR` | CSV parsing failed (unclosed quotes, etc.) |

---

### ValidationResult

Aggregated result of validating the entire CSV file.

| Field | Type | Description |
|-------|------|-------------|
| `generated_at` | ISO8601 string | Timestamp of validation run |
| `valid` | boolean | true if zero errors |
| `error_count` | integer | Total number of validation errors |
| `valid_row_count` | integer | Number of valid bar rows |
| `errors` | ValidationError[] | List of all errors found |

---

### BarsCollection

Aggregated output of all validated bars.

| Field | Type | Description |
|-------|------|-------------|
| `generated_at` | ISO8601 string | Timestamp of generation |
| `count` | integer | Number of bars in collection |
| `bars` | Bar[] | Array of all validated bar objects |

---

## State Transitions

```
┌─────────────────┐
│   bars.csv      │  (Human-edited via GitHub web UI)
│   committed     │
└────────┬────────┘
         │ push to main / workflow_dispatch
         ▼
┌─────────────────┐
│   Parsing       │  → PARSE_ERROR if CSV malformed
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Validating    │  → Collect all ValidationErrors
└────────┬────────┘
         │
         ├── errors.length > 0 ──────────────────┐
         │                                       │
         ▼                                       ▼
┌─────────────────┐                   ┌─────────────────┐
│   Generating    │                   │  Error Report   │
│   JSON outputs  │                   │  Generated      │
└────────┬────────┘                   └────────┬────────┘
         │                                     │
         ▼                                     ▼
┌─────────────────┐                   ┌─────────────────┐
│   Publishing    │                   │   Publishing    │
│   data + errors │                   │   errors only   │
│   (success)     │                   │   (workflow     │
└─────────────────┘                   │   fails)        │
                                      └─────────────────┘
```

---

## Relationships

```
bars.csv (1) ──parses-to──▶ (N) Bar
bars.csv (1) ──validates-to──▶ (1) ValidationResult
ValidationResult (1) ──contains──▶ (N) ValidationError
BarsCollection (1) ──contains──▶ (N) Bar
```

---

## TypeScript Types (Zod Schemas)

```typescript
// Field-level schemas
const emailSchema = z.string().email();
const latitudeSchema = z.number().min(-90).max(90);
const longitudeSchema = z.number().min(-180).max(180);
const priceSchema = z.number().int().nonnegative();
const booleanFromYesNo = z.enum(["Yes", "No"]).transform(v => v === "Yes");
const happyHourTimesSchema = z.string().regex(/^\d{2}:\d{2}\s*-\s*\d{2}:\d{2}$/, "Must be HH:MM - HH:MM format");

// Bar schema
const barSchema = z.object({
  id: z.number().int().positive(),
  name: z.string().min(1).max(200),
  email: emailSchema,
  street: z.string().min(1),
  latitude: latitudeSchema,
  longitude: longitudeSchema,
  happy_hour_days: z.string().min(1),
  happy_hour_times: happyHourTimesSchema,
  cheapest_beer_price: priceSchema,
  cheapest_wine_price: priceSchema,
  two_for_one: z.boolean(),
  notes: z.string(),
  description: z.string().nullable(),
});

// ValidationError schema
const validationErrorSchema = z.object({
  line: z.number().int().positive(),
  field: z.string().nullable(),
  code: z.string(),
  message: z.string(),
  value: z.string().nullable(),
});

// ValidationResult schema
const validationResultSchema = z.object({
  generated_at: z.string().datetime(),
  valid: z.boolean(),
  error_count: z.number().int().nonnegative(),
  valid_row_count: z.number().int().nonnegative(),
  errors: z.array(validationErrorSchema),
});

// BarsCollection schema
const barsCollectionSchema = z.object({
  generated_at: z.string().datetime(),
  count: z.number().int().nonnegative(),
  bars: z.array(barSchema),
});
```
