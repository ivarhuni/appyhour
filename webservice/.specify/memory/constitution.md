# Happy Hour Constitution

This repository is a **data-first, static publishing pipeline**: contributors edit a single `bars.csv`, automation validates it, generates static JSON + error artifacts, and publishes to GitHub Pages for consumption by client apps.

## Core Principles

### I. CSV is the Source of Truth
- `bars.csv` is the only human-edited input.
- All generated artifacts (JSON + error reports) are derived deterministically from `bars.csv` plus the generator version in `main`.
- Never hand-edit generated files in `gh-pages` or under `public/`—they must be reproducible.

### II. Non‑Programmer Friendly Contributions
- Optimize for GitHub Web UI edits: clear validation messages, actionable line numbers, and minimal “developer setup” assumptions.
- Every failure must be explainable via `/errors` (human) and `/errors/errors.json` (machine), without reading Action logs.
- If rules change, update contributor-facing docs (`README.md`) in the same change.

### III. Stable Data Contract for Clients
- `/data/bars.json` and `/data/bars/<slug>.json` are treated as **public API**.
- Prefer additive changes (new optional fields) over breaking changes.
- Any breaking change requires: versioning strategy, migration plan, and a deprecation window (see Governance).

### IV. Deterministic Builds & Repeatability
- Running the generator twice on the same `bars.csv` must produce identical outputs (ignoring timestamps that are explicitly documented).
- Artifact ordering must be stable (e.g., bars sorted by slug).
- Avoid locale-dependent formatting; enforce explicit encoding (UTF‑8) and normalized newlines where feasible.

### V. Fail Loudly, Publish Errors Always
- Validation failures must **fail the workflow** (non‑zero exit), but still publish `/errors/*` to GitHub Pages.
- Error reporting must include enough context to fix issues quickly:
  - line/row number(s)
  - column/header name (when applicable)
  - error code (stable identifier)
  - human message (actionable)

## System Constraints & Standards

### Tech/Hosting Constraints
- **Hosting**: GitHub Pages deployed from GitHub Actions to `gh-pages`.
- **Input**: `bars.csv` at repo root.
- **Outputs** (in published site root):
  - `/data/bars.json`
  - `/data/bars/<slug>.json`
  - `/errors/index.html`
  - `/errors/errors.json`

### Data & Validation Standards
- **Headers**: column names are canonical; renames are breaking changes.
- **Required fields**: must be present and non-empty (as documented in `README.md`).
- **Contact**: must be a valid email or a valid URL.
- **Coordinates** (if provided): must be valid numbers and within real ranges (lat \(-90..90\), lng \(-180..180\)).
- **Prices** (if provided): must be integers and non-negative (or strictly positive if the project decides so—document the choice).
- **Booleans** (if provided): accept a documented set (e.g., `Yes/No`, `true/false`) and normalize to JSON boolean.
- **Slug**: derived deterministically from name (or a dedicated column, if later introduced). Slugs must be unique and URL-safe.
- **Partial validity**: if any blocking error exists, consider the dataset invalid (workflow fails) but still publish errors.

### Security & Privacy
- Do not introduce secrets into the repo. Workflows must rely on GitHub-provided tokens only.
- Avoid collecting or publishing personal data. If contact fields can include emails, treat them as business contact info and keep scope minimal.
- Dependencies should be minimal; pin versions when practical and avoid supply-chain risk.

### Performance & Size
- Outputs should be lightweight enough for mobile clients on slow networks.
- Prefer compact JSON (no unnecessary whitespace) while preserving readability where it doesn’t materially increase size.

## Development Workflow & Quality Gates

### Workflow Requirements (CI/CD)
- A single workflow (e.g. `.github/workflows/build-and-publish.yml`) must:
  - run on `push` to `main` and `workflow_dispatch`
  - validate `bars.csv`
  - generate artifacts into `public/`
  - deploy `public/` to GitHub Pages
  - publish errors even on failure

### Testing Requirements
- **Unit tests**: validation and transformation logic (parsing, normalization, slugging, edge cases).
- **Golden tests**: snapshot expected outputs for a small fixture CSV (ensures stable ordering + formatting).
- **Contract tests**: ensure `/data/bars.json` and per-bar JSON match documented schema expectations.

### Documentation Requirements
- `README.md` must document:
  - how to edit `bars.csv` (web-first)
  - the exact CSV columns and accepted formats
  - where to find `/errors` and how to interpret them
- Error codes (if used) must be documented and stable.

## Governance
- This constitution supersedes other docs when there is conflict.
- Any change that affects the public data contract (JSON shape, meanings, required fields, header names) must include:
  - a clearly labeled “Data Contract Change” note in the PR/commit description
  - updates to `README.md`
  - migration guidance for downstream clients (even if “no action required”)
- Breaking changes require:
  - explicit versioning approach (e.g., introducing `/v2/data/...` or adding `schema_version` and maintaining backward-compat output)
  - a deprecation window (time- or release-based) where old and new formats coexist
- If principles conflict, precedence is:
  1) **Stable Data Contract for Clients**
  2) **Non‑Programmer Friendly Contributions**
  3) **CSV is the Source of Truth**
  4) **Deterministic Builds**
  5) **Fail Loudly, Publish Errors Always**

**Version**: 1.0.0 | **Ratified**: 2025-12-18 | **Last Amended**: 2025-12-18
