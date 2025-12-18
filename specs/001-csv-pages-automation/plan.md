# Implementation Plan: CSV Validation and Publishing System

**Branch**: `001-csv-pages-automation` | **Date**: 2025-12-18 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-csv-pages-automation/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build a GitHub-based CSV validation and publishing pipeline where non-programmers edit `bars.csv` via GitHub's web UI, TypeScript validates the data in GitHub Actions, generates static JSON artifacts, and publishes to GitHub Pages with comprehensive error reporting.

## Technical Context

**Language/Version**: TypeScript 5.x (Node.js 20 LTS)  
**Primary Dependencies**: csv-parse (CSV parsing), zod (schema validation), Node.js built-ins  
**Storage**: File-based (CSV input → JSON output), GitHub Pages hosting  
**Testing**: Vitest (unit tests, golden/snapshot tests)  
**Target Platform**: GitHub Actions runner (ubuntu-latest), GitHub Pages  
**Project Type**: Single project (build tool / CLI)  
**Performance Goals**: <30s full pipeline (validate + generate + publish)  
**Constraints**: Must work entirely within GitHub Actions, no external services  
**Scale/Scope**: ~100-500 bars, single CSV file, ~10 JSON outputs

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Evidence |
|-----------|--------|----------|
| **I. CSV is Source of Truth** | ✅ PASS | `/webservice/bars.csv` is only input; all JSON derived from it |
| **II. Non-Programmer Friendly** | ✅ PASS | GitHub web UI editing, clear error pages at `/errors/` |
| **III. Data Contract for Clients** | ✅ PASS | JSON Schema contracts defined in `contracts/` folder |
| **IV. Deterministic Builds** | ✅ PASS | TypeScript validation + JSON generation produces identical output for same input |
| **V. Fail Loudly, Publish Errors** | ✅ PASS | Workflow fails on errors but still publishes `/errors/*` |

**Tech Constraints Check:**
- ✅ GitHub Pages from Actions to `gh-pages` branch
- ✅ Input: `bars.csv` in `/webservice/` folder (per constitution)
- ✅ Outputs: `/data/bars.json`, `/data/bars/{n}.json`, `/errors/index.html`, `/errors/errors.json`

**Validation Standards Check:**
- ✅ Header validation with canonical column names
- ✅ Required fields validation (Name, Email, Street, etc.)
- ✅ Email format validation
- ✅ Coordinate validation (lat/lng ranges)
- ✅ Price validation (numeric, non-negative)
- ✅ Boolean normalization (2F1? → Yes/No to JSON boolean)

**GATE RESULT**: ✅ PASS - Proceed to Phase 0

---

### Post-Design Re-evaluation (Phase 1 Complete)

| Principle | Status | Evidence |
|-----------|--------|----------|
| **I. CSV is Source of Truth** | ✅ PASS | Design uses `bars.csv` exclusively as input |
| **II. Non-Programmer Friendly** | ✅ PASS | Error reports with line numbers and fix instructions |
| **III. Data Contract for Clients** | ✅ PASS | 4 JSON Schema contracts defined: bar, bars-collection, validation-result, validation-error |
| **IV. Deterministic Builds** | ✅ PASS | Zod schemas guarantee consistent transformation; output sorted by ID |
| **V. Fail Loudly, Publish Errors** | ✅ PASS | Workflow pattern uses `continue-on-error` + final fail step |

**FINAL GATE**: ✅ PASS - Ready for Phase 2 (task breakdown)

## Project Structure

### Documentation (this feature)

```text
specs/001-csv-pages-automation/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   └── bars-schema.json # JSON Schema for bar data
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
webservice/
├── bars.csv             # Source of truth (human-edited)
├── src/
│   ├── index.ts         # CLI entry point
│   ├── parser.ts        # CSV parsing logic
│   ├── validator.ts     # Zod schema validation
│   ├── generator.ts     # JSON artifact generation
│   └── reporter.ts      # Error report generation (HTML + JSON)
├── tests/
│   ├── unit/            # Parser, validator unit tests
│   ├── fixtures/        # Test CSV files
│   └── golden/          # Snapshot tests for output
├── public/              # Generated output (gitignored, deployed)
│   ├── data/
│   │   ├── bars.json
│   │   └── bars/
│   │       └── {n}.json
│   └── errors/
│       ├── index.html
│       └── errors.json
├── package.json
├── tsconfig.json
└── vitest.config.ts

.github/
└── workflows/
    └── build-and-publish.yml
```

**Structure Decision**: Single project within `/webservice/` folder as specified in constitution. TypeScript tooling (validation, generation) lives alongside the CSV source. Future `/app/` folder will contain Flutter consumer app (out of scope for this feature).

## Complexity Tracking

No violations identified - design follows constitution principles:
- Single project structure (no multi-project complexity)
- Direct file I/O (no repository/ORM patterns)
- Standard GitHub Actions deployment (no custom infrastructure)
