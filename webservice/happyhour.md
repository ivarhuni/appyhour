
# Happy Hour Data — Project Brief (Path A: GitHub Web UI Edits)

**Goal**  
Non‑programmers update a single `bars.csv` in GitHub’s web UI. A GitHub Action validates the CSV, generates static artifacts, and publishes them to GitHub Pages. Errors are visible on a friendly `/errors` page.

---

## Repository & Hosting

- **Repo:** `ivarhuni/happyhour` (public)
- **Default branch:** `main`
- **Pages:** from GitHub Actions to `gh-pages` branch  
  **Site URL:** `https://ivarhuni.github.io/happyhour/`

---

## Inputs (edited by contributors)

- **File:** `bars.csv` at repo root
- **Access:** contributors use **GitHub’s web editor** (no CLI/tools)

---

## Outputs (static artifacts, no schema details)

- `/data/bars.json` — aggregate file
- `/data/bars/<slug>.json` — one file per bar
- `/errors/index.html` — human‑readable validation report
- `/errors/errors.json` — machine‑readable report


---

## Contributor Workflow (Path A)

1. Open `bars.csv` in GitHub → **Edit** (✏️) → make changes  
2. **Commit** directly to `main` with a short message  
3. **Actions** run automatically  
4. If checks fail, contributors read `/errors` page, fix CSV, commit again  
5. When checks pass, Pages updates; clients read from `/data/...`

> Optional: allow PRs with required checks if you want review later.

---

## Validation Rules (minimal, blocking)

- TO BE FILLED OUT BE PLANNER

All violations must appear in both `errors/index.html` and `errors/errors.json` with line numbers.

---

## Automation Requirements (GitHub Actions)

- **Workflow file:** `.github/workflows/build-and-publish.yml`
- **Triggers:** `push` on `main`, and `workflow_dispatch`
- **Steps (high‑level):**
  1. Checkout repo
  2. Run validation on `bars.csv`
  3. If valid: generate artifacts into `public/` (paths above)
  4. Upload `public/` as Pages artifact
  5. Deploy to GitHub Pages (`gh-pages` branch)
  6. If invalid: still publish `public/errors/*` and fail the job

- **Logs:** must show a concise summary (valid row count & error- **Logs:** must show a concise summary (valid row count & error count)

---

## Error Surfacing & UX

- **Human page:** `https://ivarhuni.github.io/happyhour/errors/`
- **Machine file:** `https://ivarhuni.github.io/happyhour/errors/errors.json`
- Both must be regenerated on every run, even when there are zero errors.

---

## Rollback

- GitHub file history: restore a previous `bars.csv` version → commit  
- Action rebuilds and republishes automatically.

---

## Definition of Done

- Editing `bars.csv` via GitHub web UI triggers a workflow that:
  - Validates input with the rules above
  - Publishes artifacts to the specified paths
  - Exposes clear error reporting at `/errors`
  - Updates the Pages site automatically on success

