# 🍺 Happy Hour Reykjavik

Adatabase of happy hour deals at bars in Reykjavik, Iceland. Data is validated automatically and published to GitHub Pages for consumption by mobile apps.

## 📍 Live Data

- **JSON API**: https://ivarhuni.github.io/happyhour/data/bars.json
- **Validation Report**: https://ivarhuni.github.io/happyhour/errors/

## 🤝 How to Contribute

Follow these steps:

### Adding or Editing Bar Information

1. Create a new branch - suggested format: <dd_mm_yyyy_hh_mm>
2. Delete the bars.csv and upload a new one
3. Run github action to deploy the CSV 
4. CSV file will be available as JSON at https://ivarhuni.github.io/happyhour/data/bars.json
5. To help diagnose issues, errors will be available at https://ivarhuni.github.io/happyhour/errors/

### CSV Format

The `bars.csv` file has the following columns:

| Column | Required | Description |
|--------|----------|-------------|
| Name of Bar/Restaurant | ✅ Yes | [String] The bar's name |
| Best Contact Email | ✅ Yes | [String] Email address or website URL |
| Street | ✅ Yes | [String] Street address |
| Latitute | No | [double] GPS latitude (e.g., 64.147) |
| Longitute | No | [double] GPS longitude (e.g., -21.933) |
| Happy Hour Days | ✅ Yes | [String] Days of the week (e.g., "Every day", "Mon-Fri") |
| Happy Hour Times | ✅ Yes | [String] Time range (To be changed later) (e.g., "16:00 - 19:00") |
| Price Of Cheapest Beer | No | [Int] Price in ISK (e.g., 900) |
| Price Of Cheapest Wine | No | [Int] Price in ISK (e.g., 1000) |
| 2F1? | No | [bool] Two-for-one deals? (Yes/No) |
| Notes | No | [String] Additional notes about deals |
| Description for Featured Happy Hour | No | [String] Longer description for featured listings |

### Validation Rules

Your data will be automatically validated:

- **Required fields** must not be empty
- **Contact** must be a valid email or URL
- **Coordinates** (if provided) must be valid numbers
- **Prices** (if provided) must be positive numbers
- **Non required fields** should be part of error output, if malformed

If validation fails, you'll see the errors in the PR comments. Fix them and reupload.

## 🔧 For Developers

### API Response Format

```json
{
  "generated_at": "2025-12-17T12:00:00Z",
  "total_bars": 45,
  "bars": [
    {
      "slug": "101hotel",
      "name": "101hotel",
      "contact": "reservation@101hotel.is",
      "address": "Hverfisgata 10",
      "location": { "lat": 64.147, "lng": -21.933 },
      "happy_hour": {
        "days": "Weds-Sat",
        "times": "16:00 - 19:00"
      },
      "prices": {
        "cheapest_beer": 1390,
        "cheapest_wine": 1590
      },
      "two_for_one": false,
      "notes": "example notes",
      "featured_description": "example featured description"
    }
  ]
}
```

## 📱 Consuming the Data

This data is designed to be consumed by the Happy Hour Reykjavik Flutter app. The JSON is served as static files from GitHub Pages with CORS enabled.

## 📄 License

MIT License - Feel free to use this data and code!
