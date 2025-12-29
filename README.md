# AppyHour (webservice + app) 🍺

This repo contains:

- **`webservice/`**: Node/TypeScript pipeline that validates `webservice/bars.csv` and generates a static JSON API + validation report.
- **`app/`**: Flutter app that consumes the published JSON API.

## Quick links (published)

- **All bars**: `https://ivarhuni.github.io/appyhour/data/bars.json`
- **One bar**: `https://ivarhuni.github.io/appyhour/data/bars/{id}.json`
- **Validation report (HTML)**: `https://ivarhuni.github.io/appyhour/errors/`
- **Validation report (JSON)**: `https://ivarhuni.github.io/appyhour/errors/errors.json`

## Update the data

- **Edit**: `webservice/bars.csv`
- **Validate + generate locally**:

```bash
cd webservice
npm ci
npm run build
```

Merge to `main` to publish.

## CSV columns (order matters)

`Name of Bar/Restaurant, Best Contact Email, Street, Latitute, Longitute, Happy Hour Days, Happy Hour Times, Price Of Cheapest Beer, Price Of Cheapest Wine, 2F1?, Notes, Description for Featured Happy Hour`

> Note: `Latitute` / `Longitute` spellings are intentional (backwards compatibility).

## License

MIT
