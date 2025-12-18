# Tasks: CSV Validation and Publishing System

**Input**: Design documents from `/specs/001-csv-pages-automation/`  
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- All paths relative to repository root

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Initialize TypeScript project structure in `/webservice/`

- [X] T001 Create webservice/package.json with dependencies (csv-parse, zod, typescript, vitest)
- [X] T002 [P] Create webservice/tsconfig.json with strict TypeScript config
- [X] T003 [P] Create webservice/vitest.config.ts for test configuration
- [X] T004 [P] Add webservice/public/ to .gitignore (generated output)
- [X] T005 [P] Create webservice/src/ directory structure per plan.md

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that ALL user stories depend on

**⚠️ CRITICAL**: User stories cannot begin until this phase is complete

- [X] T006 Implement CSV parser in webservice/src/parser.ts (csv-parse wrapper with line tracking)
- [X] T007 Implement Bar Zod schema in webservice/src/schemas/bar.ts (per data-model.md)
- [X] T008 [P] Implement ValidationError schema in webservice/src/schemas/validation-error.ts
- [X] T009 [P] Implement ValidationResult schema in webservice/src/schemas/validation-result.ts
- [X] T010 Implement field validators in webservice/src/validator.ts (email, coords, prices, boolean)
- [X] T011 Create CLI entry point in webservice/src/index.ts (orchestrates parse → validate → generate → report)

**Checkpoint**: Foundation ready - TypeScript can parse CSV and validate against schemas

---

## Phase 3: User Story 1 - Submit Valid Bar Data (Priority: P1) 🎯 MVP

**Goal**: Contributors add valid bar data via GitHub web UI, system validates and publishes JSON to GitHub Pages

**Independent Test**: Edit bars.csv with one valid entry, commit to main, verify JSON appears at published URLs

### Implementation for User Story 1

- [X] T012 [US1] Implement JSON generator in webservice/src/generator.ts (bars.json + individual bars/{n}.json)
- [X] T013 [US1] Create GitHub Actions workflow in .github/workflows/build-and-publish.yml
- [X] T014 [US1] Configure workflow to trigger on push to main and workflow_dispatch
- [X] T015 [US1] Add npm scripts to webservice/package.json (build, validate, generate)
- [X] T016 [US1] Configure peaceiris/actions-gh-pages deployment in workflow

**Checkpoint**: Valid CSV commits produce JSON at https://ivarhuni.github.io/happyhour/data/

---

## Phase 4: User Story 2 - Identify and Fix Data Errors (Priority: P1)

**Goal**: Invalid data triggers clear error reports with line numbers; errors page always published

**Independent Test**: Commit invalid CSV, verify error page shows line numbers and fix instructions

### Implementation for User Story 2

- [X] T017 [US2] Implement error collector in webservice/src/validator.ts (accumulates all errors with line numbers)
- [X] T018 [US2] Implement HTML error reporter in webservice/src/reporter.ts (generates /errors/index.html)
- [X] T019 [US2] Implement JSON error reporter in webservice/src/reporter.ts (generates /errors/errors.json)
- [X] T020 [US2] Add human-friendly error messages with fix instructions per error code
- [X] T021 [US2] Add console summary output in webservice/src/index.ts (valid count, error count for workflow logs)
- [X] T022 [US2] Update workflow to use continue-on-error for validation step
- [X] T023 [US2] Update workflow to always publish /errors/ even on validation failure
- [X] T024 [US2] Update workflow to fail after publishing when validation errors exist

**Checkpoint**: Invalid commits show clear errors at https://ivarhuni.github.io/happyhour/errors/

---

## Phase 5: User Story 3 - Restore Previous Valid Version (Priority: P2)

**Goal**: System automatically rebuilds when previous CSV version is restored via GitHub history

**Independent Test**: Make breaking change, restore previous version via GitHub history, verify rebuild succeeds

### Implementation for User Story 3

- [X] T025 [US3] Verify workflow triggers on any commit to main (including reverts)
- [X] T026 [US3] Add workflow status badge to README.md for visibility
- [X] T027 [US3] Document rollback procedure in README.md (using GitHub file history)

