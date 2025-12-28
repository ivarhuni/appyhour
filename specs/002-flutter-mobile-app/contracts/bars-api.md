# API Contract: Bars Data Endpoint

**Branch**: `002-flutter-mobile-app` | **Date**: 2024-12-28

## Overview

The Flutter app consumes a static JSON file published to GitHub Pages by the webservice project. This is a read-only contract; the mobile app never writes data.

## Endpoint

### GET /data/bars.json

**Base URL**: `https://ivarhuni.github.io/happyhour`

**Full URL**: `https://ivarhuni.github.io/happyhour/data/bars.json`

**Method**: GET

**Authentication**: None (public endpoint)

**Content-Type**: `application/json`

---

## Response Schema

### Success Response (200 OK)

```json
{
  "generated_at": "2024-12-28T15:30:00Z",
  "count": 5,
  "bars": [
    {
      "id": 1,
      "name": "Brewdog",
      "email": "bjor@brewdog.is",
      "street": "Frakkastígur 8a",
      "latitude": 64.1475,
      "longitude": -21.9287,
      "happy_hour_days": "Every day",
      "happy_hour_times": "15:00 - 17:00",
      "cheapest_beer_price": 123,
      "cheapest_wine_price": 500,
      "two_for_one": false,
      "notes": "They call it \"Hoppy Hour\"",
      "description": null
    }
  ]
}
```

### Response Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `generated_at` | string (ISO 8601) | Yes | Timestamp when JSON was generated |
| `count` | integer | Yes | Number of bars in the array |
| `bars` | array[Bar] | Yes | Array of bar objects |

### Bar Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | Yes | Unique identifier (sequential from 1) |
| `name` | string | Yes | Name of the bar/restaurant |
| `email` | string | Yes | Contact email |
| `street` | string | Yes | Street address |
| `latitude` | number | Yes | Geographic latitude (-90 to 90) |
| `longitude` | number | Yes | Geographic longitude (-180 to 180) |
| `happy_hour_days` | string | Yes | Days when happy hour is available |
| `happy_hour_times` | string | Yes | Time range in "HH:MM - HH:MM" format |
| `cheapest_beer_price` | integer | Yes | Beer price in ISK (≥0) |
| `cheapest_wine_price` | integer | Yes | Wine price in ISK (≥0) |
| `two_for_one` | boolean | Yes | Whether 2-for-1 deals available |
| `notes` | string | Yes | Additional notes (may be empty) |
| `description` | string \| null | Yes | Optional featured description |

---

## Error Handling

Since this is a static file endpoint, error handling is limited:

| Status | Scenario | App Behavior |
|--------|----------|--------------|
| 200 | Success | Parse and display bars |
| 404 | File not found | Show error banner with retry |
| Network Error | No connectivity | Show error banner with retry |
| Parse Error | Malformed JSON | Show error banner with retry |

---

## Caching Behavior

**Client (Mobile App)**: No caching. Fresh fetch on every app launch and pull-to-refresh.

**Server (GitHub Pages)**: Standard CDN caching. Changes may take up to 10 minutes to propagate.

---

## Known Values

### happy_hour_days

Expected patterns (based on current data):
- `"Every day"`
- `"Mon-Fri"`
- `"Weekdays"`
- `"Weekends"`
- `"Sat-Sun"`

### happy_hour_times

Format: `"HH:MM - HH:MM"` (24-hour format)

Examples:
- `"15:00 - 17:00"` — Afternoon happy hour
- `"12:00 - 20:00"` — Extended happy hour
- `"22:00 - 02:00"` — Overnight (crosses midnight)

---

## Related Schemas

The webservice project maintains JSON Schema definitions:

- [`/specs/001-csv-pages-automation/contracts/bar.schema.json`](../../001-csv-pages-automation/contracts/bar.schema.json)
- [`/specs/001-csv-pages-automation/contracts/bars-collection.schema.json`](../../001-csv-pages-automation/contracts/bars-collection.schema.json)

The mobile app should remain compatible with these schemas.


