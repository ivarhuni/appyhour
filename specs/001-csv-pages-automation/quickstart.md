# Quickstart: CSV Validation and Publishing System

**Feature**: 001-csv-pages-automation  
**Time to setup**: ~10 minutes

## Prerequisites

- Node.js 20 LTS or later
- npm (comes with Node.js)
- Git

## Local Development Setup

### 1. Clone and Install

```bash
cd /Users/ivarj/dev/appyhour/webservice
npm install
```

### 2. Project Structure

```
webservice/
├── bars.csv              # Source data (edit this!)
├── src/
│   ├── index.ts          # CLI entry: npm run validate
│   ├── parser.ts         # CSV → raw records
│   ├── validator.ts      # Zod schema validation
│   ├── generator.ts      # Validated → JSON files
│   └── reporter.ts       # Error → HTML + JSON
├── public/               # Output (gitignored)
│   ├── data/bars.json
│   ├── data/bars/{n}.json
│   └── errors/
└── tests/
```

### 3. Available Commands

```bash
# Run full pipeline (validate + generate)
npm run build

# Validate only (check for errors)
npm run validate

# Run tests
npm test

# Type checking
npm run typecheck
```

### 4. Local Workflow

1. Edit `bars.csv` with your data
2. Run `npm run build`
3. Check `public/errors/index.html` for any issues
4. If valid, JSON appears in `public/data/`

## GitHub Actions (Production)

The pipeline runs automatically when you:
- Push to `main` branch
- Trigger manually via Actions tab

### Workflow Steps

1. **Checkout** → Get latest code
2. **Setup Node** → Install Node.js 20
3. **Install** → `npm ci`
4. **Build** → Validate CSV + Generate JSON
5. **Deploy** → Push `public/` to `gh-pages` branch

### Published URLs

| Resource | URL |
|----------|-----|
| All bars | `https://ivarhuni.github.io/happyhour/data/bars.json` |
| Bar #1 | `https://ivarhuni.github.io/happyhour/data/bars/1.json` |
| Errors (HTML) | `https://ivarhuni.github.io/happyhour/errors/` |
| Errors (JSON) | `https://ivarhuni.github.io/happyhour/errors/errors.json` |

## CSV Format

**Header row** (must match exactly):
```
Name of Bar/Restaurant,Best Contact Email,Street,Latitute,Longitute,Happy Hour Days,Happy Hour Times,Price Of Cheapest Beer,Price Of Cheapest Wine,2F1?,Notes,Description for Featured Happy Hour
```

**Example row**:
```
Brewdog,bjor@brewdog.is,Frakkastígur 8a,64.1466,-21.9426,Every day,15:00 - 17:00,123,500,No,"They call it ""Hoppy Hour""",
```

### Field Requirements

| Field | Required | Format |
|-------|----------|--------|
| Name of Bar/Restaurant | ✅ | Text |
| Best Contact Email | ✅ | Valid email |
| Street | ✅ | Text |
| Latitute | ❌ | Number (-90 to 90) |
| Longitute | ❌ | Number (-180 to 180) |
| Happy Hour Days | ✅ | Text |
| Happy Hour Times | ✅ | "HH:MM - HH:MM" |
| Price Of Cheapest Beer | ✅ | Integer (ISK) |
| Price Of Cheapest Wine | ✅ | Integer (ISK) |
| 2F1? | ✅ | "Yes" or "No" |
| Notes | ✅ | Text (can be empty) |
| Description | ❌ | Text |

## Troubleshooting

### "Validation failed"
1. Check `public/errors/index.html` for specific errors
2. Each error shows line number and field name
3. Fix the CSV and re-run

### "CSV parse error"
- Check for unclosed quotes: `"text with "quotes" inside"` → `"text with ""quotes"" inside"`
- Ensure consistent column count on every row

### "Email invalid"
- Format: `name@domain.com`
- No spaces, special characters

### "Price invalid"
- Must be whole number (no decimals)
- Must be 0 or positive

## Next Steps

After local validation works:

1. Commit your `bars.csv` changes
2. Push to `main`
3. Watch GitHub Actions run
4. Check published site for results