**Checkpoint**: Any commit (including restores) triggers full rebuild and publish

---

## Phase 6: User Story 4 - Consume Published Data (Priority: P3)

**Goal**: External apps can fetch JSON from published GitHub Pages endpoints

**Independent Test**: After publish, fetch /data/bars.json and /data/bars/1.json, verify correct JSON structure

### Implementation for User Story 4

- [X] T028 [US4] Add CORS headers via _headers file or meta tags for cross-origin access
- [X] T029 [US4] Create index.html at site root with links to data endpoints
- [X] T030 [US4] Document API endpoints in README.md (URLs, JSON structure, example responses)

**Checkpoint**: External apps can fetch data from https://ivarhuni.github.io/happyhour/data/

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Quality, documentation, and edge case handling

- [X] T031 [P] Handle edge case: empty CSV file (no data rows)
- [X] T032 [P] Handle edge case: CSV with only headers
- [X] T033 [P] Handle edge case: non-ASCII characters (Icelandic names)
- [X] T034 [P] Handle edge case: malformed rows (wrong column count)
- [X] T035 Update README.md with contributor guide (how to edit bars.csv)
- [X] T036 Update README.md with CSV field documentation
- [X] T037 Run quickstart.md validation (verify local setup works)

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1: Setup ──────────────────────────────────────────────┐
                                                             │
Phase 2: Foundational (BLOCKS all stories) ◀─────────────────┘
              │
              ▼
     ┌────────┴────────┐
     │                 │
Phase 3: US1 (P1)  Phase 4: US2 (P1)   ← Can run in parallel
     │                 │
     └────────┬────────┘
              │
     ┌────────┴────────┐
     │                 │
Phase 5: US3 (P2)  Phase 6: US4 (P3)   ← Can run in parallel
     │                 │
     └────────┬────────┘
              │
              ▼
Phase 7: Polish
```

### User Story Independence

| Story | Dependencies | Can Start After |
|-------|--------------|-----------------|
| US1 (Submit Valid Data) | Foundational only | Phase 2 complete |
| US2 (Error Reports) | Foundational only | Phase 2 complete |
| US3 (Restore Version) | US1 workflow exists | T016 complete |
| US4 (Consume Data) | US1 publishing works | T016 complete |

### Parallel Opportunities by Phase

**Phase 1 (Setup)**:
```
T002, T003, T004, T005 can run in parallel (different files)
```

**Phase 2 (Foundational)**:
```
T008, T009 can run in parallel (separate schema files)
```

**Phase 3-4 (US1 + US2)**:
```
After T011 completes:
- US1 tasks (T012-T016) 
- US2 tasks (T017-T024)
Can be worked by different developers simultaneously
```

**Phase 7 (Polish)**:
```
T032, T033, T034, T035 can all run in parallel (different edge cases)
```

---

## Implementation Strategy

### MVP First (Recommended)

1. ✅ Complete Phase 1: Setup (~15 min)
2. ✅ Complete Phase 2: Foundational (~1 hour)
3. ✅ Complete Phase 3: User Story 1 (~45 min)
4. **STOP & VALIDATE**: Push to main, verify JSON published
5. ✅ Complete Phase 4: User Story 2 (~45 min)
6. **STOP & VALIDATE**: Push invalid CSV, verify error page
7. Continue with US3, US4, Polish as needed

### Total Estimated Time

| Phase | Tasks | Est. Time |
|-------|-------|-----------|
| Setup | 5 | 15 min |
| Foundational | 6 | 1 hour |
| US1 | 5 | 45 min |
| US2 | 8 | 45 min |
| US3 | 3 | 15 min |
| US4 | 3 | 20 min |
| Polish | 7 | 30 min |
| **Total** | **37** | **~3.5 hours** |

---

## Notes

- All TypeScript code lives in `webservice/src/`
- Generated output goes to `webservice/public/` (gitignored)
- GitHub Actions deploys `webservice/public/` to `gh-pages` branch
- Error reports always published (even on validation failure)
- Workflow fails exit code but still deploys errors
- Tests NOT included (not explicitly requested in spec)
- GitHub Actions timeout: rely on default timeout (6 hours); workflow naturally fails if runner issues occur
