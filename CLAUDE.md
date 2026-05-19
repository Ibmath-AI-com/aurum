# CLAUDE.md — AURUM Project Instructions for Claude Code

> This file is the **single source of truth** for how Claude Code should work on the AURUM project. Read this first before touching any code.

---

## 1. Project Identity

**Name:** AURUM
**Tagline:** AI-Powered Market Intelligence & Analysis Assistant
**Focus:** Real-time market analysis with a precious-metals emphasis, AI-assisted research, portfolio monitoring, alerts, and institutional-grade reporting.

**Reference documents (already in the repo):**
- `AURUM_Application_Structure_and_Database_Schema.md` — architecture, full DB schema, API route map
- `AURUM_Prototype__4_.html` — UI/UX prototype (frontend design reference)
- `AI-Powered_Market_Intelligence_and_Analysis_Assistant.docx` — product requirements (functional modules)

---

## 2. Hard Rules for Claude Code

These are **non-negotiable**. Follow them on every task.

### 2.1 Phase Discipline
- Work **only on the current phase**. The current phase is tracked in `docs/planning/ROADMAP.md`.
- **Do NOT start the next phase** without explicit user approval. At the end of every phase, stop and ask:
  > *"Phase N complete. All tasks checked off. Proceed to Phase N+1? (yes/no)"*
- **Phase 0 specifically:** build base + database **only**. Do not build any test units, do not scaffold test framework configs, do not write `.test.ts` / `.spec.ts` files. Tests come in a later phase.

### 2.2 Task Tracking
- Every phase file (e.g. `PHASE_0_FOUNDATION.md`) contains a checklist of tasks using `- [ ]` markdown checkboxes.
- After completing a task, edit the phase file and change `- [ ]` to `- [x]`.
- Commit messages must reference the task id, e.g. `feat(db): create users table (P0-T07)`.
- **Never** mark a task complete before the work actually compiles / runs.

### 2.3 Database
- **Host:** remote — `15.135.254.123:5432` (NOT in Docker, NOT local).
- **Name:** `aurumdb` (already exists, started empty).
- **Engine:** PostgreSQL 16, standard build — **TimescaleDB is NOT available**.
- **Available extensions:** `pgcrypto`, `uuid-ossp`.
- Time-series tables (`price_data`, `indicator_data`) use **native `PARTITION BY RANGE (time)`** instead of TimescaleDB hypertables. See `docs/planning/SCHEMA_DEVIATIONS.md` — read this before writing any migration.
- Migrations live in `packages/api/src/database/migrations/`, numbered `001_*.sql`, `002_*.sql`, ...
- **Never** edit a committed migration. Add a new one instead.
- Use `gen_random_uuid()` for UUID PKs. Use `TIMESTAMPTZ` for all timestamps. Use `JSONB` (not `JSON`).
- The spec is `AURUM_Application_Structure_and_Database_Schema.md` section 4. Where it conflicts with `SCHEMA_DEVIATIONS.md`, the deviations doc wins (because it describes what's actually running).
- ⚠️ Migrations run against a **live remote database**. Never run destructive ops casually.

### 2.4 Coding Conventions
- **Language:** TypeScript everywhere (strict mode on).
- **Backend:** Node.js + Fastify, Drizzle ORM, BullMQ (later phases).
- **Frontend:** React 18 + Vite, Tailwind CSS, Zustand, TanStack Query (later phases).
- **Monorepo:** Turborepo. Packages: `common`, `api`, `web` (and later `mobile`).
- **Linting:** ESLint + Prettier. Run before committing.
- **No `any`** unless commented with a justification.
- **No secrets in code.** Use `.env` and `.env.example`.

### 2.5 Communication
- Keep replies to the user concise. Use bullet lists for status; prose for explanations.
- When unsure between two valid approaches, **ask** rather than guess.
- When you finish a task, post a short summary: what changed, which files, which task id checked off.

---

## 3. Repository Layout (target)

```
aurum/
├── docs/
│   └── planning/                  ← phase files & roadmap live here
│       ├── ROADMAP.md
│       ├── SCHEMA_DEVIATIONS.md   ← deviations from the spec (READ FIRST for any DB work)
│       ├── PHASE_0_FOUNDATION.md
│       ├── PHASE_1_AUTH_AND_USERS.md
│       ├── PHASE_2_MARKET_DATA.md
│       ├── PHASE_3_TECHNICAL_ANALYSIS.md
│       ├── PHASE_4_PORTFOLIO_AND_WATCHLISTS.md
│       ├── PHASE_5_NEWS_AND_SENTIMENT.md
│       ├── PHASE_6_ALERTS.md
│       ├── PHASE_7_AI_ASSISTANT.md
│       ├── PHASE_8_REPORTS.md
│       ├── PHASE_9_FRONTEND.md
│       └── PHASE_10_TESTING_AND_HARDENING.md
├── packages/
│   ├── common/
│   ├── api/
│   └── web/
├── infra/
│   └── docker/
└── ...
```

The full target structure is in `AURUM_Application_Structure_and_Database_Schema.md` section 2.

---

## 4. Definition of Done (per phase)

A phase is "done" only when **all** of the following hold:

1. Every task checkbox in the phase file is `- [x]`.
2. Code compiles with zero TS errors (`pnpm typecheck` or `npm run typecheck`).
3. Lint passes (`pnpm lint`).
4. The phase's manual smoke-check (described at the bottom of each phase file) passes.
5. A git commit exists summarizing the phase, e.g. `chore: complete Phase 0 — foundation & db`.
6. You have asked the user for permission to proceed to the next phase.

---

## 5. What NOT to Do

- ❌ Do not install dependencies that aren't needed for the current phase.
- ❌ Do not add features that aren't in the current phase's task list.
- ❌ Do not write tests until **Phase 10** (or unless the user explicitly asks).
- ❌ Do not deploy, dockerize for production, or set up CI in early phases.
- ❌ Do not modify the reference docs (`AURUM_Application_Structure_and_Database_Schema.md` etc.) — they are the spec.
- ❌ Do not invent schema columns that aren't in the spec. If you think the spec is missing something, raise it with the user first.

---

## 6. Starting Point

Right now, the project is at **Phase 0**. Open `docs/planning/PHASE_0_FOUNDATION.md` and start with task **P0-T01**.

Good luck. Build carefully.
