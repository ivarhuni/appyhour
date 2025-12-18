# Happy Hour Data 🍺

[![Build and Publish](https://github.com/ivarhuni/happyhour/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/ivarhuni/happyhour/actions/workflows/build-and-publish.yml)

A CSV-based system for managing Reykjavik happy hour data. Contributors edit CSV via GitHub, and data is automatically validated and published to GitHub Pages.

## 🎯 Quick Links

| Resource | URL |
|----------|-----|
| All Bars (JSON) | https://ivarhuni.github.io/happyhour/data/bars.json |
| Individual Bar | https://ivarhuni.github.io/happyhour/data/bars/{id}.json |
| Validation Status | https://ivarhuni.github.io/happyhour/errors/ |
| Error Report (JSON) | https://ivarhuni.github.io/happyhour/errors/errors.json |

## 📝 How to Contribute

### Adding or Editing Bar Data

1. Navigate to [`webservice/bars.csv`](webservice/bars.csv) on GitHub
2. Click the **pencil icon** (Edit this file)
3. Make your changes following the format below
4. Commit directly to `main` branch
5. The system will automatically validate and publish

### CSV Format

The CSV must have the following columns in this exact order:

| Column | Required | Format | Example |
|--------|----------|--------|---------|
| Name of Bar/Restaurant | ✅ | Text (max 200 chars) | Brewdog |
| Best Contact Email | ✅ | Valid email | bjor@brewdog.is |
| Street | ✅ | Text | Frakkastígur 8a |
| Latitute | ✅ | Number (-90 to 90) | 64.1475 |
| Longitute | ✅ | Number (-180 to 180) | -21.9287 |
| Happy Hour Days | ✅ | Text | Every day |
| Happy Hour Times | ✅ | HH:MM - HH:MM | 15:00 - 17:00 |
| Price Of Cheapest Beer | ✅ | Whole number (ISK) | 890 |
| Price Of Cheapest Wine | ✅ | Whole number (ISK) | 1200 |
| 2F1? | ✅ | Yes or No | No |
| Notes | ✅ | Text (can be empty) | "Special deals on Tuesdays" |
| Description for Featured Happy Hour | ❌ | Text (optional) | |

> **Note**: "Latitute" and "Longitute" are intentionally spelled this way for backward compatibility.

### Example Row

```csv
Brewdog,bjor@brewdog.is,Frakkastígur 8a,64.1475,-21.9287,Every day,15:00 - 17:00,890,1200,No,"They call it ""Hoppy Hour""",
```

## 🔄 Rollback Procedure

If you made a mistake and need to restore a previous version:

1. Go to [`webservice/bars.csv`](webservice/bars.csv) on GitHub
2. Click **History** to see all previous versions
3. Find the version you want to restore
4. Click the commit hash to view that version
5. Click **Raw** to see the raw content
6. Copy the entire content
7. Edit the current `bars.csv` and paste the content
8. Commit to restore the previous version

The system will automatically rebuild with the restored data.

## 🛠️ API Documentation

### GET /data/bars.json

Returns all validated bars as a JSON collection.

```json
{
  "generated_at": "2025-12-18T10:30:00.000Z",
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
      "cheapest_beer_price": 890,
      "cheapest_wine_price": 1200,
      "two_for_one": false,
      "notes": "They call it \"Hoppy Hour\"",
      "description": null
    }
  ]
}
```

### GET /data/bars/{id}.json

Returns a single bar by ID (1-based, corresponds to CSV row position).

### GET /errors/errors.json

Returns validation results including any errors.

```json
{
  "generated_at": "2025-12-18T10:30:00.000Z",
  "valid": true,
  "error_count": 0,
  "valid_row_count": 5,
  "errors": []
}
```

## 🏗️ Local Development

```bash
cd webservice
npm install
npm run build
```

### Available Commands

- `npm run validate` - Validate CSV and show results
- `npm run generate` - Generate JSON output files
- `npm run build` - Compile TypeScript + validate + generate
- `npm test` - Run tests

## 📁 Project Structure

```
webservice/
├── bars.csv              # Source of truth (edit this!)
├── src/
│   ├── index.ts          # CLI entry point
│   ├── parser.ts         # CSV parsing
│   ├── validator.ts      # Data validation
│   ├── generator.ts      # JSON generation
│   └── reporter.ts       # Error reports
└── public/               # Generated output (gitignored)
    ├── data/
    │   ├── bars.json
    │   └── bars/{n}.json
    └── errors/
        ├── index.html
        └── errors.json
```

## License

MIT
