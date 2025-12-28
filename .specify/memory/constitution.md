# Happy Hour Constitution

This repository contains two applications:
1. **Webservice** — A static publishing pipeline that transforms `bars.csv` into JSON for GitHub Pages
2. **Mobile App** — A Flutter app consuming the published JSON data

---

## Part I: Webservice (`/webservice`)

### Purpose
The webservice parses `bars.csv`, validates data, and generates static JSON + error artifacts deployed to GitHub Pages.

### Tech Stack
- **Runtime**: Node.js with ES modules (TypeScript)
- **CSV Parsing**: `csv-parse/sync`
- **Validation**: Zod schemas
- **Hosting**: GitHub Pages via `gh-pages` branch

### CSV Format
The CSV has a specific structure:
- Row 1: Empty
- Row 2: Headers
- Row 3: Empty  
- Row 4+: Data rows

**Required columns**: Name of Bar/Restaurant, Best Contact Email, Street, Latitute, Longitute, Happy Hour Days, Happy Hour Times, Price Of Cheapest Beer, Price Of Cheapest Wine, 2F1?, Notes

### Bar Data Model
```typescript
interface Bar {
  id: number;                  // Sequential from 1
  name: string;
  email: string;
  street: string;
  latitude: number;            // -90 to 90
  longitude: number;           // -180 to 180
  happy_hour_days: string;
  happy_hour_times: string;    // "HH:MM - HH:MM" format
  cheapest_beer_price: number; // Integer, non-negative
  cheapest_wine_price: number; // Integer, non-negative
  two_for_one: boolean;        // Yes/No normalized
  notes: string;
  description: string | null;
}
```

### Generated Outputs
| Path | Description |
|------|-------------|
| `/data/bars.json` | Collection: `{ generated_at, count, bars[] }` |
| `/data/bars/{id}.json` | Individual bar JSON by ID |
| `/errors/errors.json` | Validation errors (JSON) |
| `/errors/index.html` | Human-readable error report |

### CLI Commands
- `npm run validate` — Validate CSV only
- `npm run generate` — Generate all outputs
- `npm run build` — Validate + Generate (fails on errors but still publishes error reports)

### Core Principles
1. **CSV is Source of Truth** — Never hand-edit generated files
2. **Fail Loudly** — Validation failures exit non-zero but still publish `/errors/*`
3. **Deterministic Builds** — Same input produces identical output (sorted by ID)
4. **Non-Programmer Friendly** — Actionable error messages with line numbers

---

## Part II: Mobile App (`/app`)

### Purpose
A Flutter mobile application that consumes the published bar JSON data and displays happy hour information to users.

### Architecture
Clean Architecture with four layers:

```
lib/
├── presentation/     # UI: Screens, Widgets, Cubits
├── application/      # Use cases, application logic
├── domain/           # Entities, Repository interfaces, Value objects
└── infrastructure/   # API clients, Repository implementations
```

### State Management
- **Cubits** (flutter_bloc) for state management
- Each feature has its own cubit managing feature-specific state

### Screens

#### Screen 1: Bars List
A ListView displaying all bars with filtering and sorting capabilities:

| Feature | Description |
|---------|-------------|
| Show ONGOING | Filter to bars with active happy hour (current time within happy_hour_times) |
| Show ALL | Display all bars without time filter |
| Sort by Rating | Order bars by user rating (if available) |
| Sort by Location | Order by distance from user's current location |
| Sort by Beer Price | Order by `cheapest_beer_price` ascending |

#### Screen 2: Bar Detail
Detailed view of a single bar showing:
- Name, street address, location on map
- Happy hour days and times
- Beer and wine prices
- Two-for-one availability
- Notes and description

### Data Flow
```
GitHub Pages JSON → HTTP Client → Repository → Use Case → Cubit → UI
```

### Domain Entities
The mobile app maps the JSON `Bar` to domain entities with potential additions:
- Distance calculation from user location
- "Is currently active" computed property for happy hour status

---

## Governance

### Precedence
1. Stable Data Contract for Clients
2. Non-Programmer Friendly Contributions
3. CSV is the Source of Truth
4. Deterministic Builds
5. Fail Loudly, Publish Errors Always

### Breaking Changes
Any change affecting the JSON shape requires:
- "Data Contract Change" label in PR
- Updated README.md
- Migration guidance for mobile app

### Security
- No secrets in repo; use GitHub-provided tokens only
- Treat contact emails as business info; minimize personal data

---

**Version**: 2.0.0 | **Ratified**: 2025-12-18 | **Last Amended**: 2025-12-28
