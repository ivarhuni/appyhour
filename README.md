# AppyHour (webservice + app) 🍺

This repository was created using **GitHub Spec Kit** + **Opus 4.5**.

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

## Speckit Development Workflow

This repo uses **Speckit** for AI-assisted feature development. Features are planned and implemented using this workflow:

```
/speckit.specify → /speckit.plan → /speckit.tasks → /speckit.implement
        ↓               ↓               ↓                  ↓
    spec.md        plan.md +        tasks.md          code changes
                   research.md +
                   data-model.md +
                   contracts/
```

### How it works

1. **`/speckit.specify`** - Define what to build (user stories, requirements)
2. **`/speckit.analyze`** - *(Optional)* Check spec for consistency
3. **`/speckit.plan`** - Design the solution (tech decisions, architecture)
4. **`/speckit.tasks`** - Generate dependency-ordered task checklist

> **Agent Handoff**: One agent does specify → plan → tasks. Then a **fresh agent** is spawned with a clean context window to run `/speckit.implement` and execute the tasks.

Feature specs live in `specs/{###-feature-name}/`.

## Flutter App Development

### Code Generation (build_runner)

The app uses `json_serializable` for JSON parsing. After modifying any `@JsonSerializable` annotated classes, regenerate the code:

```bash
cd app
dart run build_runner build --delete-conflicting-outputs
```

### Localization

Localization uses Flutter's built-in code generation. ARB files are stored in `lib/l10n/` and generated code outputs to `lib/gen_l10n/`.

After adding or modifying ARB files, regenerate with:

```bash
cd app
flutter gen-l10n
```

> Note: With `generate: true` in `pubspec.yaml`, localization code is also auto-generated during `flutter run` and `flutter build`.

## License

MIT
